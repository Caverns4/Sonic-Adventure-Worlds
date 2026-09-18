extends State

var start_elevation: float = 0.0

func enter_state(_params: Variant) -> void:
	player.player_skin.apply_animation("Fly")
	player.player_skin.anim_override = true
	start_elevation = player.global_position.y

func _process_state(delta: float) -> void:
	var direction: Vector3 = player.get_direction_from_Input()
	
	if Input.is_action_pressed("jump") and parent.global_position.y < start_elevation+5:
		parent.velocity.y += delta*player.base_aceleration
	elif Input.is_action_pressed("jump"):
		parent.velocity.y = move_toward(parent.velocity.y,0.0,delta*player.base_aceleration)
	else:
		player.apply_gravity(delta*0.5)
	parent.velocity.y = clampf(parent.velocity.y,-8,8)
	
	#player.apply_gravity(delta)
	player.velocity = move_in_air(delta,direction)
	player.check_on_floor(delta,direction)
	if player.player_skin: player.player_skin.animate_in_air(player.velocity)
	if player.is_on_floor():
		player.change_state("Free",false)
		player.land_sfx.play()

func move_in_air(delta: float, direction: Vector3) -> Vector3:
	# keep a copy of the previous velocity
	var previous_velocity = player.velocity.dot(player.up_direction)
	var new_vel: Vector3 = player.velocity
	# direction check (check that direction is being pressed)
	if direction and !player.movement_locked:
		## Get the angle diff of the input to move direction. 1.0 means same, 0 means 90 degrees, -1 means backwards. 
		var dot: float = player.velocity.normalized().dot(direction.normalized())
		## Get the player's accelateration.
		var accel_amt: float =player. base_aceleration - (dot-1)*8
		var current_top_speed: float = player.top_speed*3.0
		if player.is_super:
			accel_amt *= 1.5
			current_top_speed *= 1.5
		new_vel = (player.velocity.slide(player.up_direction).move_toward(
			-player.pivot.global_basis.z*current_top_speed,accel_amt * delta
		) + (previous_velocity*player.up_direction))
	else:
		new_vel = (player.velocity.slide(player.up_direction).move_toward(
			Vector3.ZERO,delta*30)+previous_velocity*player.up_direction)
	return new_vel
