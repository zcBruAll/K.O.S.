extends Area2D
class_name Goon

var health = 3
var type
var oldVelocity = -100
var oldArea: spell_zone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$rollin.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if oldArea && !oldArea.blocking:
		get_parent().linear_velocity.x = oldVelocity
	

func _on_area_entered(area: Area2D) -> void:
	if area is spell_zone && area.blocking:
		oldVelocity = get_parent().linear_velocity.x
		oldArea = area
		get_parent().linear_velocity.x = 0
	elif area is spell_zone:
		inflict_damage(3)
	elif area is Base:
		area.inflict_damage(1)
		queue_free()
		
		
func inflict_damage(n = 3):
	health -= n
	$Health_bar.value -= n
	$Hit_sound.play()
	if health <= 0:
		kill_enemy()

func kill_enemy():
	$Goon_death.play()
	get_parent().get_parent().spawnDeathParticles(self)
	queue_free()
