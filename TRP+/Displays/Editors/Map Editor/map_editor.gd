extends Node2D

@onready var mapImage = $Sprite2D
@onready var tileEditor = $TileEditorHUD
var provinceFile = "res://Assets/Maps/EuropeMed/provinces.json"
var provinceDataFile = "res://Modules/Data/Tile Data/Province Data/province_data.json"

signal updateTileEditor

func _ready() -> void:
	
	mapImage.hide()
	
	if GlobalNode.newfileInEditor == true:
		load_provinces()
	else:
		load_province_data(provinceDataFile)
	
	mapImage.queue_free()


func _process(_delta : float) -> void:
	pass


func load_provinces() -> void:
	
	var tileTypes = ["Land", "Sea", "Lake"]
	var coastTypes = ["Inland", "Coast"]
	var terrainTypes = ["Forest", "Hills", "Mountains", "Plains", "Swamp", "Jungle", "Desert", "Ocean", "Sea", "Lake"]
	
	var image = mapImage.get_texture().get_image()
	var pixelColorDict = get_pixel_color_dict(image)
	var provincesDict = import_file(provinceFile)
	
	for provinceColor in provincesDict:
		
		var dictValue = provincesDict[provinceColor]
		var valueParts = dictValue.split("/")  # Split value in dictionary into ["ID", "classification"]
		
		if valueParts.size() < 2:
			printerr("⚠️ Error: Malformed tile data for color " + provinceColor)
			continue
		
		var tileID = valueParts[0]
		var tileCategory = valueParts[1]
		
		# Extract individual classification numbers
		var tileTypeID = tileCategory[0].to_int()
		var coastType = tileCategory[1].to_int()
		var terrainTypeID = tileCategory[2].to_int()
		
		# Convert classification numbers into readable names
		var tileType = tileTypes[tileTypeID]
		var terrainType = terrainTypes[terrainTypeID]
		
		var tile : PROVINCE
		
		tile = load("res://Modules/Tile/Land/province.tscn").instantiate()
		print("Province created: " + provincesDict[provinceColor] + ", " + tileID)
		
		tile.set_bitmapcolor(provinceColor)
		tile.set_tileterrain(terrainType)
		tile.set_tiletype(tileType)
		tile.set_tilename(tileID)
		tile.set_tileid(provincesDict[provinceColor])
		tile.set_coast(coastType)
		
		get_node("Provinces").add_child(tile)
		
		var polygons = get_polygons(image, provinceColor, pixelColorDict)
		if polygons == null:
			continue  # Skip if no valid polygons were found
		
		for polygon in polygons:
			var tileCollision = CollisionPolygon2D.new()
			var tilePolygon = Polygon2D.new()
			
			tileCollision.polygon = polygon
			tilePolygon.polygon = polygon
			
			tilePolygon.color = tile.get_basecolor()
			tile.set_tilepolygon(tilePolygon)
			tile.get_child(0).add_child(tileCollision)
			tile.get_child(0).add_child(tilePolygon)
		
		write_file(provinceDataFile, tile)


# Store RGB values as strings (in "255255255" format)
func get_pixel_color_dict(image):
	var pixelColorDict = {}

	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var pixel = image.get_pixel(x, y)
			var pixelColor = str(int(pixel.r * 255)).pad_zeros(3) + \
							str(int(pixel.g * 255)).pad_zeros(3) + \
							str(int(pixel.b * 255)).pad_zeros(3)

			if pixelColor not in pixelColorDict:
				pixelColorDict[pixelColor] = []
			pixelColorDict[pixelColor].append(Vector2(x, y))

	return pixelColorDict


# Lookup colors as RGB strings
func get_polygons(image, tileColor, pixelColorDict):
	# Ensure provColor is properly formatted
	tileColor = str(int(tileColor.substr(0,3))).pad_zeros(3) + \
				str(int(tileColor.substr(3,3))).pad_zeros(3) + \
				str(int(tileColor.substr(6,3))).pad_zeros(3)

	# Skip if color doesn't exist
	if not pixelColorDict.has(tileColor):
		print("⚠️ WARNING: Color ", tileColor, " not found in image!")
		return null

	var targetImage = Image.create(image.get_size().x, image.get_size().y, false, Image.FORMAT_RGBA8)

	for value in pixelColorDict[tileColor]:
		targetImage.set_pixel(value.x, value.y, Color.WHITE)
	
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(targetImage)
	
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0,0), bitmap.get_size()), 0.1)
	
	polygons = polygons.filter(func(p): return p.size() > 2)
	
	return polygons


# Read base province file (dictionary file in .txt format)
func import_file(filepath : String) -> Dictionary:
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file != null:
		return JSON.parse_string(file.get_as_text().replace("_", "/"))
	else:
		printerr("Failed to Open File:", filepath)
		printerr(FileAccess.get_open_error())
		return {}


func write_file(filepath : String, tile : PROVINCE) -> void:
	if not FileAccess.file_exists(filepath):
		create_new_file(filepath, tile)
		return
	
	var file = FileAccess.open(filepath, FileAccess.READ)
	var oldTileData = {}
	
	if file != null:
		var content = file.get_as_text().strip_edges()
		file.close()
		
		if content != "":
			var parsed_data = JSON.parse_string(content)
			
			if parsed_data is Dictionary:
				oldTileData = parsed_data
			else:
				printerr("⚠️ JSON parsing error: Excepted a Dictionary, got: ", typeof(parsed_data))
				return
	
	if not (oldTileData is Dictionary):
		oldTileData = {}
	
	oldTileData[tile.tileID] = {
		"bitmapColor" : tile.bitmapColor,
		"baseColor" : tile.baseColor,
		"hoverColor" : tile.hoverColor,
		"clickColor" : tile.clickColor,
		"region" : tile.region,
		"tileTerrain" : tile.tileTerrain,
		"tileType" : tile.tileType,
		"tileName" : tile.tileName,
		"coast" : tile.coast,
		"tileID" : tile.tileID,
		"tilePolygon" : Array(tile.tilePolygon.polygon),
		"development" : tile.development,
		"resources" : tile.resources,
		"tag" : tile.tag
	}
	
	
	file = FileAccess.open(filepath, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(oldTileData, "\t"))
		file.close()
	else:
		printerr("⚠️ Failed to Open File for Writing: ", filepath)
		return
	
	return



func create_new_file(filepath : String, tile : PROVINCE):
	
	var newTileData = {
		tile.tileID : {
			"bitmapColor" : tile.bitmapColor,
			"baseColor" : tile.baseColor,
			"hoverColor" : tile.hoverColor,
			"clickColor" : tile.clickColor,
			"region" : tile.region,
			"tileTerrain" : tile.tileTerrain,
			"tileType" : tile.tileType,
			"tileName" : tile.tileName,
			"coast" : tile.coast,
			"tileID" : tile.tileID,
			"tilePolygon" : Array(tile.tilePolygon.polygon),
			"development" : tile.development,
			"resources" : tile.resources,
			"tag" : tile.tag
		}
	}
	
	
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(newTileData, "\t"))
		file.close()
	else:
		printerr("⚠️ Failed to Create a New File at: ", filepath)


func start_new_save(path : String, difficulty : int, tutorial : bool, start_area : String):
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		print(FileAccess.get_open_error())
		return
	
	var data = {
		"game_data" : {
			"area" : start_area,
			"file_location" : path,
			"game_ended" : false,
			"difficulty" : difficulty,
			"tutorial_enabled" : tutorial,
		},
		"player_data" : {
			"health" : 100,
			"mana" : 0,
			"global_position" : {
				"x" : 170,
				"y" : 92
			},
			"gems" : 0
		}
	}
	
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()


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
		tile.set_basecolor(provinceData.get("baseColor", Color.GRAY))
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
		get_node("Provinces").add_child(tile)
		
		tilePoly.color = tile.get_basecolor()
		
		tile.get_child(0).add_child(tilePoly)
		tile.get_child(0).add_child(tileCol)
		


func _on_update_tile_editor() -> void:
	
	tileEditor.get_child(0).show()
	tileEditor.get_child(0).get_child(0).get_child(0).grab_focus()
	tileEditor.update_canvas_data()
	
	#get_tree().reload_current_scene()
