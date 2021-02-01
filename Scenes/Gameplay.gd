extends Node2D

var can_restart = false

func _ready():
  Transition.transition_in()
  EventBus.connect("game_over", self, "_on_game_over")
  
func _on_game_over(_data:Dictionary):
  yield(get_tree().create_timer(5.0), "timeout")
  $HUD/Label/AnimationPlayer.play("Flash")
  can_restart = true
  
func _process(delta):
  if can_restart && Input.is_action_just_pressed("ui_up"):
    can_restart = false
    restart()
    
func restart():
  Transition.transition_out()
  yield(get_tree().create_timer(1.0), "timeout")
  get_tree().change_scene("res://Scenes/Gameplay.tscn")
