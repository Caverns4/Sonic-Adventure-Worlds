class_name Character
extends CharacterBody3D

@export_category("Objects")
@export var character_skin: CharacterAvatar

#@onready var hurtboxes: Array[HitReciever]
#@onready var hitblockers: Array[HitBlocker]

@onready var pivot: Node3D = $Pivot
@onready var state_container: Node = $StateContainer
@onready var states_list: Array[State] = []
var current_state: State


func _ready() -> void:
	if character_skin: character_skin.parent = self
	call_deferred('setup_states')

func setup_states(state_name: String = "Free") -> void:
	var entry_state: State = null
	states_list.clear()
	for i in state_container.get_children():
		if i is State:
			states_list.append(i)
			if i.state_name == state_name:
				entry_state = i
	if states_list:
		if entry_state:
			current_state = entry_state
			current_state.enter_state(false)
		else:
			current_state = states_list[0]
			current_state.enter_state(false)

func change_state(new_state: StringName, params: Variant) -> bool:
	for i in states_list:
		if i.state_name == new_state:
			current_state.exit_state()
			current_state = i
			i.enter_state(params)
			return true
	print("State change failed to " + new_state)
	return false

func can_enter_state(new_state: StringName) -> bool:
	if !new_state: return false
	for i in states_list:
		if i.name == new_state:
			return i.can_enter_state()
	return false

func _physics_process(delta: float) -> void:
	if current_state:
		current_state._process_state(delta)
