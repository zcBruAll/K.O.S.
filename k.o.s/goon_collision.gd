extends Area2D

var health = 3
var type


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_area_entered(area: Area2D) -> void:
	if area is Base:
		kill_enemy()
	if area is spell_zone:
		decrease_healthbar()
		health -= 1
	if health <= 0:
		kill_enemy()
	#if area is test_area:
	#	decrease_healthbar()
		
		
func kill_enemy():
	queue_free()

func decrease_healthbar():
	#print("Boi you should reduce, reuse, ekiki.")
	$Health_bar.value -= 1
