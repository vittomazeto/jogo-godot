extends Node2D
class_name Level

onready var player: KinematicBody2D = get_node("Player") # esse código serve para não ter que fazer isso toda vez que criar um novo nível

func _ready() -> void:
	var _game_over: bool = player.get_node("Texture").connect("game_over", self, "on_game_over") #isso vai conectar o código ao sinal game over do nó filho player
	
	
func on_game_over() -> void:
	var _reload: bool = get_tree().reload_current_scene() #esse código reinicia a cena
	
	
