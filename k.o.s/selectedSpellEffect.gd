extends Node2D 
class_name SelectedSpell

@onready var anim_player = $AnimationPlayer
@onready var spellSprite: Sprite2D = $fg
var type = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play("idle")
	
	
func play_tap_anim() -> void:
	anim_player.play("hammer_tap")
	

	
	
