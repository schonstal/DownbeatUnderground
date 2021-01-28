extends Sprite

onready var animation = $AnimationPlayer

func _ready():
  EventBus.connect("beat", self, "_on_beat")

func _on_beat(data:Dictionary):
  animation.play("pulse")
