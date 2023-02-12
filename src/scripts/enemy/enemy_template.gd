extends KinematicBody2D
class_name EnemyTemplate

signal kill

onready var texture: Sprite = get_node("Texture")
onready var floor_ray: RayCast2D = get_node("FloorRay")
onready var animation: AnimationPlayer = get_node("Animation")

var can_die: bool = false
var can_hit: bool = false
var can_attack: bool = false

var drop_bonus: int = 1
var attack_animation_suffix: String = "_left"

var velocity: Vector2
var drop_list: Dictionary
var player_ref: Player = null


export(int) var enemy_exp
export(int) var speed 
export(int) var gravity_speed
export(int) var proximity_threshold # limite da distancia para parar de perseguir e começar a atacar
export(int) var raycast_default_position

export(PackedScene) var floating_text


func _physics_process(delta: float) -> void:
	gravity(delta)
	move_behavior()
	verify_position()
	texture.animate(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
func gravity(delta: float) -> void:
	velocity.y += delta * gravity_speed
	
	
func move_behavior() -> void:
	if player_ref != null: # siginifica que há personagem dentro da detection area
		var distance: Vector2 = player_ref.global_position - global_position		
		var direction: Vector2 = distance.normalized() #associar o valor de distancia normalizado, ou seja, entre -1 e 1
		if abs(distance.x) <= proximity_threshold: #se a distancia for menor q o alcance do ataque
			velocity.x = 0
			can_attack = true
		elif floor_collision() and not can_attack: #para ele não cair da plataforma
			velocity.x = direction.x * speed
			
		else:
			velocity.x = 0
			
		return		
		
	velocity.x = 0 
	

func floor_collision() -> bool:
	if floor_ray.is_colliding():
		return true
	else:
		return false


func verify_position() -> void:
	if player_ref != null:
		var direction: float = sign(player_ref.global_position.x - global_position.x) # o sign de qlq numero positivo é 1 e de qlq negativo é -1
		
		if direction > 0:
			texture.flip_h = true
			attack_animation_suffix = "_right"
			floor_ray.position.x = abs(raycast_default_position)
		elif direction < 0:
			texture.flip_h = false
			attack_animation_suffix = "_left"
			floor_ray.position.x = raycast_default_position
				
				
func kill_enemy() -> void:
	emit_signal("kill")
	animation.play("kill")
	get_tree().call_group("player_stats", "update_exp", enemy_exp)
	spawn_item_probability()
	
func spawn_item_probability() -> void:
	var random_number:int = randi() %21 #retorna um num aleat entre 0 e 20
	if random_number <= 6:
		drop_bonus = 1
	elif random_number >= 7 and random_number <= 13:
		drop_bonus = 2
	else:
		drop_bonus = 3 
	
	print("Multiplicador de Drop: " + str(drop_bonus))
	for key in drop_list.keys():
		var rng: int = randi() % 100 + 1
		if rng <= drop_list[key][1] * drop_bonus:
			var item_texture: StreamTexture = load(drop_list[key][0])
			var item_info: Array = [drop_list[key][0], drop_list[key][2], drop_list[key][3], drop_list[key][4], 1]
			
			spawn_physic_item(key, item_texture, item_info)
			
			
func spawn_physic_item(key: String, item_texture: StreamTexture, item_info:Array) -> void:
		var physic_item_scene = load("res://scenes/env/physic_item.tscn")
		var item: PhysicItem = physic_item_scene.instance()
		get_tree().root.call_deferred("add_child", item) 
		#na linha acima o item foi instanciado em paralelo, pois caso fosse
		#instanciado como filho do monstro, ele sumiria com o queue_free
		item.global_position = global_position #para spawnar no mob
		item.update_item_info(key, item_texture, item_info)
		
	
func spawn_floating_text(type_sign: String, type: String, value: int):
	var text: FloatText = floating_text.instance()
	text.rect_global_position = global_position
	
	text.type = type
	text.value = value
	text.type_sign = type_sign
	
	get_tree().root.call_deferred("add_child", text)
