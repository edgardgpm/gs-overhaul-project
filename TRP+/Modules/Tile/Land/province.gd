## This is a province-focused tile node that inherits from base TILE class. 
class_name PROVINCE extends TILE

var development : int
var resources : StringName
var tag : StringName

@onready var filepath : String = "res://Assets/Maps/EuropeMed/regions.json"

signal toggleEditor

func _ready() -> void:
	set_basecolor(Color.GRAY)
	set_hovercolor(Color.DARK_GRAY)
	set_clickcolor(Color.DIM_GRAY)
	
	if self.region != "":
		set_basecolor(check_region(filepath, self.region))


func get_development() -> int:
	return development

func get_resources() -> StringName:
	return resources

func get_tag() -> StringName:
	return tag


func check_region(filepath : String, regionCheck : String) -> Color:
	
	var file = FileAccess.open(filepath, FileAccess.READ)
	
	if file == null:
		printerr("⚠️ Failed to open file at: ", filepath)
		return Color.GRAY
	
	var data = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parsedResult = json.parse(data)
	
	if parsedResult != OK:
		printerr("⚠️ Failed to parse JSON: ", json.get_error_message())
		return Color.GRAY
	
	var regionArray = json.get_data()
	if not (regionArray is Array):
		printerr("⚠️ JSON structure is not an array!")
		return Color.GRAY
	
	for region in regionArray:
		if not (region is Dictionary):
			printerr("⚠️ Skipping invalid region entry: ", region)
			continue
		
		if regionCheck == region.get("Region"):
			var constant : String = (region.get("Color"))
			var returnColor : Color = Color(constant)
			return returnColor
	
	return Color.GRAY


func _on_toggle_editor() -> void:
	
	var dictionary : Dictionary = {
		"region" : self.get_region(),
		"tileTerrain" : self.get_tileterrain(),
		"tileType" : self.get_tiletype(),
		"tileName" : self.get_tilename(),
		"coast" : self.get_coast(),
		"tileID" : self.get_tileid(),
		"development" : self.get_development(),
		"resources" : self.get_resources(),
		"tag" : self.get_tag()
	}
	
	GlobalNode.write_dictionary(dictionary)
	self.get_parent().get_parent().emit_signal("updateTileEditor")
