extends Button

@export var text_string: String = ""
@export var scene_to_load: String = ""

signal start_level(scene: String)
signal play_menu_sound

func _on_pressed() -> void:
	start_level.emit(scene_to_load)


func _on_focus_exited() -> void:
	play_menu_sound.emit()
