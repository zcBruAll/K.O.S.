extends Node2D
@export var goon_scene: PackedScene
@export var spell_zone: PackedScene

var spellBoxList=[]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	KeyboardGeneration.layout = "QWERTZ"
	KeyboardGeneration.generate()
	new_game()

func _process(delta: float) -> void:
	var file = FileAccess.open("res://resources/spells/" + "shield" + ".txt", FileAccess.READ)
	var content = file.get_as_text()
	if KeyboardGeneration.checkSpell(content):
		print("Shield Spell")
		spellBoxList[0][0].visible = true

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var keyLabel = event.as_text_key_label()
		if event.pressed:
			KeyboardGeneration.keyPressed(keyLabel)
		else:
			KeyboardGeneration.keyReleased(keyLabel)

func new_game():
	generate_gameGrid()
	$GoonTime.start()
	print(spellBoxList)
	
func generate_gameGrid():
	var PAD_RIGHT = 50
	var SIZE = 150
	var positions = [$Spawn/Line1.position,$Spawn/Line2.position,$Spawn/Line3.position,$Spawn/Line4.position]
	for j in range(4):
		var spellBoxLine = []
		for i in range(9,-1,-1):
			var spellBox = spell_zone.instantiate()
			
			# Config size and pos
			var posSpawn = positions[j]
			match j:
				0:
					spellBox.scale.x = SIZE/2*60/100
					posSpawn.x = posSpawn.x-PAD_RIGHT-(SIZE*50/100)+10*i
				1: 
					spellBox.scale.x = SIZE/2*70/100
					posSpawn.x = posSpawn.x-PAD_RIGHT-(SIZE*60/100)+10*i
				2:
					spellBox.scale.x = SIZE/2*90/100
					posSpawn.x = posSpawn.x-PAD_RIGHT-(SIZE*80/100)+10*i
				3:
					spellBox.scale.x = SIZE/2
					posSpawn.x = posSpawn.x-PAD_RIGHT-(SIZE+10)*i
						
			spellBox.scale.y = 5
			
			spellBox.position = Vector2(posSpawn.x,posSpawn.y)
			spellBox.visible = false
			spellBoxLine.append(spellBox)
			
			add_child(spellBox)
		spellBoxList.append(spellBoxLine)


func _on_goon_time_timeout() -> void:
	$GoonTime.start()

	# Create goon
	var goon = goon_scene.instantiate()
	# Randomize location from 1 of the 4 line
	var spawnPos
	var scalar
	match randi()%4 :
		0:
			scalar = 70
			goon.position = $Spawn/Line1.position
			goon.linear_velocity.x = -scalar
			goon.get_child(0).scale = Vector2(goon.get_child(0).scale.x*scalar/100,goon.get_child(0).scale.y*scalar/100)
		1:
			scalar = 80
			goon.position = $Spawn/Line2.position
			goon.linear_velocity.x = -scalar
			goon.get_child(0).scale = Vector2(goon.get_child(0).scale.x*scalar/100,goon.get_child(0).scale.y*scalar/100)
			goon.get_child(0).z_index = 3
		2:
			scalar = 90
			goon.position = $Spawn/Line3.position
			goon.linear_velocity.x = -scalar
			goon.get_child(0).scale = Vector2(goon.get_child(0).scale.x*scalar/100,goon.get_child(0).scale.y*scalar/100)
			goon.get_child(0).z_index = 5
		3:
			goon.position = $Spawn/Line4.position
			goon.get_child(0).z_index = 7
			
	# Spawn the actual goon
	add_child(goon)
