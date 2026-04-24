extends Node2D

var health : get = get_health, set = set_health

@onready var over_progress = $OverProgress
@onready var under_progress = $UnderProgress

var _tween: Tween

func get_health():
	return over_progress.value

func set_health(value):
	if value < 0:
		value = 0

	over_progress.value = value

	await get_tree().create_timer(0.3).timeout

	if _tween:
		_tween.kill()

	_tween = create_tween()
	_tween.tween_property(under_progress, "value", value, 0.2) \
		.set_trans(Tween.TransitionType.TRANS_QUAD) \
		.set_ease(Tween.EaseType.EASE_OUT)
