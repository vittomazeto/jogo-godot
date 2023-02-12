extends Sprite
class_name PlayerTexture

signal game_over

var suffix: String = "_right"
var normal_attack: bool = false
var magic_attack: bool = false
var shield_off: bool = false
var crouching_off: bool = false

export(NodePath) onready var animation = get_node(animation) as AnimationPlayer # Essa linha de código é responsável por pegar o caminho, após o onready, do Animation, que é um nó irmão, e então permitir o acesso a ela com o get_node o export(Nodepath) permite que selecione o caminho de maneira fácil no menuzinho
export(NodePath) onready var player = get_node(player) as KinematicBody2D
export(NodePath) onready var attack_collision = get_node(attack_collision) as CollisionShape2D																																									

func animate(direction: Vector2) -> void:
	verify_position(direction) # Responsável por flipar no eixo X
	
	if player.on_hit or player.dead:
		hit_behavior()
	elif player.attacking or player.defending or player.crouching or player.next_to_wall():
		action_behavior()
	elif direction.y != 0:
		vertical_behavior(direction)
	elif player.landing == true: 
		animation.play('landing')
		player.set_physics_process(false)
	else:
		horizontal_behavior(direction) # Responsável por ver se está correndo
	
func verify_position(direction: Vector2) -> void:  #
	if direction.x > 0:     # o zero não é considerado em ambos os casos
		flip_h = false      # pq se fosse ele mudaria a direção da visão
		suffix = '_right'   #sufixo para alterar a posição do ataque
		player.direction = -1
		player.spell_offset = Vector2(100, -50)
		player.flipped = false
		position = Vector2.ZERO
		player.wall_ray.cast_to = Vector2(5.5, 0)
	elif direction.x < 0:   
		flip_h = true
		suffix = '_left'
		player.direction = 1
		player.spell_offset = Vector2(-100, -50)
		player.flipped = true
		position = Vector2(-2, 0) #adicionando pequeno offset
		player.wall_ray.cast_to = Vector2(-7.5, 0)
		

func hit_behavior() -> void:
	player.set_physics_process(false) # para player nao se mover durante hit
	attack_collision.set_deferred("disabled", true)
	if player.dead:
		animation.play('dead')
	elif player.on_hit:
		animation.play('hit')


func action_behavior() -> void:
	if player.next_to_wall():
		animation.play("wall_slide")
	elif player.attacking and normal_attack:
		animation.play("attack" + suffix) # o sufixo é para saber qual posição ele está atacando
	elif player.attacking and magic_attack:
		animation.play("spell_attack")	
	elif player.defending and shield_off:
		animation.play("shield")
		shield_off = false #não vai chamar repetidas vezes a animação, mas vai segurar a posição no ultimo frame
	elif player.crouching and crouching_off:
		animation.play("crouch")
		crouching_off = false

func vertical_behavior(direction: Vector2) -> void:
	if direction.y > 0:
		player.landing = true  #isso torna o player landing true, para executar a animação ao tocar no chão
		animation.play("fall")
	elif direction.y < 0:
		animation.play("jump")
		
		
func horizontal_behavior(direction: Vector2) -> void:
	if direction.x != 0:     
		animation.play("run") 
	else:
		animation.play("idle")


func on_animation_finished(anim_name: String): # essa função diz o que fazer com o fim de cada função especificada, mto foda
	match anim_name:
		"landing": # se a animação landing acabou de terminar, o player.landing se tornará falso, para a animação não se repetir infinitamente
			player.landing = false
			player.set_physics_process(true)
			
		"attack_left":
			normal_attack = false
			player.attacking = false
			
		"attack_right":
			normal_attack = false
			player.attacking = false
			
		"hit":
			player.on_hit = false
			player.set_physics_process(true)
			
			if player.defending: # isso faz com que ao tomar o hit ele execute a animação, mas volte ao estado anterior ao final
				animation.play("shield")
				
			if player.crouching:
				animation.play("crouch")
				
		"dead":
			emit_signal('game_over')
		
		"spell_attack":
			magic_attack = false
			player.attacking = false
