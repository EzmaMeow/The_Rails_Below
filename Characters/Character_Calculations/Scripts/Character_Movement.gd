#contains ways to caculate velocity
#base class only move in the provided direction scaled
#to the state base_speed if vaild
class_name Character_Movement extends Resource

func caculate_velocity3D(
		velocity:Vector3, position:Vector3, delta:float, direction:Vector3 = Vector3(), 
		state:Character_State = null, collision:KinematicCollision3D = null, 
		data:Dictionary = {}
	) -> Vector3:
		if (state):
			return direction * state.base_speed
		return direction
		
func caculate_velocity2D(
		velocity:Vector2, position:Vector2, delta:float, direction:Vector2 = Vector2(),
		state:Character_State = null, collision:KinematicCollision2D = null, 
		data:Dictionary = {}
	)-> Vector2:
		if (state):
			return direction * state.base_speed
		return direction
