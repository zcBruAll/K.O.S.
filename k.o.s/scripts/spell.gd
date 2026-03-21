class_name Spell
extends Object

var _name: String
var _cooldown: float
var _cooldownTime: float
var _mask: String
var _effect: Callable

func _init(name: String, cd: float, effect: Callable) -> void:
	_name = name
	_cooldown = cd
	_cooldownTime = cd
	
	var file = FileAccess.open("res://resources/spells/" + name + ".txt", FileAccess.READ)
	_mask = file.get_as_text()
	
	_effect = effect

func reduceCd(delta: float) -> void:
	if self.isReady(): 
		return
	_cooldownTime -= min(delta, _cooldownTime)

func isReady() -> bool:
	return _cooldownTime <= 0

func getMask() -> String:
	return _mask

func resetCd() -> void:
	_cooldownTime = _cooldown

func triggerEffect() -> void:
	resetCd()
	_effect.call()
