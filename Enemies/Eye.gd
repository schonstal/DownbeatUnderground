extends Sprite

onready var animation = $AnimationPlayer

func flash():
  animation.play("Spark")
