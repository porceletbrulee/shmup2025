extends Node2D

@export var shooter: Node2D

var _rotating_shooter: Node2D
var _bullets: Node2D
var _timers: Node

var _player: Node2D
var _enemies: EnemyPatternManager

var _red_shooter: Shooter

func _ready():
	self._rotating_shooter = $rotating_shooter
	self._bullets = $bullets
	self._timers = $timers

	self._player = preload("res://scenes/player.tscn").instantiate()
	self._player.ui_hits = $hud/hits
	self._player.ui_hits.text = "Hits: 0"
	self.add_child(self._player)
	self._player.transform.origin = Vector2(500, 400)

	var red_bullet = preload("res://scenes/redbullet.tscn")
	var blue_bullet = preload("res://scenes/bluebullet.tscn")
	var diamond_path_bullet = preload("res://scenes/diamondpathbullet.tscn")
	var fork_bullet = preload("res://scenes/forkpathmultibullet.tscn")

	var shoot_at_player = func(
				origin: Node2D,
				target: Node2D,
				res: Resource,
				speed: float,
	):
		var v = Vector2.RIGHT * speed
		var angle = origin.global_position.angle_to_point(target.global_position)

		var bullet = res.instantiate()
		bullet.global_position = origin.global_position
		bullet.prepare(v.rotated(angle), target)
		self._bullets.add_child(bullet)

	var shoot_timed_bullet = func(
			origin: Node2D,
			_target: Node2D,
			res: Resource,
			speed: float
	):
		var bullet = res.instantiate()
		# important! assumes unrotated shot_origin is pointing down
		var velocity = Vector2(0, 1) * speed
		velocity = velocity.rotated(origin.global_rotation)
		bullet.global_position = origin.global_position
		bullet.prepare(velocity, self._player)
		self._bullets.add_child(bullet)
	
	# persist the Shooter because Timer.timeout.connect(self._method)
	# will not refcount the Shooter
	# https://github.com/godotengine/godot/issues/71389
	self._red_shooter = Shooter.new(
		1.0,
		shoot_timed_bullet.bind(diamond_path_bullet, 1.0),
		self._timers
	)
	self._red_shooter.start(self.shooter, self._player)
	
	self._enemies = preload("res://scenes/roundedpathenemy.tscn").instantiate()
	self.add_child(self._enemies)
	var shooter_suppliers: Array[Callable] = [
		Shooter.new.bind(0.5, shoot_timed_bullet.bind(fork_bullet, 1.0), self._timers),
		SalvoShooter.new.bind(0.2, 3.0, 5, shoot_at_player.bind(red_bullet, 200.0), self._timers),
	]
	self._enemies.prepare(3, 0.1, 0.4, shooter_suppliers)
	self._enemies.transform.origin = Vector2(1060, 0)
	self._enemies.start(self._player)

func _add_timer(timer_sec: float, callback: Callable):
	var t = Timer.new()
	t.timeout.connect(callback)
	self._timers.add_child(t)
	t.start(timer_sec)

func _process(delta_sec: float) -> void:
	self._rotating_shooter.rotate(delta_sec * PI / 8)
