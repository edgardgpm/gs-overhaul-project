extends Node

@onready var tileName = $Window/NameEdit
@onready var regionName = $Window/RegionEdit
@onready var dev = $Window/DevSpin
@onready var rssList = $Window/ResourceList
@onready var terrain = $Window/TerrainOptions
@onready var tagAssign = $Window/TagAssignButton
@onready var coastCheck = $Window/CoastCheck
@onready var saveBtn = $Window/SaveChangesButton
var dictionary : Dictionary
var rssID : int
var terrainID: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Window.hide()
	print_debug("Edit Screen Window Ready!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	pass

func update_canvas_data() -> void:
	
	printerr(GlobalNode.tileDataDict)
	
	print(tileName.text)
	print(GlobalNode.tileDataDict["tileName"])
	print(GlobalNode.tileDataDict["development"])
	print(GlobalNode.tileDataDict["resources"])
	print(GlobalNode.tileDataDict["tileTerrain"])
	# print(GlobalNode.tileDataDict["tag"])  IMPLEMENT LATER
	print(GlobalNode.tileDataDict["coast"])
	
	tileName.text = GlobalNode.tileDataDict["tileName"]
	regionName.text = GlobalNode.tileDataDict["region"]
	dev.value = GlobalNode.tileDataDict["development"]
	
	rssID = find_resource(GlobalNode.tileDataDict["resources"])
	terrainID = find_terrain(GlobalNode.tileDataDict["tileTerrain"])
	
	#tagAssign.text = GlobalNode.tileDataDict["tag"]
	coastCheck.button_pressed = GlobalNode.tileDataDict["coast"]
	
	print(tileName.text)
	

func find_resource(asset : String) -> int:
	for i in rssList.item_count:
		if rssList.get_item_text(i) == asset:
			rssList.select(i)
			return i
	return 0


func find_terrain(asset : String) -> int:
	for i in terrain.item_count:
		if terrain.get_item_text(i) == asset:
			terrain.select(i)
			return i
	return 0


func _on_resource_list_item_activated(index: int) -> void:
	rssID = index

func _on_terrain_options_item_selected(index: int) -> void:
	terrainID = index

func _on_tag_assign_button_pressed() -> void:
	pass # Replace with function body.


func _on_save_changes_button_pressed() -> void:
	
	GlobalNode.tileDataDict["tileName"] = tileName.text
	GlobalNode.tileDataDict["region"] = regionName.text

	GlobalNode.tileDataDict["development"] = dev.value
	GlobalNode.tileDataDict["resources"] = rssList.get_item_text(rssID)
	GlobalNode.tileDataDict["tileTerrain"] = terrain.get_item_text(terrainID)
	
	print(GlobalNode.tileDataDict["tileName"])
	print(GlobalNode.tileDataDict["region"])
	print(GlobalNode.tileDataDict["development"])
	print(GlobalNode.tileDataDict["resources"])
	print(GlobalNode.tileDataDict["tileTerrain"])
