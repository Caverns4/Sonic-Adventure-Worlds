extends Button

@export var base_text: String = ""

var button_id: int = 0
signal button_change(num_id: int)

func _on_pressed() -> void:
	$SFX.play()
	button_change.emit(button_id)


func _on_focus_exited() -> void:
	pass


func update_text(suffix: String) -> void:
	text = base_text + suffix
