extends Area3D
@export var speed = 32
@export var sound_effect: AudioStream = preload("res://audio/objects/dash_panel.wav")
@export var control_lock_time: float = 1.0

var uv_off: float = 0.0

@onready var _model: MeshInstance3D = $DashPanel/DashPanelMDL

func _ready() -> void:
	$AudioStreamPlayer3D.stream = sound_effect

func _process(delta: float) -> void:
	var mat: StandardMaterial3D = _model.get_active_material(1)
	mat.uv1_offset += Vector3(0,delta/60*speed,0)

func _on_body_entered(body: CharacterBody3D) -> void:
	if body is Physics_Player:
		var player: Physics_Player = body
		player.direction_lock_time = control_lock_time
		player.velocity = -global_basis.z*speed
		player.global_position = Vector3(global_position.x,player.global_position.y,global_position.z)
		player._snap_camera_behind_player()
		$AudioStreamPlayer3D.play()
