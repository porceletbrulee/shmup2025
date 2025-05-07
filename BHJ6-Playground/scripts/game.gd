class_name Game extends Node

const LEVEL_SIZE := Vector2(612.0, 720.0)
const LEVEL_OFFSET := Vector2(334.0, 0.0)
var _fps_display: Label
var _graze_display: Label
var _player: CharacterBody2D
var _level: Node2D

func _ready() -> void:
	self._fps_display = $RightBorder/FPSDisplay
	self._graze_display = $RightBorder/GrazeDisplay
	self._player = $Level/Player
	self._level = $Level

func _process(_delta: float) -> void:
	var fps = "%.1f" % Engine.get_frames_per_second()
	self._fps_display.text = fps
	var grazed = "Grazed: %d" % self._player.get_grazed()
	self._graze_display.text = grazed
