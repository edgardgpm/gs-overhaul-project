extends Node

var tagID : String
var tagColor : Color
var tagProvinces : Dictionary
var tagCapital : String
var tagName : String

func get_tagid() -> String:
	return tagID

func get_tagcolor() -> Color:
	return tagColor

func get_tagprovinces() -> Dictionary:
	return tagProvinces

func get_tagcapital() -> String:
	return tagCapital

func get_tagname() -> String:
	return tagName


func set_tagid(ID : String) -> void:
	self.tagID = ID

func set_tagcolor(color : Color) -> void:
	self.tagColor = color

func set_tagprovinces(provinces : Dictionary) -> void:
	self.tagProvinces = provinces

func set_tagcapital(capital : String) -> void:
	self.tagCapital = capital

func set_tagname(name : String) -> void:
	self.tagName = name
