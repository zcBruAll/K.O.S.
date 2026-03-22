extends Node2D 
class_name SelectedSpell

@onready var anim_player = $Sprite2D2/AnimationPlayer
@onready var spellSprite: Sprite2D = $Sprite2D2
var type = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func play_tap_anim() -> void:
	anim_player.play("hammer_tap")
	
	
