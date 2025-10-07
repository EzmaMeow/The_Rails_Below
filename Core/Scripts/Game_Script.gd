#This handles setting up the game's resources and the game lifetime
#NOTE: it can be an autoload since it should live as long as the game
#is active, but it should not be interacted with directly. resources, groups
#and signals should be used instead
extends Node

@export var player_controller2D: Controller2D
@export var player_controller3D: Controller3D
var player_controller: Controller_Base
var cooldown : float = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif (event.is_action_pressed("ui_cancel")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if (Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion):
		if (player_controller as Controller3D):
			player_controller.rotate(Vector3.UP,-event.relative.y * 0.01)
			player_controller.rotate(Vector3.RIGHT,-event.relative.x * 0.01)
	if (event.is_action_pressed("Jump")):
		if (player_controller as Controller3D):
			(player_controller as Controller3D).jump(event.get_action_strength('Jump'))
			
	if (event.is_action_pressed("Debug") and cooldown <= 0.0):
		if (player_controller as Controller3D):
			player_controller.send_clients_message('exiting')
			player_controller = player_controller2D
			player_controller.send_clients_message('entering')
			for node in get_tree().get_nodes_in_group("3DLevel"):
				if (node as Node3D):
					node.visible = false
			for node in get_tree().get_nodes_in_group("2DLevel"):
				if (node as Node2D):
					node.visible = true
					
		else:
			player_controller.send_clients_message('exiting')
			player_controller = player_controller3D
			player_controller.send_clients_message('entering')
			for node in get_tree().get_nodes_in_group("2DLevel"):
				if (node as Node2D):
					node.visible = false
			for node in get_tree().get_nodes_in_group("3DLevel"):
				if (node as Node3D):
					node.visible = true
		cooldown = 1.0
		


func _physics_process(_delta: float) -> void:
	if (player_controller as Controller3D):
		#mappint to godot directiom of (right, up, -forward)
		player_controller.move_direction = Vector3(
			Input.get_axis('Left','Right'),0.0, -Input.get_axis('Back','Forward')
		)
	elif (player_controller as Controller2D):
		player_controller.move_direction = Vector2(
			Input.get_axis('Left','Right'),-Input.get_axis('Back','Forward')
		)
	if (cooldown > 0.0):
		cooldown -= _delta
		
	
func _ready() -> void:
	player_controller = player_controller3D
