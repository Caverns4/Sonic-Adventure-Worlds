class_name AnimatedAttachment
extends Node3D

@onready var animator: AnimationPlayer = $AnimationPlayer
@export var deafult_anim_blend_time: float = 0.2

@export_group("Animations names")
@export var idle_animation: StringName = "Tail_Idle"
@export var walk_animation: StringName = "Tail_Run"
@export var run_animation: StringName = "Tail_Fly"
@export var jump_animation: StringName = "Tail_Jump"
@export var fall_animation: StringName = "Tail_Fall"

var last_action: String = ""

func _ready() -> void:
	if animator:
		animator.playback_default_blend_time = deafult_anim_blend_time

# TODO: make a system where the use can define patterns instead of explicit checks.
func change_animation(incoming_action: StringName) -> void:
	if !animator or incoming_action == last_action: return
	
	match incoming_action:
		"Idle":
			animator.play(idle_animation)
		"Walk","Jog":
			animator.play(walk_animation)
		"Run":
			animator.play(run_animation)
		"Jump":
			animator.play(jump_animation)
		"Fall":
			animator.play(fall_animation)
		"Fly":
			animator.play(run_animation)
	last_action = incoming_action
