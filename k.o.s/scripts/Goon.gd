extends Area2D
@onready var health_bar: TextureProgressBar = $Area2D/Health_bar
func _ready() -> void:
	pass
	#connect_signals()

var health = 3


func connect_signals() -> void:
	area_2d.connect("hit", reduce_life_expectency())

func reduce_life_expectency(body : Area2D) -> void:
	if body is Spell:
		health -= 1 # simply hard coded.. need to get the damage from the spell.
	elif body is Base:
		kill_enemy()

func kill_enemy():
	queue_free()
