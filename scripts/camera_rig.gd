extends Node3D


const ZOOM_POSITION_SPEED = 3.0
const ZOOM_ROTATION_SPEED = 16.0

@export var camera_zoom_min: float = 1.5
@export var camera_zoom_max: float = 6.0

@onready var camera: Camera3D = $SpringArm3D/Camera3D
@onready var spring: SpringArm3D = $SpringArm3D

var parent: Physics_Player = null
var zoom_target: float = 2.0
var player_controled: bool = true
var allow_updates: bool = true

func _ready() -> void:
	parent = get_parent()

func _physics_process(delta: float) -> void:
	if !allow_updates: return
	_normal_camera(delta)

func _normal_camera(delta:float) -> void:
	global_position = global_position.move_toward(
		parent.global_position+Vector3(0,0.6,0),
		max(ZOOM_POSITION_SPEED,parent.velocity.length())*delta)
	if player_controled:
		var side_amount: float = get_camera_rotation() 
		var cam_dir: float = Input.get_axis("cam_left","cam_right")
		var player_movement_lr: float = clampf(side_amount,-1.0,1.0)*-0.5
		if cam_dir:
			do_manual_camera_rotation(cam_dir,delta)
		elif abs(player_movement_lr) > 0.35:
			rotate_y(cam_dir+player_movement_lr*delta)
		do_camera_zoom(delta)

func get_camera_rotation() -> float:
	var character_motion: Vector3 = parent.velocity
	var cam_right:Vector3 = camera.global_transform.basis.x
	cam_right.y = 0
	return character_motion.dot(cam_right)

func do_manual_camera_rotation(cam_dir: float,delta: float) -> void:
	if cam_dir:
		rotate_y(cam_dir*delta*3)

func do_camera_zoom(delta: float) -> void:
	zoom_target = clamp(parent.velocity.length(),camera_zoom_min,camera_zoom_max)
	spring.spring_length = move_toward(spring.spring_length,zoom_target,delta*4)
