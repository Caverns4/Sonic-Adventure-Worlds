extends Area3D
@export var speed = 32
@export var sound_effect: AudioStream = preload("res://audio/objects/dash_panel.wav")

var uv_off: float = 0.0

@onready var _model: MeshInstance3D = $DashPanel/DashPanelMDL

func _ready() -> void:
	$AudioStreamPlayer3D.stream = sound_effect

func _process(delta: float) -> void:
	var mat: StandardMaterial3D = _model.get_active_material(1)
	mat.uv1_offset += Vector3(0,delta/60*speed,0)

func _on_body_entered(body: CharacterBody3D) -> void:
	body.velocity = -global_basis.z*speed
	body.global_position = Vector3(global_position.x,body.global_position.y,global_position.z)
	body._snap_camera_behind_player()
	$AudioStreamPlayer3D.play()
