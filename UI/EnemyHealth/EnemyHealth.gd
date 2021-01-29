extends Node2D

onready var health_bar = $HealthBar

func _ready():
  EventBus.connect("player_attack", self, "_on_player_attack")

func _on_player_attack(data:Dictionary):
  health_bar.health = health_bar.health - data.damage

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
