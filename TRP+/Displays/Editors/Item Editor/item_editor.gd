extends Node2D

var tagID : int = 1
var tagName : String
var tagColor : Color

var tagFile = "res://Modules/Data/Tag Data/tag_data.json"

signal addTag

func _ready() -> void:
	
	load_tags()

func _on_line_edit_text_changed(newText: String) -> void:
	tagName = newText


func _on_color_picker_button_color_changed(color: Color) -> void:
	tagColor = color


func _on_add_button_pressed() -> void:
	emit_signal("addTag")
	
	print("Created ", tagName, " with color ", tagColor, " and Tag ID ", tagID)
	tagID += 1
	printerr("ADD CODE LOGIC IN GLOBAL FOR ADDING TAGS - HANDLING FILES!!!")
	printerr("Next Tag ID: ", tagID)


func _on_item_list_item_activated(index: int) -> void:
	pass # Replace with function body.

func load_tags() -> void:
	
	var tagDict = import_file(tagFile)
	
	for tag in tagDict:
		
		
		printerr(tag)
		for i in tag:
			printerr(tag[i])
		printerr("")
		
		#tile = load("res://Modules/Tile/Land/province.tscn").instantiate()
		#print("Province created: " + tilesDict[tileColor] + ", " + tileID)
		#
		#tag.set_bitmapcolor(tileColor)
		#tag.set_tileterrain(terrainType)
		#tag.set_tiletype(tileType)
		#tag.set_tilename(tileID)
		#tile.set_tileid(tilesDict[tileColor])
		#tile.set_coast(coastType)
		#print(tile.get_bitmapcolor() + " " + tile.get_tileterrain() +  " " + tile.get_tiletype() +  " " + tile.get_tileid())
		#
		#get_node("Provinces").add_child(tile)
		
		


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
		print("⚠️ WARNING: Color", tileColor, "not found in image!")
		return null

	var targetImage = Image.create(image.get_size().x, image.get_size().y, false, Image.FORMAT_RGBA8)

	for value in pixelColorDict[tileColor]:
		targetImage.set_pixel(value.x, value.y, Color.WHITE)
	
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(targetImage)
	
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0,0), bitmap.get_size()), 0.1)
	
	polygons = polygons.filter(func(p): return p.size() > 2)
	
	return polygons



func import_file(filepath : String):
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file != null:
		return JSON.parse_string(file.get_as_text())
	else:
		printerr("Failed to Open File:", filepath)
		return null
