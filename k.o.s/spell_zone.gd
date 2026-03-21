extends Area2D
class_name spell_zone

var activeTime: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setActive(time: float) -> void:
	monitorable = true
	visible = true
	activeTime = time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if activeTime <= 0: return
	activeTime -= min(delta, activeTime)
	if activeTime <= 0: 
		monitorable = false
		visible = false
