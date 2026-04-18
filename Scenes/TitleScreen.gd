extends Node2D

var started = false

func _ready():
	await get_tree().create_timer(0.5).timeout
	Transition.transition_out()
	await Transition.transition_complete
	await get_tree().create_timer(1).timeout
	$Music.play()
	$CanvasLayer/Title/AnimationPlayer.play("Fade")
	await get_tree().create_timer(0.5).timeout
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
	await $CanvasLayer/Title/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Gameplay.tscn")
