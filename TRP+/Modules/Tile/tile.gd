## This is a basic tile node from which all will inherit.
class_name TILE extends Node2D

signal sendColors

var bitmapColor : String
var baseColor : Color
var hoverColor : Color
var clickColor : Color
var region : StringName
var tileTerrain : StringName
var tileType : StringName
var tileName : StringName
var coast : bool
var tileID : String
var tilePolygon : Polygon2D

func _ready() -> void:
	pass

func get_bitmapcolor() -> String:
	return bitmapColor

func get_basecolor() -> Color:
	return baseColor

func get_hovercolor() -> Color:
	return hoverColor

func get_clickcolor() -> Color:
	return hoverColor

func get_region() -> StringName:
	return region

func get_tileterrain() -> StringName:
	return tileTerrain

func get_tiletype() -> StringName:
	return tileType

func get_tilename() -> StringName:
	return tileName

func get_coast() -> bool:
	return coast

func get_tileid() -> StringName:
	return tileID

func get_tilepolygon() -> Polygon2D:
	return tilePolygon


func set_bitmapcolor(RGB : String) -> void:
	self.bitmapColor = RGB

func set_basecolor(color : Color) -> void:
	self.baseColor = color

func set_hovercolor(color : Color) -> void:
	self.hoverColor = color

func set_clickcolor(color : Color) -> void:
	self.clickColor = color

func set_region(def : StringName) -> void:
	self.region = def

func set_tileterrain(def : StringName) -> void:
	self.tileTerrain = def

func set_tiletype(def : StringName) -> void:
	self.tileType = def

func set_tilename(def : StringName) -> void:
	self.tileName = def

func set_coast(boolean : bool) -> void:
	self.coast = boolean

func set_tileid(def : String) -> void:
	self.tileID = def

func set_tilepolygon(polygon : Polygon2D) -> void:
	self.tilePolygon = polygon
