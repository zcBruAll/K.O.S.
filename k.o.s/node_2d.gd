extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	KeyboardGeneration.layout = "QWERTZ"
	KeyboardGeneration.generate()
	
func _process(delta: float) -> void:
	var file = FileAccess.open("res://resources/spells/" + "shield" + ".txt", FileAccess.READ)
	var content = file.get_as_text()
	if KeyboardGeneration.checkSpell(content):
		print("Shield Spell")
	

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var keyLabel = event.as_text_key_label()
		if event.pressed:
			KeyboardGeneration.keyPressed(keyLabel)
		else:
			KeyboardGeneration.keyReleased(keyLabel)
