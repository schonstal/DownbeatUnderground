extends Node2D

@onready var health_bar = $HealthBar

func _ready():
  EventBus.enemy_hurt.connect(_on_enemy_hurt)

func _on_enemy_hurt(data:Dictionary):
  health_bar.health = 89 * (float(data.health) / data.max_health) + 3
