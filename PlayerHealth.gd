extends Node2D

onready var health_bar = $HealthBar

func _ready():
  EventBus.connect("player_damage", self, "_on_player_damage")

func _on_player_damage(data:Dictionary):
  health_bar.health = health_bar.health - data.damage
