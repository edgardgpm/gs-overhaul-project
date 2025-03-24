extends Node

@onready var tileName = $Window/VFlowContainer/NameEdit
@onready var regionOptions = $Window/VFlowContainer/RegionOptions
@onready var dev = $Window/VFlowContainer/DevSpin
@onready var rssList = $Window/VFlowContainer/ResourceList
@onready var terrain = $Window/VFlowContainer/TerrainOptions
@onready var tagAssign = $Window/VFlowContainer/TagAssignButton
@onready var coastCheck = $Window/VFlowContainer/CoastCheck
@onready var saveBtn = $Window/VFlowContainer/SaveChangesButton

@onready var regionsFile : String = "res://Assets/Maps/EuropeMed/regions.json"

var dictionary : Dictionary
var regionID : int
var rssID : int
var terrainID: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Window.hide()
	open_regions_json(regionsFile)
	print_debug("Edit Screen Window Ready!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	pass

func update_canvas_data() -> void:
	
	# print(GlobalNode.tileDataDict["tag"])  IMPLEMENT LATER
	
	tileName.text = GlobalNode.tileDataDict["tileName"]
	
	regionOptions.select(get_regionid(regionsFile))
	
	dev.value = GlobalNode.tileDataDict["development"]
	
	regionID = find_region(GlobalNode.tileDataDict["region"])
	rssID = find_resource(GlobalNode.tileDataDict["resources"])
	terrainID = find_terrain(GlobalNode.tileDataDict["tileTerrain"])
	
	#tagAssign.text = GlobalNode.tileDataDict["tag"]
	coastCheck.button_pressed = GlobalNode.tileDataDict["coast"]
	
	


func find_region(asset : String) -> int:
	for i in regionOptions.item_count:
		if regionOptions.get_item_text(i) == asset:
			regionOptions.select(i)
			return i
	return 0


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


func _on_region_options_item_selected(index: int) -> void:
	regionID = index


func _on_resource_list_item_activated(index: int) -> void:
	rssID = index


func _on_terrain_options_item_selected(index: int) -> void:
	terrainID = index


func _on_tag_assign_button_pressed() -> void:
	pass # Replace with function body.


func open_regions_json(filepath : String) -> void:
	var file = FileAccess.open(filepath, FileAccess.READ)
	
	if file == null:
		printerr("⚠️ Failed to open file at: ", filepath)
		return
	
	var data = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parsedResult = json.parse(data)
	
	if parsedResult != OK:
		printerr("⚠️ Failed to parse JSON: ", json.get_error_message())
		return
	
	var regionArray = json.get_data()
	if not (regionArray is Array):
		printerr("⚠️ JSON structure is not an array!")
		return
	
	for region in regionArray:
		print(region)
		if not (region is Dictionary):
			printerr("⚠️ Skipping invalid region entry: ", region)
			continue
		printerr("Region ID: ", region.get("RegionID"))
		printerr("Region Name: ", region.get("Region"))
		
		regionOptions.add_item(region.get("Region"), int(region.get("RegionID")))
		


func get_regionid(filepath : String) -> int:
	var file = FileAccess.open(filepath, FileAccess.READ)
	
	if file == null:
		printerr("⚠️ Failed to open file at: ", filepath)
		return 0
	
	var data = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parsedResult = json.parse(data)
	
	if parsedResult != OK:
		printerr("⚠️ Failed to parse JSON: ", json.get_error_message())
		return 0
	
	var regionArray = json.get_data()
	if not (regionArray is Array):
		printerr("⚠️ JSON structure is not an array!")
		return 0
	
	for region in regionArray:
		if not (region is Dictionary):
			printerr("⚠️ Skipping invalid region entry: ", region)
			continue
		
		if GlobalNode.tileDataDict["region"] == region.get("Region"):
			return int(region.get("RegionID"))
	
	return 0


func _on_save_changes_button_pressed() -> void:
	
	GlobalNode.tileDataDict["tileName"] = tileName.text
	GlobalNode.tileDataDict["region"] = regionOptions.get_item_text(regionID)

	GlobalNode.tileDataDict["development"] = dev.value
	GlobalNode.tileDataDict["resources"] = rssList.get_item_text(rssID)
	GlobalNode.tileDataDict["tileTerrain"] = terrain.get_item_text(terrainID)
	
	GlobalNode.add_tile_edit(GlobalNode.tileDataDict)
