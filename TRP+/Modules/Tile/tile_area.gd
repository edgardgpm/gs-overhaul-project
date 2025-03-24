## This is the Area2D node that defines the space each tile has.
extends Area2D

var tileName : StringName

func _ready() -> void:
	tileName = self.get_parent().get_tilename()


func _on_child_entered_tree(node: Node) -> void:
	if node.is_class("Polygon2D"):
			node.color = self.get_parent().get_basecolor()


func _on_mouse_entered() -> void:
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color = self.get_parent().get_hovercolor()


func _on_mouse_exited() -> void:
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color = self.get_parent().get_basecolor()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if event is InputEventMouseButton and Input.is_action_just_pressed("ui_leftclick"):
		print(str(tileName) + " Clicked")
		
		
		self.get_parent().emit_signal("toggleEditor")
		#self.get_parent().get_parent().get_parent().emit_signal("updateTileEditor")
		
		for node in get_children():
			if node.is_class("Polygon2D"):
				node.color = self.get_parent().get_clickcolor()
