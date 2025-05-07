class_name Bullet extends Area2D

var start_time: float
var end_time: float

var _position_fn: Callable
var _target_position_fn: Callable
var _level_time_fn: Callable

var _target_position: Vector2

var _grazed: bool = false

func prepare(
		p_start_time: float,
		p_end_time: float,
		p_position_fn: Callable,
		p_level_time_fn: Callable,
		p_target_position_fn: Callable = func(): return Vector2() # XXX ew
) -> void:
	self.start_time = p_start_time
	self.end_time = p_end_time
	self._position_fn = p_position_fn
	self._level_time_fn = p_level_time_fn
	self._target_position_fn = p_target_position_fn

	self.area_entered.connect(self._on_graze)
	self.body_entered.connect(self._on_hit)

func _finalize_target() -> void:
	self._target_position = self._target_position_fn.call()

func _clean_up() -> void:
	self.queue_free()

func _on_graze(area: Area2D) -> void:
	assert(area.has_method("on_graze"))
	if self._grazed:
		return
	self._grazed = true
	area.on_graze()

func _on_hit(body: PhysicsBody2D) -> void:
	assert(body.has_method("on_hit"))
	body.on_hit()
	self._clean_up()

func _move_or_clean_up() -> void:
	var level_time = self._level_time_fn.call()
	# TODO Clean up bullets that go off-screen, particularly off the sides
	# ... unless we want them to be able to come back in?
	if level_time > self.end_time:
		self._clean_up()
	var time_passed = level_time - self.start_time
	self.position = self._position_fn.call(time_passed, self._target_position)

func _ready() -> void:
	self._finalize_target()
	self._move_or_clean_up()

func _process(_delta: float) -> void:
	self._move_or_clean_up()
