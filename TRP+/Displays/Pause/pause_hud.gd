extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Window.hide()
	print_debug("Pause Screen Window Ready!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Engine.time_scale == 0:
			pass
		else:
			Engine.time_scale = 0
			$Window.show()
			$Window/Options/ResumeButton.grab_focus()

func _on_window_close_requested() -> void:
	$Window.hide()
	Engine.time_scale = 1


func _on_resume_button_pressed() -> void:
	$Window.hide()
	Engine.time_scale = 1


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_main_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Displays/Main/Title Screen/title_screen.tscn")
	Engine.time_scale = 1


func _on_quit_button_pressed() -> void:
	get_tree().quit()
