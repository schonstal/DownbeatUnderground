extends Node

const CONFIG_PATH := "user://downbeat_underground.cfg"

var max_samples := 30
var offset_usec := 35000

var _previous_beat := -1
var calibrating := false
var _buffer : Array[float] = []

func start() -> void:
	if calibrating:
		return

	calibrating = true
	print("calibration started")

	EventBus.calibration_started.emit()


func stop() -> void:
	if !calibrating:
		return

	calibrating = false
	print("calibration complete")

	_save_offset()
	EventBus.calibration_stopped.emit()


func reset() -> void:
	_buffer.clear()
	_previous_beat = -1


func _ready() -> void:
	_load_offset()


func _unhandled_input(e: InputEvent) -> void:
	if e is not InputEventKey:
		return

	var event : InputEventKey = e as InputEventKey
	if !event.pressed:
		return
	
	if event.keycode == KEY_C:
		if calibrating:
			stop()
		else:
			start()

	if event.keycode in [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]:
		_record_sample()


func _record_sample() -> void:
	if Conductor.beat == _previous_beat:
		return

	var target_time : float = (Conductor.beat / Conductor.bps) * 1_000_000.0
	var bound : float = 500_000.0 / Conductor.bps
	var delta : float = Time.get_ticks_usec() - Conductor.song_start_time - target_time
	delta = wrapf(delta, -bound, bound)

	_buffer.push_back(delta)
	if _buffer.size() > max_samples:
		_buffer.pop_front()

	_previous_beat = Conductor.beat

	if calibrating:
		_calibrate()


func _calibrate() -> void:
	var samples := _filter_outliers()
	print(_buffer)
	print(samples)
	print("====")
	if samples.size() < 5:
		return

	var mean : float = samples.reduce(_sum, 0) / samples.size()
	offset_usec = int(mean)
	print("new offset: ", offset_usec)


func _filter_outliers() -> Array[float]:
	if _buffer.size() < 5:
		return _buffer

	var mean : float = _buffer.reduce(_sum, 0) / _buffer.size()
	var std_dev : float = sqrt(_buffer.reduce(
		func(accum:float, sample:float) -> float: return accum + pow(sample - mean, 2)
	) / _buffer.size())

	return _buffer.filter(func(sample: float) -> bool: return abs(sample - mean) <= std_dev * 2)


func _sum(accum: float, current: float) -> float:
	return accum + current


func _load_offset() -> void:
	var config = ConfigFile.new()
	if config.load(CONFIG_PATH) == OK:
		offset_usec = config.get_value("calibration", "offset", offset_usec)


func _save_offset() -> void:
	var config = ConfigFile.new()
	config.load(CONFIG_PATH)
	config.set_value("calibration", "offset", offset_usec)
	config.save(CONFIG_PATH)
