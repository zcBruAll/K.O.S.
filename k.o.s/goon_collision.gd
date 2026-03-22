extends Area2D
class_name Goon

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
		area.inflict_damage(3)
		queue_free()
	if area is spell_zone:
		inflict_damage(1)
		
		
func inflict_damage(n = 1):
	health -= n
	$Health_bar.value -= n
	if health <= 0:
		kill_enemy()

func kill_enemy():
	get_parent().get_parent().spawnDeathParticles(self)
	queue_free()
