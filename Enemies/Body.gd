extends Node2D

var _tween: Tween

func _ready():
	EventBus.enemy_hurt.connect(_on_enemy_hurt)

func _on_enemy_hurt(_data:Dictionary):
	if _tween:
		_tween.kill()

	modulate = Color(0.7, 0.5, 0.7, 1)
	_tween = create_tween()
	_tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.1) \
		.set_trans(Tween.TransitionType.TRANS_QUART) \
		.set_ease(Tween.EaseType.EASE_IN)

	await _tween.finished

	modulate = Color(3, 3, 3, 1)
	_tween = create_tween()
	_tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.1) \
		.set_trans(Tween.TransitionType.TRANS_QUART) \
		.set_ease(Tween.EaseType.EASE_IN)
