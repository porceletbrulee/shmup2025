class_name Player extends CharacterBody2D

var _speed = 300
var _hit: int = 0
var _grazed: int = 0

func get_grazed() -> int:
	return _grazed

func on_graze() -> void:
	self._grazed += 1

func on_hit() -> void:
	self._hit += 1

func _handle_movement() -> void:
	self.velocity = Input.get_vector(
		"ui_left", "ui_right", "ui_up", "ui_down")

	if Input.is_action_just_pressed("focus"):
		self._speed /= 2
		$HitBoxSprite.visible = true
	if Input.is_action_just_released("focus"):
		self._speed *= 2
		$HitBoxSprite.visible = false

	self.velocity *= self._speed
	self.move_and_slide()

func _physics_process(_delta: float) -> void:
	self._handle_movement()
