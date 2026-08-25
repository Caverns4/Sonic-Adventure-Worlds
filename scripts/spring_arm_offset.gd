extends Node3D
class_name SpringArmCharacter

const MOUSE_SENSIBILITY: float = 0.005

func _physics_process(delta: float) -> void:
	var camera_dir: float = Input.get_axis("cam_left","cam_right")*3
	rotate_y(camera_dir*delta)
