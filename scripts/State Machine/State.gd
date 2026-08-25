class_name State
extends Node

## The name of the state.
@export var state_name: StringName = "State"
## States should always be kept in a State container for cleanliness.
@onready var parent: Character = get_parent().get_parent()
@onready var character_skin: CharacterAvatar = null

var player: Physics_Player = null

func _ready() -> void:
	#if parent: character_skin = parent.character_skin
	if parent is Physics_Player: player = parent

func can_enter_state() -> bool:
	return true

func enter_state(_params: Variant) -> void:
	pass

func exit_state() -> void:
	pass

func _process_state(_delta: float) -> void:
	pass
