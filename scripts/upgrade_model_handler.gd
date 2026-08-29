extends Node

func _ready() -> void:
	update_upgrades()

func update_upgrades():
	pass # Rewrite entirely
	#for i:int in upgrade_models.size():
	#	var model: MeshInstance3D = get_node_or_null(upgrade_models[i])
	#	if model:
	#		var key: StringName = upgrade_names[i]
	#		var vis: bool = Global.character_upgrades.get(key, false)
	#		model.visible = vis
