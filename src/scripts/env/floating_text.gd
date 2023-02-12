extends Label
class_name FloatText

onready var tween: Tween = get_node("Tween")

var value: int
var mass: int = 20

var velocity: Vector2
var gravity: Vector2 = Vector2.UP

var type: String = ""
var type_sign: String = ""

export(Color) var exp_color
export(Color) var heal_color
export(Color) var mana_color
export(Color) var damage_color

func _ready() -> void:
	randomize()
	velocity = Vector2(
		rand_range(-10, 10),
		-30
	)
	
	floating_text()
	
	
func floating_text() -> void:
	text = type_sign + str(value)
	match type:
		"Exp":
			modulate = exp_color # muda a cor do objeto
		
		"Heal": 
			modulate = heal_color
			
		"Mana":
			modulate = mana_color
			
		"Damage":
			modulate = damage_color
			
	interpolate()
	
	
func interpolate() -> void:
	var _interpolate_modulate: bool = tween.interpolate_property( #sumir em visibilidade
		self,
		"modulate:a", #modula alpha
		1.0,     # vai de 100% visivel
		0.0,  #para 0%
		0.3, #em 0.3 segs
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT,
		0.7 #tempo de delay 
	)
	
	var _interpolate_scale_up: bool = tween.interpolate_property( # surgir
		self,
		"rect_scale",
		Vector2(0.0, 0.0),
		Vector2(1.0, 1.0),
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	
	var _interpolate_scale_down: bool = tween.interpolate_property( #sumir em escala
		self,
		"rect_scale",
		Vector2(1.0, 1.0),
		Vector2(0.4, 0.4),
		1.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT,
		0.6
	)

	var _start: bool = tween.start()
	yield(tween, "tween_all_completed") # vai esperar todos os tween terminarem
	queue_free() #deleta o floating text



func _process(delta: float) -> void:
	velocity += gravity * mass * delta
	rect_position += velocity * delta
	
	
