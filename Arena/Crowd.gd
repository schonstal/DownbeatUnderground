extends Sprite2D

@onready var animation = $AnimationPlayer

func _ready():
  EventBus.connect("beat", Callable(self, "_on_beat"))

func _on_beat(_data:Dictionary):
  animation.stop()
  animation.play("Beat")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
