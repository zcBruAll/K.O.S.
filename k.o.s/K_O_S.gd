extends Node2D
@export var goon_scene: PackedScene
@export var spell_zone: PackedScene

var spellBoxList=[]
var activeSpellBoxes=[]
var spells: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	KeyboardGeneration.layout = "QWERTZ"
	KeyboardGeneration.generate()
	
	spells.append(Spell.new("wind", 1, 2, func(): print("Winded")))
	spells.append(Spell.new("hammer", 1, 2, func(): print("hammer")))
	spells.append(Spell.new("shield", 1, 2, func(): print("Shielded")))
	spells.append(Spell.new("log", 1, 2, func(): print("Logged")))
	spells.append(Spell.new("bow", 1, 2, func(): print("Bowed")))
	#spells.append(Spell.new("arrow", 1, 2, func(): print("Arrowed")))
	new_game()

func _process(delta: float) -> void:
	for spell: Spell in spells:
		spell.reduceCd(delta)
		if spell.isReady():
			var spellPos = KeyboardGeneration.checkSpell(spell.getMask())
			if len(spellPos) > 0:
				spell.triggerEffect()
				for pos in spellPos:
					spellBoxList[pos / 10][pos % 10].setActive(spell._activeTime)
				break

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var keyLabel = event.as_text_key_label().to_upper()
		if event.pressed:
			KeyboardGeneration.keyPressed(keyLabel)
		else:
			KeyboardGeneration.keyReleased(keyLabel)

func new_game():
	generate_gameGrid()
	$GoonTime.start()
	print(spellBoxList)
	
func generate_gameGrid():
	var PAD_RIGHT = 70
	var SIZE = 146
	var positions = [$Spawn/Line1.position,$Spawn/Line2.position,$Spawn/Line3.position,$Spawn/Line4.position]
	for j in range(4):
		var spellBoxLine = []
		for i in range(9,-1,-1):
			var spellBox = spell_zone.instantiate()
			
			# Config size and pos
			var posSpawn = positions[j]
			match j:
				0:
					spellBox.scale.x = SIZE/2*78/100
					posSpawn.x = posSpawn.x-PAD_RIGHT+10-((SIZE*70/100)+15)*i
				1: 
					spellBox.scale.x = SIZE/2*82/100
					posSpawn.x = posSpawn.x-PAD_RIGHT-((SIZE*85/100)+4)*i
				2:
					spellBox.scale.x = SIZE/2*90/100
					posSpawn.x = posSpawn.x-PAD_RIGHT-((SIZE*90/100)+10)*i
				3:
					spellBox.scale.x = SIZE/2
					posSpawn.x = posSpawn.x-PAD_RIGHT-((SIZE+10))*i
						
			spellBox.scale.y = 5
			
			spellBox.position = Vector2(posSpawn.x,posSpawn.y)
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
	var texture

	match randi()%2 :
		0:
			texture = load('res://images/goon1.png')
			goon.get_child(0).get_child(0).texture = texture
			goon.get_child(0).type = 0
		1:
			texture = load('res://images/goon2.png')
			goon.get_child(0).get_child(0).texture = texture
			goon.get_child(0).type = 1
		
	match randi()%4 :
		0:
			scalar = 70
			goon.position = $Spawn/Line1.position
			goon.linear_velocity.x = -scalar
			if goon.get_child(0).type == 1:
				goon.get_child(0).scale = Vector2(goon.get_child(0).scale.x*scalar/100,goon.get_child(0).scale.y*scalar/100*2/3)
			else :
				goon.get_child(0).scale = Vector2(goon.get_child(0).scale.x*scalar/100,goon.get_child(0).scale.y*scalar/100)
		1:
			scalar = 80
			goon.position = $Spawn/Line2.position
			goon.linear_velocity.x = -scalar
			if goon.get_child(0).type == 1:
				goon.get_child(0).scale = Vector2(goon.get_child(0).scale.x*scalar/100,goon.get_child(0).scale.y*scalar/100*2/3)
			else :
				goon.get_child(0).scale = Vector2(goon.get_child(0).scale.x*scalar/100,goon.get_child(0).scale.y*scalar/100)
			goon.get_child(0).z_index = 3
		2:
			scalar = 90
			goon.position = $Spawn/Line3.position
			goon.linear_velocity.x = -scalar
			if goon.get_child(0).type == 1:
				goon.get_child(0).scale = Vector2(goon.get_child(0).scale.x*scalar/100,goon.get_child(0).scale.y*scalar/100*2/3)
			else :
				goon.get_child(0).scale = Vector2(goon.get_child(0).scale.x*scalar/100,goon.get_child(0).scale.y*scalar/100)
			goon.get_child(0).z_index = 5
		3:
			goon.position = $Spawn/Line4.position
			goon.get_child(0).z_index = 7
			if goon.get_child(0).type == 1:
				goon.get_child(0).scale = Vector2(goon.get_child(0).scale.x,goon.get_child(0).scale.y*2/3)
			else :
				goon.get_child(0).scale = Vector2(goon.get_child(0).scale.x,goon.get_child(0).scale.y)
	

			
	# Spawn the actual goon
	add_child(goon)
