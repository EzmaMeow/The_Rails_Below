extends Node3D

@export var active_process_mode := Node.PROCESS_MODE_PAUSABLE
@export var inactive_process_mode := Node.PROCESS_MODE_DISABLED

func active(set_active:bool = true):
	visible = set_active
	if set_active:
		process_mode = active_process_mode
	else:
		process_mode = inactive_process_mode
		
