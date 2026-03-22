extends Node2D 
class_name SelectedSpell

@onready var anim_player = $AnimationPlayer
@onready var spellSprite: Sprite2D = $fg
var type = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play("idle")
	

func play_idle() -> void:
	anim_player.play("idle")
	
func play_tap_anim() -> void:
	anim_player.play("hammer_tap")
	
func play_wind_anim() -> void:
	anim_player.play("wind_slide")
	
func play_spear_anim() -> void:
	anim_player.play("spear_tap")
	
func reset() -> void:
	spellSprite.position = Vector2(0.0,0.0)
	spellSprite.rotation = 0.0
	spellSprite.scale = Vector2(1.0, 1.0)
	

	
	
	
