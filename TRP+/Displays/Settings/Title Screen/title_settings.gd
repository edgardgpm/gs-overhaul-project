# TODO Consider using components to make TitleSettings and PauseSettings more efficient?
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_debug("Title Screen Settings Screen Ready!")
	$ControlNode/Options/BackButton.grab_focus()
	
	if !OS.has_feature("pc"):
		$ControlNode/Options/FullscreenButton.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func _on_fullscreen_button_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Displays/Credits/credits.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Displays/Main/Title Screen/title_screen.tscn")
