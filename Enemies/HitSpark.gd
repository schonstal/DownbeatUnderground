extends Sprite2D

@onready var animation = $AnimationPlayer

func _ready():
  EventBus.enemy_hurt.connect(_on_enemy_hurt)
  
func _on_enemy_hurt(_data:Dictionary):
  animation.stop()
  animation.play("Flash")
