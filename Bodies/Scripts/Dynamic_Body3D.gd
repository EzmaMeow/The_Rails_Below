class_name Dynamic_Body3D extends CharacterBody3D 
var collision : KinematicCollision3D
var local_physic_state : Physic_State3D = Physic_State3D.new()

func push(force:Vector3):
	velocity += Vector3(force)
	
func _physics_process(delta: float) -> void:
	var local_physics :Dictionary = get_meta('local_physics',{})
	if local_physics.is_empty():
		if (!is_on_floor()):
			local_physic_state.velocity = local_physic_state.velocity.move_toward(
				Vector3.ZERO,delta
			)
		elif (local_physic_state.velocity != Vector3.ZERO):
			local_physic_state.velocity = Vector3.ZERO
	else:
		local_physic_state.velocity = Vector3.ZERO
		local_physic_state.gravity = Vector3.ZERO
		local_physic_state.global_gravity_strength = 1.0
		for key in local_physics:
			var local_physic : Physic_State3D = local_physics[key]
			if local_physic:
				local_physic_state.velocity += local_physic.velocity
				local_physic_state.gravity += local_physic.gravity
				local_physic_state.global_gravity_strength *= local_physic.global_gravity_strength
	velocity += local_physic_state.velocity + local_physic_state.gravity
	velocity += Vector3(0.0,-9.8*local_physic_state.global_gravity_strength,0.0)
	
	move_and_slide()
	collision = get_last_slide_collision()
	
	if velocity != Vector3.ZERO:
		velocity = velocity.move_toward(Vector3.ZERO,delta*10)
	if (collision):
		for collider_index in range(collision.get_collision_count()-1):
			var dynamic_body := collision.get_collider(collider_index) as Dynamic_Body3D
			if (!dynamic_body):
				continue
			dynamic_body.push(-collision.get_normal(collider_index) * velocity.length()* 0.5)
			velocity -= velocity * 0.5
