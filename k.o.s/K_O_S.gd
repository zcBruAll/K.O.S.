extends Node2D
@export var goon_scene: PackedScene
@export var spell_zone: PackedScene
@export var deaths: PackedScene
@export var spellsParticles: PackedScene

var spellBoxList=[]
var spells: Array = []
var selectedSpell

var waitForArrow: bool = false
var waitForArrowCd: float = 2

var arrowTravel: bool = false
var arrowTravelPos: int = 0
var arrowTravelCd = 0.25

var arrowSpell: Spell = Spell.new("arrow", 0, 0.5, func(): print("Arrowed"))
var spellDict = {
	0:"hammer",
	1:"log",
	2:"wind",
	3:"shield",
	4:"bow"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	KeyboardGeneration.layout = "QWERTZ"
	KeyboardGeneration.generate()
	
	spells.append(Spell.new("wind", 1, 2, func(): print("Winded")))
	spells.append(Spell.new("hammer", 1, 2, func(): print("hammer")))
	spells.append(Spell.new("shield", 1, 2, func(): print("Shielded")))
	spells.append(Spell.new("log", 1, 2, func(): print("Logged")))
	spells.append(Spell.new("bow", 1, 2, func(): print("Bowed")))
	new_game()

func _process(delta: float) -> void:
	if arrowTravel:
		arrowTravelCd -= min(delta, arrowTravelCd)
		if arrowTravelCd <= 0:
			arrowTravelPos += 1
			arrowTravelCd = 0.25
			if arrowTravelPos % 10 == 0 && arrowTravelPos != 0:
				arrowTravel = false
			else:
				var i = arrowTravelPos / 10
				var j = arrowTravelPos % 10
				spellBoxList[i][j].setActive(arrowSpell._activeTime)
				spellBoxList[i][j].check_overlapping()
	
	if waitForArrow:
		waitForArrowCd -= min(delta, waitForArrowCd)
		if waitForArrowCd <= 0:
			waitForArrow = false
		var spellPos = KeyboardGeneration.checkSpell(arrowSpell.getMask())
		if len(spellPos) == 1:
			arrowTravel = true
			waitForArrow = false
			arrowTravelPos = floor(spellPos[0] / 10) * 10
			var i = arrowTravelPos / 10
			var j = arrowTravelPos % 10
			spellBoxList[i][j].setActive(arrowSpell._activeTime)
			spellBoxList[i][j].check_overlapping()
			randomizeChoosenSpell(2.0)
			
	for spell: Spell in spells:
		spell.reduceCd(delta)
		if spell.isReady():
			if spell._selectedSpell :
				var spellPos = KeyboardGeneration.checkSpell(spell.getMask())
				if len(spellPos) > 0:
					if spell._name == "bow":
						waitForArrow = true
						waitForArrowCd = 2
						break
					else:
						waitForArrow = false
					spell.triggerEffect()
					for pos in spellPos:
						var i = pos / 10
						var j = pos % 10
						spellBoxList[i][j].setActive(spell._activeTime)
						spellBoxList[i][j].check_overlapping()
						randomizeChoosenSpell(2.0)
						activateSpellTile(spellBoxList[i][j].position, spell._activeTime)
					break
				else:
					waitForArrow = false
				
func activateSpellTile(position, time) -> void:
	var spellParticle: SpellParticles = spellsParticles.instantiate()
	spellParticle.global_position = position
	spellParticle.cooldown = time
	spellParticle.lifetime = time / 1.2 - 0.25
	spellParticle.emitting = true
	add_child(spellParticle)

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
	randomizeChoosenSpell(0.0)


func randomizeChoosenSpell(n:float):
	for spell in spells :
		spell.setSelectedState(false)
	match selectedSpell:
		"hammer":
			$Base/selectedSpell/Sprite2D.rotationEffect = 1
		"wind":
			$Base/selectedSpell/Sprite2D.upEffect = 5
	await get_tree().create_timer(n).timeout
	selectedSpell = spellDict[randi()%5]
	for spell in spells:
		if spell._name == selectedSpell: spell.setSelectedState(true)
	$Base/selectedSpell/Sprite2D.texture = load('res://images/'+selectedSpell+'.png')
	$Base/selectedSpell/Sprite2D.scale = Vector2(0.2,0.2)
	resetChosenSpellEffectStat()
	
func resetChosenSpellEffectStat():
	$Base/selectedSpell/Sprite2D.rotation = 0
	$Base/selectedSpell/Sprite2D.position.y = 0
	$Base/selectedSpell/Sprite2D.rotationEffect = 0
	$Base/selectedSpell/Sprite2D.upEffect = 0
	
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

func spawnDeathParticles(goon: Goon) -> void:
	var deathParticle: DeathParticle = deaths.instantiate()
	deathParticle.global_position = goon.get_parent().position
	deathParticle.z_index = goon.z_index + 1
	deathParticle.global_position.y -= 50
	deathParticle.emitting = true
	add_child(deathParticle)

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
			texture = load('res://images/goon3.png')
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
			goon.get_child(0).scale = Vector2(goon.get_child(0).scale.x,goon.get_child(0).scale.y)
			
	# Spawn the actual goon
	add_child(goon)
