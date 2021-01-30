extends Sprite

onready var animation = $AnimationPlayer

func _ready():
  EventBus.connect("enemy_damage", self, "_on_enemy_damage")
  
func _on_enemy_damage(_data:Dictionary):
  animation.stop()
  animation.play("Flash")
