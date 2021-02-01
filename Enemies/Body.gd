extends Node2D

onready var flash_tween = $FlashTween

func _ready():
  EventBus.connect("enemy_hurt", self, "_on_enemy_hurt")
  
func _on_enemy_hurt(_data:Dictionary):
  flash_tween.stop_all()
  flash_tween.interpolate_property(
    self,
    "modulate",
    Color(0.7, 0.5, 0.7, 1),
    Color(1, 1, 1, 1),
    0.1,
    Tween.TRANS_QUART,
    Tween.EASE_IN
  )
  flash_tween.start()
  yield(flash_tween, "tween_completed")
  flash_tween.interpolate_property(
    self,
    "modulate",
    Color(3, 3, 3, 1),
    Color(1, 1, 1, 1),
    0.1,
    Tween.TRANS_QUART,
    Tween.EASE_IN
  )
  flash_tween.start()
