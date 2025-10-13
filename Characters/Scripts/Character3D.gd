class_name Character3D extends CharacterBody3D

@export var controller: Controller3D :
	set(value):
		if (value):
			value.client_message_received.connect(on_message_received)
			value.rotated.connect(on_rotated)
			value.jumped.connect(on_jumped)
		elif (controller):
			controller.client_message_received.disconnect(on_message_received)
			controller.rotated.disconnect(on_rotated)
			controller.jumped.disconnect(on_jumped)
		controller = value

@export var state : Character_State = Character_State.new():
	set(value):
		if (value):
			if (value.unique):
				state = value.duplicate()
				return
		state = value
		
@export var movement : Character_Movement = Character_Movement.new()

@export var camera : Camera3D

var jump_force : float = 0.0
var local_physic_state : Physic_State3D = Physic_State3D.new()

func on_message_received(message:Variant):
	if (message == 'exiting' and camera):
		camera.current = false
	elif (message == 'entering' and camera):
		camera.current = true

func on_rotated(axis:Vector3,angle:float):
	if (axis==Vector3.UP and camera):
		camera.rotate_x(angle)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))
		return
	if (axis==Vector3.RIGHT):
		rotate_y(angle)
		return
func on_jumped(strength:float=1.0):
	if (is_on_floor()):
		#todo: could grab local gravity and make the jump stronger or weaker
		jump_force = 10.0 *strength
	
func _physics_process(_delta: float) -> void:
	var local_physics :Dictionary = get_meta('local_physics',{})
	#var local_velocity:Vector3
	#var local_gravity:Vector3
	#var global_gravity_strength:float = 1.0
	#todo: should make this an object or resource.
	#resource may be useful in this case since some
	#values could be config in editor
	if local_physics.is_empty():
		if (!is_on_floor()):
			local_physic_state.velocity = local_physic_state.velocity.move_toward(
				Vector3.ZERO,_delta
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
	if (controller):
		if (movement):
			velocity = movement.caculate_velocity3D(
				velocity,position,_delta,controller.move_direction,state,get_last_slide_collision()
				)
			velocity += Vector3(0.0,jump_force,0.0)
			velocity = velocity.rotated(Vector3(0,1,0).normalized(),rotation.y)
			velocity += local_physic_state.velocity + local_physic_state.gravity
			#Note: unable to get moving tunnel from move and slide results since
			#the mesh owner and parent is its mesh instance handler. may need to fake
			#it by using a collsion layer for out of bound and then have the level
			#yet the player down the tunnel (and slow the tunnel(train) speed)
			move_and_slide()
			
			
			if (!is_on_floor()):
				#appling fake gravity for now
				if (jump_force > -9.8 * local_physic_state.global_gravity_strength):
					jump_force = clamp(jump_force - 1.0,-9.8,9999)
				
			#testing a pushable object. using a character since it is easier
			#to move, but wont have any rotation unless coded in. Rigid bodies
			#are too glitch and static bodies require floor checking
			#NOTE: pushable object may not be common on the rails below
			#project. fake spining when falling off the train(if added) or simple
			#pushing object in static zone. some rigid objects may be used for
			#non-gameplay props. 
			var collision := get_last_slide_collision()
			if (collision):
				for collider_index in range(collision.get_collision_count()-1):
					var dynamic_body := collision.get_collider(collider_index) as Dynamic_Body3D
					if (dynamic_body):
						dynamic_body.push(-collision.get_normal(collider_index)*velocity.length()*0.5)
