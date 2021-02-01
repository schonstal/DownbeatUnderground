extends Node2D

onready var health_bar = $HealthBar

func _ready():
  EventBus.connect("player_hurt", self, "_on_player_hurt")

func _on_player_hurt(data:Dictionary):
  health_bar.health = 92 * (float(data.health) / data.max_health)
