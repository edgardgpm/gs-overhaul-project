extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_debug("Main Menu Screen Ready!")
	
	$LoadOptions.hide()
	$EditorOptions.hide()
	$StartOptions/StartButton.grab_focus()
	
	if !OS.has_feature("pc"):
		$StartOptions/QuitButton.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Displays/Game/game_map.tscn")


func _on_editor_button_pressed() -> void:
	$StartOptions.hide()
	$EditorOptions.show()
	$EditorOptions/MapsButton.grab_focus()

func _on_maps_button_pressed() -> void:
	$EditorOptions.hide()
	$LoadOptions.show()
	$LoadOptions/NewButton.grab_focus()


func _on_items_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Displays/Editors/Item Editor/item_editor.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Displays/Settings/Title Screen/title_settings.tscn")


func _on_new_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Displays/Editors/Map Editor/map_editor.tscn")
	GlobalNode.newfile_in_editor(true)


func _on_load_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Displays/Editors/Map Editor/map_editor.tscn")
	GlobalNode.newfile_in_editor(false)


func _on_back_button_pressed(num : int) -> void:
	
	if num == 1:
		$LoadOptions.hide()
		$EditorOptions.show()
		$EditorOptions/MapsButton.grab_focus()
	elif num == 2:
		$EditorOptions.hide()
		$StartOptions.show()
		$StartOptions/StartButton.grab_focus()
	else:
		get_tree().quit()
