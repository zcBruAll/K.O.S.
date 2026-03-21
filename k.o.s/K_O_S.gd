extends Node2D
@export var goon_scene: PackedScene
@export var spell_zone: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_game():
	generate_gameGrid()
	$GoonTime.start()
	
func generate_gameGrid():
	var PAD_RIGHT = 90
	var SIZE = 140
	var positions = [$Spawn/Line1.position,$Spawn/Line2.position,$Spawn/Line3.position,$Spawn/Line4.position]
	for j in range(4):
		for i in range(10,-1,-1):
			var spellBox = spell_zone.instantiate()
			
			# Config size
			spellBox.scale.x = SIZE/2
			spellBox.scale.y = SIZE/2
			
			# Config position
			var posSpawn = positions[j]
			posSpawn.x = posSpawn.x-PAD_RIGHT-(SIZE+10)*i
			spellBox.position = Vector2(posSpawn.x,posSpawn.y)
			
			add_child(spellBox)


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
