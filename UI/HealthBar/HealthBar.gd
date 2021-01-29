extends Node2D

var health setget set_health,get_health

onready var over_progress = $OverProgress
onready var under_progress = $UnderProgress
onready var health_tween = $HealthTween

func get_health():
  return over_progress.value

func set_health(value):
  if value < 0:
    value = 0

  over_progress.value = value
  
  yield(get_tree().create_timer(0.3), "timeout")
  
  health_tween.stop_all()
  health_tween.interpolate_property(
    under_progress,
    "value",
    under_progress.value,
    value,
    0.2,
    Tween.TRANS_QUAD,
    Tween.EASE_OUT)
  health_tween.start()
