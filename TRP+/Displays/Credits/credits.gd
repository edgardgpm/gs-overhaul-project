extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_debug("Title Screen Credits Screen Ready!")
	$ControlNode/BackButton.grab_focus()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Displays/Settings/Title Screen/title_settings.tscn")
