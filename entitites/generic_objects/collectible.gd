extends Area3D


@onready var audio_stream: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var collider: CollisionShape3D = $CollisionShape3D

var enabled: bool = true

func _on_body_entered(body: CharacterBody3D) -> void:
	collect(body)

func collect(_player: CharacterBody3D):
	enabled = false
	audio_stream.play()
	call_deferred('disable_collision')

func disable_collision():
	collider.disabled = true
