#This handles setting up the game's resources and the game lifetime
#NOTE: it can be an autoload since it should live as long as the game
#is active, but it should not be interacted with directly. resources, groups
#and signals should be used instead
extends Node

@export var player_controller: Controller_Base

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		if (player_controller as Controller3D):
			player_controller.rotate(Vector3.UP,-event.relative.y * 0.01)
			player_controller.rotate(Vector3.RIGHT,-event.relative.x * 0.01)


func _physics_process(_delta: float) -> void:
	if (player_controller as Controller3D):
		#mappint to godot directiom of (right, up, -forward)
		player_controller.move_direction = Vector3(
			Input.get_axis('Left','Right'),0.0, -Input.get_axis('Back','Forward')
		)
	
