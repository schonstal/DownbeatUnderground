extends Sprite2D

@onready var animation = $AnimationPlayer

func _ready():
  EventBus.beat.connect(_on_beat)

func _on_beat(_data:Dictionary):
  animation.play("pulse")
