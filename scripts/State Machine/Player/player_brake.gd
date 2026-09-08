extends State

func _ready() -> void:
	super()
	player.player_skin.animation_player.animation_finished.connect(on_animation_finished)

func can_enter_state() -> bool:
	if player.is_on_floor(): return true
	return false

func enter_state(_params: Variant) -> void:
	player.player_skin.apply_animation("Brake")
	player.player_skin.anim_override = true

func _process_state(delta: float) -> void:
	player.apply_gravity(delta)
	player.velocity = move_on_ground(delta)
	player.check_jump_button()
	var direction: Vector3 = player.velocity
	if direction.length() > 1.0:
		player.check_on_floor(delta,direction.normalized())
	else:
		player.move_and_slide()
	
	if !player.is_on_floor():
		player.change_state("Air",player.jumping)
	else:
		player.player_skin.animate_on_ground(player.velocity)

func move_on_ground(delta: float) -> Vector3:
	# keep a copy of the previous velocity
	var previous_velocity = player.velocity.dot(player.up_direction)
	var new_vel: Vector3 = player.velocity
	new_vel = (player.velocity.slide(player.up_direction).move_toward(
		Vector3.ZERO,delta*player.braking_rate)+previous_velocity*player.up_direction)
	return new_vel

func on_animation_finished(_anim_name: StringName) -> void:
	if player.current_state == self:
		player.player_skin.anim_override = false
		player.change_state("Free",false)
