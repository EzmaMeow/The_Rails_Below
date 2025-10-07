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
		jump_force = 10.0 *strength
	
func _physics_process(_delta: float) -> void:
	if (controller):
		if (movement):
			velocity = movement.caculate_velocity3D(
				velocity,position,_delta,controller.move_direction,state,get_last_slide_collision()
				)
			velocity += Vector3(0.0,jump_force,0.0)
			velocity = velocity.rotated(Vector3(0,1,0).normalized(),rotation.y)
			#Note: unable to get moving tunnel from move and slide results since
			#the mesh owner and parent is its mesh instance handler. may need to fake
			#it by using a collsion layer for out of bound and then have the level
			#yet the player down the tunnel (and slow the tunnel(train) speed)
			move_and_slide()
			
			
			if (!is_on_floor()):
				#appling fake gravity for now
				if (jump_force > -9.8):
					jump_force = clamp(jump_force - 1.0,-9.8,9999)
				
