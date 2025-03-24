extends Node

const SAVE_DIR : String = "res://Saves/"
const SAVE_FILE_ZERO_NAME : String = "savefile.json"
var current_file_path : String
var current_area : String

# TODO Store this KEY elsewhere
const SECURITY_KEY : String = "089SADFH"

var default_save_0 : bool
var default_save_1 : bool
var default_save_2 : bool

var difficulty_level : int
var tutorial_enabled : bool
var newfileInEditor : bool
var tileDataDict : Dictionary = {}
var tileEditDict : Dictionary = {}


var provinceDataFile = "res://Modules/Data/Tile Data/Province Data/province_data.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	verify_save_directory(SAVE_DIR)
	default_save_0 = check_default_save_state(SAVE_DIR + SAVE_FILE_ZERO_NAME)
	
	print_debug("Global Script Ready!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)


# TODO Optimize this function.
func check_default_save_state(path : String) -> bool:
	
	if FileAccess.file_exists(path):
		var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, SECURITY_KEY)
		if file == null:
			print(FileAccess.get_open_error())
			return true
		
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if data == null:
			printerr("Cannot parse %s as a json_string: (%s)" % [path, content])
			return true
		
		return false
		
	else:
		printerr("Cannot open a non-existent file (at %s!)" % [path])
		return true


func save_data(path : String, health : int, mana : int, position_x : float, position_y : float):
	var file = FileAccess.open_encrypted_with_pass(current_file_path, FileAccess.WRITE, SECURITY_KEY)
	if file == null:
		print(FileAccess.get_open_error())
		return
	
	var data = {
		"game_data" : {
			"area" : current_area,
			"file_location" : current_file_path,
			"game_ended" : false,
			"difficulty" : difficulty_level,
			"tutorial_enabled" : tutorial_enabled,
		},
		"player_data" : {
			"health" : health,
			"mana" : mana,
			"global_position" : {
				"x" : position_x,
				"y" : position_y
			},
			"gems" : 0
		}
	}
	
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()

func newfile_in_editor(boolean : bool) -> void:
	newfileInEditor = boolean

func write_dictionary(dict : Dictionary) -> void:
	tileDataDict = dict

func add_tile_edit(dict : Dictionary) -> void:
	if tileEditDict.get(dict["tileID"]) == null:
		tileEditDict.get_or_add(dict["tileID"], dict)
	else:
		tileEditDict.erase(dict["tileID"])
		tileEditDict.get_or_add(dict["tileID"], dict)
	
	write_tileedit_to_json(tileEditDict, provinceDataFile)
	
	tileEditDict.erase(dict["tileID"])


func write_tileedit_to_json(dict : Dictionary, filepath : String) -> void:
	if dict.is_empty():
		return
	
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
	
	for tileID in dict.keys():
		if tileID in provinceDict:
			
			var tileData = provinceDict[tileID]
			
			if "development" in dict[tileID]:
				tileData["development"] = dict[tileID]["development"]
			if "region" in dict[tileID]:
				tileData["region"] = dict[tileID]["region"]
			if "resources" in dict[tileID]:
				tileData["resources"] = dict[tileID]["resources"]
			if "tag" in dict[tileID]:
				tileData["tag"] = dict[tileID]["tag"]
			if "tileName" in dict[tileID]:
				tileData["tileName"] = dict[tileID]["tileName"]
			if "tileTerrain" in dict[tileID]:
				tileData["tileTerrain"] = dict[tileID]["tileTerrain"]
			
			provinceDict[tileID] = tileData
	
	var jsonUpdated = JSON.stringify(provinceDict, "\t")
	
	file = FileAccess.open(filepath, FileAccess.WRITE)
	file.store_string(jsonUpdated)
	file.close()
	
	print("✅ Tile edits successfully saved to JSON!")

func write_tileedits_to_json(dict : Dictionary) -> void:
	if dict == {}:
		pass
	else:
		print(dict)
		for prov in dict:
			printerr(dict[prov])
	
	pass

func clear_save():
	pass
