extends Area2D
class_name Base

var health = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func inflict_damage(n):
	health -= n
	$Base_health_bar.value = health
	if health <= 0:
		#queue_free()
		get_parent().get_child(2).visible = 1
		get_tree().paused = true
