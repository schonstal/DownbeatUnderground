extends Sprite2D

@export var rotation_rate = 1.0

func _process(delta):
  rotation += delta * PI * 2 * rotation_rate
