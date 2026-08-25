extends Node

@export_group("Sonic Upgrades")
@export var light_shoes: NodePath = ''
@export var bounce_bracelet: NodePath = ''
@export var flame_ring_hero: NodePath = ''
@export var magic_gloves: NodePath = ''

@export_group("Tails Upgrades")
@export var booster: NodePath = ''
@export var bazooka: NodePath = ''
@export var tails_laser_blaster: NodePath = ''

@export_group("Knuckles_Upgrades")
@export var shovel_claw: NodePath = ''
@export var air_necklace: NodePath = ''
@export var hammer_gloves: NodePath = ''
@export var sunglasses: NodePath = ''

@export_group("Eggman Upgrades")
@export var jet_engine: NodePath = ''
@export var large_cannon: NodePath = ''
@export var protection_armor: NodePath = ''
@export var eggman_laser_blaster: NodePath = ''

@onready var upgrade_models: Array[NodePath] = [
	light_shoes,bounce_bracelet,flame_ring_hero,magic_gloves,
	booster,bazooka,tails_laser_blaster,
	shovel_claw,air_necklace,hammer_gloves,sunglasses,
	jet_engine,large_cannon,protection_armor,eggman_laser_blaster
]
var upgrade_names: Array[StringName] = [
'Sonic Light Shoes',
'Sonic Bounce Bracelet',
'Sonic Flame Ring',
'Sonic Magic Gloves',
'Tails Booster',
'Tails Bazooka',
'Tails Laser Blaster',
'Knuckles Shovel Claw',
'Knuckles Air Necklace',
'Knuckles Hammer Gloves',
'Knuckles Sunglasses',
'Eggman Jet Engine',
'Eggman Large Cannon',
'Eggman Protection Armor',
'Eggman Laser Blaster',
]

func _ready() -> void:
	update_upgrades()

func update_upgrades():
	for i:int in upgrade_models.size():
		var model: MeshInstance3D = get_node_or_null(upgrade_models[i])
		if model:
			var key: StringName = upgrade_names[i]
			var vis: bool = Global.upgrade_flags.get(key, false)
			model.visible = vis
