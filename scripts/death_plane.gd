extends Area3D


func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node3D) -> void:
	if body is Physics_Player:
		var player: Physics_Player = body
		player._respawn()
