extends TextureRect
class_name ConsumableContainer

onready var consumable_item: TextureRect = get_node("Item")
onready var consumable_amount: Label = get_node("Amount")

var consumable_item_name: String = ""
var consumable_item_type: String = ""
var consumable_texture_path: String = ""

var consumable_item_price: int
var consumable_item_amount: int
var consumable_item_type_value: int

var can_click: bool = false

func update_consumable_slot(item_texture: StreamTexture, item_info: Array) -> void:
	if item_info[2] == consumable_item_name:
		consumable_item_amount += item_info[1]
		
		if consumable_item_amount > 9:
			var leftover: int = consumable_item_amount - 9
			item_info[1] = leftover
			consumable_item_amount = 9
			
			get_tree().call_group(
				"inventory",
				"update_slot",
				consumable_item_name,
				consumable_item.texture,
				[
					consumable_texture_path,
					consumable_item_type,
					consumable_item_type_value,
					consumable_item_price,
					leftover
				]
			)
			
		consumable_amount.text = str(consumable_item_amount)
		return
		
	if consumable_item_name != "":
		get_tree().call_group(
				"inventory",
				"update_slot",
				consumable_item_name,
				consumable_item.texture,
				[
					consumable_texture_path,
					consumable_item_type,
					consumable_item_type_value,
					consumable_item_price,
					consumable_item_amount
				]
			)
			
	consumable_texture_path = item_info[0]
	consumable_item_amount = item_info[1]
	consumable_item_name = item_info[2]
	consumable_item_type = item_info[3]
	consumable_item_type_value = item_info[4]
	consumable_item_price = item_info[5]
	
	consumable_amount.text = str(consumable_item_amount)
	consumable_item.texture = item_texture
	consumable_amount.show()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and can_click:
		if consumable_item_amount > 0:
			match consumable_item_type:
				"Health":
					get_tree().call_group("player_stats", "update_health", "Increase", consumable_item_type_value)
					
				"Mana":
					get_tree().call_group("player_stats", "updadate_mana", "Increase", consumable_item_type_value)
					
			consumable_item_amount -= 1
			
			if consumable_item_amount == 0:
				reset()
				
			consumable_amount.text = str(consumable_item_amount)




	
	
func reset() -> void:
	consumable_item_name = ""
	consumable_item_type = ""
	consumable_texture_path = ""
	
	consumable_item_price = 0
	consumable_item_type_value = 0
	
	consumable_amount.hide()
	consumable_item.texture = null
	


func _on_ConsumableBackground_mouse_entered():
	modulate.a = 0.5
	can_click = true


func _on_ConsumableBackground_mouse_exited():
	modulate.a = 1.0
	can_click = false
