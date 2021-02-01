extends Node2D

var started = false

func _ready():
  yield(get_tree().create_timer(0.5), "timeout")
  Transition.transition_out()
  yield(Transition, "transition_complete")
  yield(get_tree().create_timer(1), "timeout")
  $Music.play()
  $CanvasLayer/Title/AnimationPlayer.play("Fade")
  yield(get_tree().create_timer(0.5), "timeout")
  $CanvasLayer/Label/AnimationPlayer.play("Flash")
  started = true

func _process(delta):
  if !started:
    return
  if Input.is_action_just_pressed("ui_up"):
    start_game()
    started = false
    
func start_game():
  $StartSound.play()
  $CanvasLayer/Title/AnimationPlayer.play_backwards("Fade")
  $Music/AnimationPlayer.play("Fade")
  $CanvasLayer/Label/AnimationPlayer.stop()
  $CanvasLayer/Label.visible = false
  yield($CanvasLayer/Title/AnimationPlayer, "animation_finished")
  get_tree().change_scene("res://Scenes/Gameplay.tscn")
