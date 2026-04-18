extends Sprite2D

@onready var animation = $AnimationPlayer

func flash():
  animation.play("Spark")
