extends Sprite

onready var animation = $AnimationPlayer

func _ready():
  EventBus.connect("enemy_hurt", self, "_on_enemy_hurt")
  
func _on_enemy_hurt(_data:Dictionary):
  animation.stop()
  animation.play("Flash")
