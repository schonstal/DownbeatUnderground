extends CanvasLayer

@export var shake_duration = 0.25
@export var tween_in_duration = 0.25
@export var tween_out_duration = 0.25

@onready var left = $Left
@onready var right = $Right
@onready var start_sound = $StartSound
@onready var end_sound = $EndSound

var width = 0
var shake_time = 0
var vp_width = 1280

var left_origin
var right_origin

var min_change_time = 0.0
var t = 0.0

signal transition_complete

func _ready():
	width = left.texture.get_width() / 2.0
	left.position.x = -width - 150
	right.position.x = vp_width + 150
	left.visible = true
	right.visible = true

	left_origin = left.position.x
	right_origin = right.position.x

func _process(delta):
	t += delta
	if t > min_change_time:
		if randi() % 50 > 0:
			left.frame = 0
			right.frame = 0
		else:
			left.frame = 1
			right.frame = 1
		t = 0

	if shake_time > 0:
		offset.x = randf_range(-20, 20)
		shake_time -= delta
	else:
		offset = Vector2.ZERO

func transition_out():
	start_sound.play()

	var position_tween = create_tween()
	position_tween.tween_property(left, "position", Vector2(vp_width / 2.0 - width, 0), tween_in_duration) \
		.set_trans(Tween.TransitionType.TRANS_QUART) \
		.set_ease(Tween.EaseType.EASE_IN)
	position_tween.tween_property(right, "position", Vector2(vp_width / 2.0, 0), tween_in_duration) \
		.set_trans(Tween.TransitionType.TRANS_QUART) \
		.set_ease(Tween.EaseType.EASE_IN)
	await position_tween.finished

	emit_signal("transition_complete")

	if right.position.x < 1000:
		shake_time = shake_duration
		end_sound.play()

func transition_in():
	var position_tween = create_tween()
	position_tween.tween_property(left, "position", Vector2(left_origin, 0), tween_out_duration) \
		.set_trans(Tween.TransitionType.TRANS_QUART) \
		.set_ease(Tween.EaseType.EASE_IN)
	position_tween.tween_property(right, "position", Vector2(right_origin, 0), tween_out_duration) \
		.set_trans(Tween.TransitionType.TRANS_QUART) \
		.set_ease(Tween.EaseType.EASE_IN)
	await position_tween.finished

	emit_signal("transition_complete")

	if right.position.x < 1000:
		shake_time = shake_duration
		end_sound.play()
