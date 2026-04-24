extends ColorRect

var strength = 0.1

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	EventBus.blur_chromatic.connect(_on_blur_chromatic)
	EventBus.victory.connect(_on_victory)

func _process(delta):
	material.set_shader_parameter("amount", strength)

func _on_blur_chromatic(size, duration):
	strength = size
	create_tween() \
		.tween_property(self, "strength", 0.1, duration) \
		.set_trans(Tween.TransitionType.TRANS_QUART) \
		.set_ease(Tween.EaseType.EASE_OUT)

func _on_victory():
	create_tween() \
		.tween_property(self, "strength", 1.0, 2.0) \
		.set_trans(Tween.TransitionType.TRANS_QUART) \
		.set_ease(Tween.EaseType.EASE_OUT) \
		.set_delay(3.0)
