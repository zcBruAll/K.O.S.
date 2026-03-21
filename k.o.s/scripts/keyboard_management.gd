extends Node

@export_enum("QWERTZ", "AZERTY") var layout: String

var keyLayout: Dictionary[String, int]
var pressedKeys: Array[int] = []

func generate() -> void:
	var file = FileAccess.open("res://resources/kb_layouts/" + layout.to_lower() + ".txt", FileAccess.READ)
	var content = file.get_as_text()
	
	var i = 0
	for line in content.split("\n"):
		for char in line.split(" "):
			keyLayout[char] = i
			i += 1

func keyPressed(key: String) -> void:
	if (!keyLayout.has(key)):
		return
	var keyValue = keyLayout[key]
	if !pressedKeys.has(keyValue):
		pressedKeys.append(keyValue)

func keyReleased(key: String) -> void:
	if (!keyLayout.has(key)):
		return
	var keyValue = keyLayout[key]
	if pressedKeys.has(keyValue):
		pressedKeys.erase(keyValue)

func convertMask(mask: String) -> Array:
	var conv = []
	var i = 0
	for line in mask.split("\n"):
		for state in line.split(" "):
			if (state == "1"):
				conv.append(i)
			i += 1
		i += 8

	return conv

func checkSpell(mask) -> bool:
	var converted = convertMask(mask)
	if len(pressedKeys) != len(converted):
		return false
	
	pressedKeys.sort()
	
	var offset = pressedKeys[0]
	for onState in converted:
		if !pressedKeys.has(offset + onState):
			return false
	
	return true
