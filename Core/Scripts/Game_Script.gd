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
			(player_controller as Controller3D).rotate(Vector3.UP,-event.relative.y * 0.01)
			(player_controller as Controller3D).rotate(Vector3.RIGHT,-event.relative.x * 0.01)
			#(player_controller as Controller3D).look_direction = Vector3(
			#	-event.relative.x * 0.01,
			#	-event.relative.y * 0.01,
			#	0.0
			#)


func _physics_process(_delta: float) -> void:
	if (player_controller as Controller3D):
		#mappint to godot directiom of (right, up, -forward)
		player_controller.move_direction = Vector3(
			Input.get_axis('Left','Right'),0.0, -Input.get_axis('Back','Forward')
		)
	#var direction:Vector2= Vector2(Input.get_axis('Back','Forward'),Input.get_axis('Left','Right'))
	#if (player_controller):
	#	player_controller.send_clients_message({"direction":direction})
	
func _ready() -> void:
	#Note: would need to change the looking base on mouse mode
	#capture would need to increase by step base on input events
	#else it can set it base on position (like now). first option
	#would be more ideal, but may take a bit to smooth out
	pass #TODO NEED A BETTER WAY	
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
