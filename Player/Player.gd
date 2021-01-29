extends Node2D

onready var animation = $AnimationPlayer

var STATE_IDLE = "idle"
var STATE_ATTACK = "attack"
var STATE_BLOCK = "block"
var STATE_DODGE_LEFT = "dodge_left"
var STATE_DODGE_RIGHT = "dodge_right"

var state = STATE_IDLE

func _ready():
  EventBus.connect("beat_hit", self, "_on_beat_hit")

func _on_beat_hit(data:Dictionary):
  if data.judgement < 0:
    idle()
    return

  if data.action == STATE_ATTACK:
    attack()
  elif data.action == STATE_BLOCK:
    block()
  elif data.action == STATE_DODGE_LEFT:
    dodge_left()
  elif data.action == STATE_DODGE_RIGHT:
    dodge_right()

func idle():
  animation.play("Idle")
  change_state(STATE_IDLE)

func attack():
  EventBus.emit_signal("player_attack", { "damage": 10 })
  animation.stop()
  animation.play("Attack")
  change_state(STATE_ATTACK)

func block():
  animation.stop()
  animation.play("Block")
  change_state(STATE_BLOCK)

func dodge_left():
  animation.stop()
  animation.play("Dodge Left")
  change_state(STATE_DODGE_LEFT)

func dodge_right():
  animation.stop()
  animation.play("Dodge Right")
  change_state(STATE_DODGE_RIGHT)

func change_state(new_state):
  self.state = new_state
