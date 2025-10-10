#The UI layer for display info over the game viewport and handle shared
#input logic. 
#NOTE: not all UI may be handle here.
#NOTE: this should run self contain using only what is given to it. It is 
#usally a autoload because of this, but do not nessary need to be if resources
#and objects are used to created indirect connections
extends CanvasLayer

func switch_to_menu():
	$OptionsContainer.visible = false
	$MenuContainer.visible = true
	$MenuContainer/Button.grab_focus()
	
func switch_to_options():
	$MenuContainer.visible = false
	$OptionsContainer.visible = true
	$OptionsContainer/Button.grab_focus()

func _unhandled_key_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_cancel") and visible):
		if ($OptionsContainer.visible):
			switch_to_menu()
			get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	if (get_tree().paused and !visible ):
		visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$MenuContainer/Button.grab_focus()
		return
	if (!get_tree().paused and visible ):
		visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		return
		


func _on_button_pressed(button_id: int) -> void:
	match button_id:
		-1:
			print_debug('back/return pressed')
			switch_to_menu()
		0:
			print_debug('start/resume pressed')
			get_tree().paused = false
		1:
			switch_to_options()
			print_debug('options pressed')
		2:
			print_debug('quit pressed')
			get_tree().quit()
			
