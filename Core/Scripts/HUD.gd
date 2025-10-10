extends CanvasLayer

func _process(delta: float) -> void:
	var debug_text = '[debug]'
	var is_3D: bool = false
	if get_viewport().get_camera_3d():
		if get_viewport().get_camera_3d().current:
			debug_text += str(' 3d:',get_viewport().get_camera_3d().global_position)
			is_3D = true
	if get_viewport().get_camera_2d() and !is_3D:
		if get_viewport().get_camera_2d().is_current():
			debug_text += str(' 2d:',get_viewport().get_camera_2d().global_position)
	$DebugInfo.text = str(debug_text, ' paused:', get_tree().paused)
