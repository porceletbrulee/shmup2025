extends Node2D

@export var shooter: Node2D

var _rotating_shooter: Node2D
var _bullets: Node2D
var _timers: Node

var _player: Node2D

var _red_shooter: SalvoShooter

func _ready():
	self._rotating_shooter = $rotating_shooter
	self._bullets = $bullets
	self._timers = $timers

	self._player = preload("res://scenes/player.tscn").instantiate()
	self._player.ui_hits = $hud/hits
	self._player.ui_hits.text = "Hits: 0"
	self.add_child(self._player)
	self._player.transform.origin = Vector2(250, 400)


	var red_bullet = preload("res://scenes/redbullet.tscn")
	var shoot_at_player = func(res: Resource, speed: float, shot_origin: Node2D, target: Node2D):
		var v = Vector2(1, 0) * speed
		var angle = self.shooter.get_angle_to(target.global_position)

		var bullet = res.instantiate()
		bullet.prepare(v.rotated(angle), target)
		self._bullets.add_child(bullet)
		bullet.transform.origin = shot_origin.transform.origin

	# persist the SalvoShooter because Timer.timeout.connect(self._method)
	# will not refcount the SalvoShooter
	# https://github.com/godotengine/godot/issues/71389
	self._red_shooter = SalvoShooter.new(
		0.3, 0.6, 4,
		shoot_at_player.bind(red_bullet, 150.0, self.shooter, self._player),
		self._timers
	)
	self._red_shooter.start()

	var blue_bullet = preload("res://scenes/bluebullet.tscn")
	var diamond_path_bullet = preload("res://scenes/diamondpathbullet.tscn")
	var fork_bullet = preload("res://scenes/forkpathmultibullet.tscn")

	var shoot_timed_bullet = func(res: Resource, speed: float, shot_origin: Node2D):
		var bullet = res.instantiate()
		# important! assumes unrotated shot_origin is pointing down
		var velocity = Vector2(0, 1) * speed
		velocity = velocity.rotated(shot_origin.transform.get_rotation())
		bullet.prepare(velocity, self._player)
		self._bullets.add_child(bullet)
		bullet.transform.origin = shot_origin.transform.origin

	self._add_timer(
		0.4,
		shoot_timed_bullet.bind(blue_bullet, 75.0, self._rotating_shooter)
	)

	self._add_timer(
		1.0,
		shoot_timed_bullet.bind(diamond_path_bullet, 1.0, self.shooter)
	)

	self._add_timer(
		2.0,
		shoot_timed_bullet.bind(fork_bullet, 1.0, self.shooter)
	)

func _add_timer(timer_sec: float, callback: Callable):
	var t = Timer.new()
	t.timeout.connect(callback)
	self._timers.add_child(t)
	t.start(timer_sec)

func _process(delta_sec: float) -> void:
	self._rotating_shooter.rotate(delta_sec * PI / 8)
