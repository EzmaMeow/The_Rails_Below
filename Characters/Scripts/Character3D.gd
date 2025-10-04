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
		#NOTE: states are base on a static state,
		#but contains dynamic state as well
		#so the state may or maynot contain a static state ref to acess
		#read only value.
		#in short, the state is a copy of an existing state at this level
		#NOTE: may need to rethink this one. states could be shared, but
		#it could be messy. if needed to be shared, then maybe embed it in
		#this clone as a seprate state and have the getters and setters return 
		#that source
		state = value.duplicate()
@export var movement : Character_Movement = Character_Movement.new()
		
@export var speed : float = 8
		
var move_direction : Vector3
var jump_force : float = 0.0

func on_message_received(message:Variant):
	if (message):
		#if message.has('Jump') :#and is_on_floor():
			#jump_force = 10.0
	#		var input_direction : Vector2 = message['direction']
	#		#move_direction = Vector3(input_direction.x, input_direction.y,0.0)
	#		move_direction = Vector3(input_direction.y,0.0,-input_direction.x)
		pass

func on_rotated(axis:Vector3,angle:float):
	if (axis==Vector3.UP):
		$Camera3D.rotate_x(angle)
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-30), deg_to_rad(60))
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
			move_and_slide()
			
			if (!is_on_floor()):
				#appling fake gravity for now
				if (jump_force > -9.8):
					jump_force = clamp(jump_force - 1.0,-9.8,9999)
				
