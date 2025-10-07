class_name Character2D extends CharacterBody2D


@export var controller: Controller2D :
	set(value):
		if (value):
			value.client_message_received.connect(on_message_received)
			#value.rotated.connect(on_rotated)
			#value.jumped.connect(on_jumped)
		elif (controller):
			controller.client_message_received.disconnect(on_message_received)
			#controller.rotated.disconnect(on_rotated)
			#controller.jumped.disconnect(on_jumped)
		controller = value

@export var state : Character_State = Character_State.new():
	set(value):
		if (value):
			if (value.unique):
				state = value.duplicate()
				return
		state = value
@export var movement : Character_Movement = Character_Movement.new()

@export var camera : Camera2D
		
var jump_force : float = 0.0

func on_message_received(message:Variant):
	if (message == 'exiting' and camera):
		camera.enabled = false
	elif (message == 'entering' and camera):
		camera.enabled = true
		#if message.has('Jump') :#and is_on_floor():
			#jump_force = 10.0
	#		var input_direction : Vector2 = message['direction']
	#		#move_direction = Vector3(input_direction.x, input_direction.y,0.0)
	#		move_direction = Vector3(input_direction.y,0.0,-input_direction.x)


func on_rotated(angle:float):
	pass

func on_jumped(strength:float=1.0):
	pass
	
func _physics_process(_delta: float) -> void:
	if (controller):
		if (movement):
			velocity = movement.caculate_velocity2D(
				velocity,position,_delta,controller.move_direction,state,get_last_slide_collision()
				)
			move_and_slide()
				
