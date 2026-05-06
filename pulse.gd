extends Sprite2D

@onready var animation = $AnimationPlayer

func _ready():
  EventBus.beat.connect(_on_beat)
  EventBus.beat_hit.connect(_on_beat_hit)

func _on_beat(_data:Dictionary):
  animation.play("pulse")


func _on_beat_hit(data:Dictionary):
  if data["judgement"] < 0:
    animation.play("miss")
