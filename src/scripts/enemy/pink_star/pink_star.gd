extends EnemyTemplate
class_name PinkStar

func _ready() -> void:
	randomize()
	drop_list ={
		"Heal Potion": [
			"res://assets/item/consumable/health_potion.png", #path
			25, #chance de drop
			"Health", #Tipo do item
			5, #vida q recupera
			2 #valor de venda
		],
		
		"Mana Potion": [
			"res://assets/item/consumable/mana_potion.png",
			12,
			"Mana",
			5,
			5
		],
		
		"Pink Star Mouth": [
			"res://assets/item/resource/pink_star/pink_star_mouth.png",
			47,
			"Resource",
			{}, #isso é feito pois ele não é consumivel, mas deve se manter o padrão de 5 parametros por item
			5
		],
		"Pink Star Bow": [
			"res://assets/item/equipment/pink_star_bow.png",
			3,
			"Weapon",
			{
				"Attack": 5
			},
			60
		],
		"Pink Star Belt": [
			"res://assets/item/equipment/pink_star_belt.png",
			5,
			"Equipment",
			{
				"Health": 5,
				"Mana": 5
			},
			40
		],
		"Pink Star Shield": [
			"res://assets/item/equipment/pink_star_shield.png",
			2,
			"Weapon",
			{
				"Health": 3,
				"Defense": 2
			},
			75
		]
	}
