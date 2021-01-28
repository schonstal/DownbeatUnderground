extends Node2D

onready var animation = $AnimationPlayer

func _ready():
  EventBus.connect("beat_hit", self, "_on_beat_hit")
  
func _on_beat_hit(data:Dictionary):
  if data.key == KEY_UP:
    attack()
  elif data.key == KEY_DOWN:
    block()
  elif data.key == KEY_LEFT:
    dodge_left()
  elif data.key == KEY_RIGHT:
    dodge_right()
  
func attack():
  animation.play("Attack")
  
func block():
  animation.play("Block")
  
func dodge_left():
  animation.play("Dodge Left")
  
func dodge_right():
  animation.play("Dodge Right")
