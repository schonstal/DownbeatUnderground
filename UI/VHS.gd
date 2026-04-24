extends BackBufferCopy

@onready var color_rect = $ColorRect

var _tween: Tween

func _ready():
	EventBus.player_damage.connect(_on_player_damage)
	color_rect.visible = false

func _on_player_damage(_data:Dictionary):
	if _tween:
		_tween.kill()

	color_rect.visible = true
	color_rect.material.set_shader_parameter("strength", 1.25)

	_tween = create_tween()
	_tween.tween_method(func(val): color_rect.material.set_shader_parameter("strength", val), 1.25, 0, 0.25) \
		.set_trans(Tween.TransitionType.TRANS_QUAD) \
		.set_ease(Tween.EaseType.EASE_OUT)

	await _tween.finished

	color_rect.visible = false
