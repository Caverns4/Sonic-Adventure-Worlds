extends Node3D
class_name CharacterAvatar

const LERP_VELOCITY: float = 0.15

@export_category("Objects")
## Setup automatically by the parent
@export var parent: Physics_Player = null
@export var animation_player: AnimationPlayer = null
@export var jump_ball: NodePath = ''
@export var super_state_handler: Node
@export var attachments: Array[AnimatedAttachment] = []

var last_anim: String = ''
var next_anim: String = ''
var anim_override: bool = false
var idle_time: float = 0.0

func _ready() -> void:
	print(parent.name)
	if animation_player:
		animation_player.animation_finished.connect(on_animation_finished)

func _physics_process(delta: float) -> void:
	update_animation_speed()
	if !parent.velocity:
		idle_time += delta
	else:
		idle_time = 0.0


func animate(_velocity: Vector3) -> void:
	if parent.is_on_floor():
		animate_on_ground(_velocity)
	else:
		animate_in_air(_velocity)


func animate_on_ground(_velocity: Vector3) -> void:
	if !animation_player or !parent or anim_override:
		return
	if _velocity.length() > parent.speed_margin:
		if parent.is_super:
			next_anim = 'Super_Run'
		else:
			next_anim = 'Run'
	elif _velocity.length() > 0.0:
		next_anim = 'Jog'
	elif idle_time < 6.0:
		next_anim = 'Idle'
	else:
		next_anim = 'IdleWait'
	apply_animation()

func animate_in_air(_velocity: Vector3) -> void:
	if !animation_player or !parent or anim_override:
		return
	if !parent.is_on_floor():
		if _velocity.y < 0:
			next_anim = 'Fall'
		else:
			var current_anim = animation_player.current_animation
			if current_anim != "Jump" and current_anim != "Jump2":
				next_anim = 'Jump'
	apply_animation()


func on_animation_finished(anime_name: StringName) -> void:
	anim_override = false
	if anime_name == 'IdleWait':
		idle_time = 0.0
	if anime_name == 'Brake':
		parent.pivot.rotate(parent.up_direction,deg_to_rad(180))
		parent.pivot.rotation.y = parent.angle
		parent.movement_locked = false
		parent.velocity = Vector3.ZERO

func play_jump_animation(jump_type: String = "Jump") -> void:
	apply_animation(jump_type)

func apply_animation(anim_name: StringName = "") -> void:
	if anim_name: next_anim = anim_name
	if next_anim and next_anim != last_anim and animation_player:
		for i: AnimatedAttachment in attachments:
			i.change_animation(next_anim)
		animation_player.play(next_anim)
		last_anim = next_anim

func update_super_state(is_super: bool) -> void:
	if super_state_handler:
		super_state_handler.setmodel(is_super)
	else:
		is_super = false

var speed_based_animations: Array[String] = ["Walk","Run"]

func update_animation_speed() -> void:
	if !parent: return
	if !animation_player: return
	if anim_override:
		animation_player.speed_scale = 1.0
		return
	var speed_scale: float = 1.0
	for i in speed_based_animations:
		if animation_player.current_animation.find(i) >= 0:
			speed_scale = clampf(parent.velocity.length()/10,0.1,8.0)
			break
	animation_player.speed_scale = speed_scale
