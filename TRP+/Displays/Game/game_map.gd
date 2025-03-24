extends Node2D

@onready var hudPanel = $TileEditorHUD
var provinceDataFile = "res://Modules/Data/Tile Data/Province Data/province_data.json"
var tagDataFile = "res://Modules/Data/Tag Data/tag_data.json"

var editToggle : bool = false

func _ready() -> void:
	
	load_province_data(provinceDataFile)
	#load_tag_data()


func _process(_delta : float) -> void:
	pass


func load_province_data(filepath : String):
	if not FileAccess.file_exists(filepath):
		printerr("⚠️ File does not exist: ", filepath)
		return
	
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
	
	var provinceDict = json.get_data()
	
	if not (provinceDict is Dictionary):
		printerr("⚠️ JSON structure is not a dictionary!")
		return
	
	
	for provinceID in provinceDict:
		var tile : PROVINCE
		tile = load("res://Modules/Tile/Land/province.tscn").instantiate()
		
		var provinceData = provinceDict[provinceID]  # Get individual province data
		
		print(provinceID)
		
		# Assign properties from JSON
		tile.set_bitmapcolor(provinceData.get("bitmapColor", ""))  # Default empty string
		tile.set_basecolor(provinceData.get("baseColor", Color.WHITE))
		tile.set_hovercolor(provinceData.get("hoverColor", Color.DARK_GRAY))
		tile.set_clickcolor(provinceData.get("clickColor", Color.DIM_GRAY))
		tile.set_region(provinceData.get("region", &"Unknown"))  # Default region name
		tile.set_tileterrain(provinceData.get("tileTerrain", &"Unknown"))
		tile.set_tiletype(provinceData.get("tileType", &"Undefined"))
		tile.set_tilename(provinceData.get("tileName", &"Unnamed"))
		tile.set_coast(provinceData.get("coast", false))  # Default to no coast
		tile.set_tileid(provinceID)  # The province's unique ID (directly from dictionary key)
		
		
		var poly : Array = provinceData.get("tilePolygon", [])
		var vecArray : PackedVector2Array = PackedVector2Array()
		
		for pointStr in poly:
			var coords : Array = pointStr.strip_edges().lstrip("(").rstrip(")").split(", ")
			
			if coords.size() == 2:
				var x : int = int(coords[0])
				var y : int = int(coords[1])
				vecArray.append(Vector2(x, y))
		
		var tilePoly : Polygon2D = Polygon2D.new()
		var tileCol : CollisionPolygon2D = CollisionPolygon2D.new()
		
		# Polygon and Collision Data
		tilePoly.polygon = vecArray
		tileCol.polygon = vecArray
		
		tile.tilePolygon = tilePoly
		
		# Development and Resource Data
		tile.development = provinceData.get("development", 0)  # Default no development
		tile.resources = provinceData.get("resources", &"None")  # Default no resources
		tile.tag = provinceData.get("tag", &"No Tag")  # Default empty tag
		
		# Add province to scene
		get_node("Tiles").add_child(tile)
		
		tilePoly.color = tile.get_basecolor()
		
		tile.get_child(0).add_child(tilePoly)
		tile.get_child(0).add_child(tileCol)
		


func load_tag_data(path : String):
	pass


func display_hud() -> void:
	var hud
	print("HUD on Display!")
	pass


# Read base province file (dictionary file in .txt format)
func import_file(filepath : String):
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file != null:
		return JSON.parse_string(file.get_as_text().replace("_", "/"))
	else:
		printerr("Failed to Open File:", filepath)
		return null


func open_regions_json(filepath : String) -> String:
	var file = FileAccess.open(filepath, FileAccess.READ)
	
	if file == null:
		printerr("⚠️ Failed to open file at: ", filepath)
		return ""
	
	var data = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parsedResult = json.parse(data)
	
	if parsedResult != OK:
		printerr("⚠️ Failed to parse JSON: ", json.get_error_message())
		return ""
	
	var regionArray = json.get_data()
	if not (regionArray is Array):
		printerr("⚠️ JSON structure is not an array!")
		return ""
	
	for region in regionArray:
		print(region)
		if not (region is Dictionary):
			printerr("⚠️ Skipping invalid region entry: ", region)
			continue
		
		return region.get("RegionID")
	
	return ""
