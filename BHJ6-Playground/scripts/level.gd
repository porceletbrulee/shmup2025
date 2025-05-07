extends Node2D

var _count
var _bullets: Array[Bullet] = []
var _level_time: float = 0.0
var _player: CharacterBody2D
var _bullet_res: Resource

func level_time() -> float:
	return self._level_time

func _by_start_time_desc(a: Bullet, b: Bullet):
	return a.start_time > b.start_time

func _is_not_ready(bullet: Bullet) -> bool:
	return bullet.start_time > self._level_time

func _create_aimed_bullet(
		start_x: float,
		start_y: float,
		start_time: float,
		end_time: float,
		speed: float, # px/s
		level_time_fn: Callable,
		target_position_fn: Callable,
		bullet_res: Resource
) -> Bullet:
	var start_position := Vector2(start_x, start_y)
	var bullet = bullet_res.instantiate()
	var pos_fn = func(time: float, target_position: Vector2):
		var distance := start_position.distance_to(target_position)
		var weight := speed / distance * time
		return start_position.lerp(target_position, weight)
	bullet.prepare(
		start_time, end_time,
		pos_fn, level_time_fn, target_position_fn)
	return bullet

func _ready() -> void:
	self._player = $Player
	self._bullet_res = preload("res://scenes/bullet.tscn")
	var pp_fn := func(): return self._player.position
	var x_step := Game.LEVEL_SIZE.x * 0.1
	var y_step := 10
	var t := 0.0
	while t <= 60.0:
		t += 0.3
		var x := 0.0
		while x < Game.LEVEL_SIZE.x:
			x += x_step
			for y in range(-30, 0, y_step):
				var bullet = self._create_aimed_bullet(
					x, y, t, t + 10.0, 300.0,
					self.level_time, pp_fn,
					self._bullet_res)
				self._bullets.append(bullet)
	self._bullets.sort_custom(self._by_start_time_desc)
	self._count = self._bullets.size()

func _process(delta: float) -> void:
	self._level_time += delta
	if Input.is_key_pressed(KEY_A):
		self._level_time -= delta * 2
	if Input.is_key_pressed(KEY_S):
		self._level_time -= delta
	if Input.is_key_pressed(KEY_D):
		self._level_time += delta

	var cutoff: int = self._bullets.rfind_custom(self._is_not_ready)
	for i in range(self._bullets.size() - 1, cutoff, -1):
		# TODO only add easy/hard bullets as appropriate here
		var bullet = self._bullets[i]
		self.add_child(bullet)
	# TODO always resize easy/hard arrays to avoid outdated spawns
	self._bullets.resize(cutoff + 1)

	DisplayServer.window_set_title(
		("Total bullets: %4d | " +
		"Bullets spawned: %4d | Time: %.2f") % [
			self._count,
			self._count - self._bullets.size(),
			self._level_time
		]
	)
