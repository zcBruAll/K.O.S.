extends GPUParticles2D
class_name DeathParticle

func _process(delta: float) -> void:
	if !emitting:
		queue_free()
