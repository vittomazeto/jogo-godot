extends EnemyTemplate
class_name Whale

func _ready() -> void:
	randomize()
	drop_list ={
		"Heal Potion": [
			"res://assets/item/consumable/health_potion.png", #path
			20, #chance de drop
			"Health", #Tipo do item
			5, #vida q recupera
			2 #valor de venda
		],
		
		"Mana Potion": [
			"res://assets/item/consumable/mana_potion.png",
			15,
			"Mana",
			5,
			5
		],
		
		"Whale Mouth": [
			"res://assets/item/resource/whale/whale_mouth.png",
			45,
			"Resource",
			{}, #isso é feito pois ele não é consumivel, mas deve se manter o padrão de 5 parametros por item
			2
		],
		"Whale Eye": [
			"res://assets/item/resource/whale/whale_eye.png",
			15,
			"Resource",
			{},
			6
		],
		"Whale Tail": [
			"res://assets/item/resource/whale/whale_tail.png",
			5,
			"Resource",
			{},
			25
		],
		"Whale mask": [
			"res://assets/item/equipment/whale_mask.png",
			5,
			"Equipment",
			{
				"Mana": 5,
				"Magic Attack": 3 #o dicionario foi usado para os atributos que a mask vai dar
			},
			30
		]
	}
