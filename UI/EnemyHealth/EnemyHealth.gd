extends Node2D

onready var health_bar = $HealthBar

func _ready():
  EventBus.connect("enemy_damage", self, "_on_enemy_damage")

func _on_enemy_damage(data:Dictionary):
  health_bar.health = health_bar.health - data.damage

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
