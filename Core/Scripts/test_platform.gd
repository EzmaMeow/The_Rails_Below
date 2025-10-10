extends MeshInstance3D


func _on_safe_area_entered(body: Node3D) -> void:
	get_tree().call_group("Game3D", "body_enter_safe_area" , body)
	pass # Replace with function body.


func _on_safe_area_exited(body: Node3D) -> void:
	get_tree().call_group("Game3D", "body_exit_safe_area" , body)
	pass # Replace with function body.
