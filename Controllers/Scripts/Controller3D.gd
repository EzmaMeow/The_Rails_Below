class_name Controller3D extends Controller_Base

signal rotated(axis:Vector3,angle:float)

@export var move_direction : Vector3
@export var look_direction : Vector3 

func rotate(axis:Vector3,angle:float):
	rotated.emit(axis,angle)
