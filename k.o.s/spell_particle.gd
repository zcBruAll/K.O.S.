extends GPUParticles2D
class_name SpellParticles

var cooldown: float = 2

func _process(delta: float) -> void:
	cooldown -= min(delta, cooldown)
	
	if emitting == false && cooldown <= 0:
		queue_free()
