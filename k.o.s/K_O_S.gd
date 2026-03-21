extends Node2D
@export var goon_scene: PackedScene
@export var spell_zone: PackedScene

var spellBoxList=[]

var spells: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	KeyboardGeneration.layout = "QWERTZ"
	KeyboardGeneration.generate()
	
	spells.append(Spell.new("shield", 1, func(): print("Shielded")))
	new_game()

func _process(delta: float) -> void:
	for spell: Spell in spells:
		spell.reduceCd(delta)
		if spell.isReady():
			if KeyboardGeneration.checkSpell(spell.getMask()):
				spell.triggerEffect()
				spellBoxList[0][0].visible = true

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var keyLabel = event.as_text_key_label().to_upper()
		print(keyLabel)
		if event.pressed:
			KeyboardGeneration.keyPressed(keyLabel)
		else:
			KeyboardGeneration.keyReleased(keyLabel)

func new_game():
	generate_gameGrid()
	$GoonTime.start()
	print(spellBoxList)
	
func generate_gameGrid():
	var PAD_RIGHT = 90
	var SIZE = 156
	var positions = [$Spawn/Line1.position,$Spawn/Line2.position,$Spawn/Line3.position,$Spawn/Line4.position]
	for j in range(4):
		var spellBoxLine = []
		for i in range(9,-1,-1):
			var spellBox = spell_zone.instantiate()
			
			# Config size
			spellBox.scale.x = SIZE/2
			spellBox.scale.y = SIZE/2
			
			# Config position
			var posSpawn = positions[j]
			posSpawn.x = posSpawn.x-PAD_RIGHT-(SIZE+10)*i
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
	match randi()%4 :
		0: spawnPos = $Spawn/Line1.position
		1: spawnPos = $Spawn/Line2.position
		2: spawnPos = $Spawn/Line3.position
		3: spawnPos = $Spawn/Line4.position
	
	# Set the goon position
	goon.position = spawnPos
	
	# Spawn the actual goon
	add_child(goon)
