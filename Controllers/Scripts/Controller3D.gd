class_name Controller3D extends Controller_Base

signal rotated(axis:Vector3,angle:float)

signal jumped(strength:float)
signal crouched(strength:float)

@export var move_direction : Vector3
@export var look_direction : Vector3 

func rotate(axis:Vector3,angle:float):
	rotated.emit(axis,angle)
func jump(strength:float = 1.0):
	jumped.emit(strength)
func crouch(strength:float = 1.0):
	crouched.emit(strength)
