extends Node

@export var normal_model: NodePath = ''
@export var super_model: NodePath = ''

func _ready():
	setmodel(false)

func setmodel(super_state: bool) -> void:
	if normal_model and super_model:
		get_node(normal_model).visible = !super_state
		get_node(super_model).visible = super_state
