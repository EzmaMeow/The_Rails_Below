class_name Character3D extends CharacterBody3D

@export var controller: Controller3D :
	set(value):
		if (value):
			value.client_message_received.connect(on_message_received)
			value.rotated.connect(on_rotated)
		elif (controller):
			controller.client_message_received.disconnect(on_message_received)
			controller.rotated.disconnect(on_rotated)
		controller = value

@export var state : Character_State = Character_State.new():
	set(value):
		#NOTE: states are base on a static state,
		#but contains dynamic state as well
		#so the state may or maynot contain a static state ref to acess
		#read only value.
		#in short, the state is a copy of an existing state at this level
		state = value.duplicate()
@export var movement : Character_Movement = Character_Movement.new()
		
@export var speed : float = 8
		
var move_direction : Vector3


func on_message_received(message:Variant):
	#if (message):
	#	if message.has('direction'):
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

func _physics_process(_delta: float) -> void:
	if (controller):
		if (movement):
			move_and_slide()
			velocity = movement.caculate_velocity3D(
				velocity,position,_delta,controller.move_direction,state,get_last_slide_collision()
				)
			velocity = velocity.rotated(Vector3(0,1,0).normalized(),rotation.y)
