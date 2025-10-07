class_name Controller2D extends Controller_Base

signal rotated(angle:float)

#signal jumped(strength:float)
#signal crouched(strength:float)

@export var move_direction : Vector2
@export var look_direction : Vector2 

func rotate(angle:float):
	rotated.emit(angle)
#func jump(strength:float = 1.0):
#	jumped.emit(strength)
#func crouch(strength:float = 1.0):
#	crouched.emit(strength)
