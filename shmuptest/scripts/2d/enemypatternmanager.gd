class_name EnemyPatternManager extends Path2D

var _enemies: Array[Enemy] = []
var _enemies_cleaned_up: int = 0

func prepare(
		count: int,
		gap: float,
		speed: float,
		shooter_suppliers: Array[Callable],
) -> void:
	var enemy_res = preload("res://scenes/enemy.tscn")
	for n in count:
		var path_follow = PathFollow2D.new()
		path_follow.rotates = false
		path_follow.loop = false

		var shooters: Array[Shooter] = []
		for s in shooter_suppliers:
			shooters.append(s.call())

		var enemy = enemy_res.instantiate()
		enemy.shooters = shooters
		enemy.visible = false
		enemy.path_follow = path_follow
		enemy.manager = self
		enemy.speed = speed
		_enemies.append(enemy)

		self.add_child(path_follow)
		path_follow.add_child(enemy)
		path_follow.progress_ratio += n * gap

func enemy_cleaned_up():
	self._enemies_cleaned_up += 1
	if self._enemies_cleaned_up >= self._enemies.size():
		assert(self._enemies_cleaned_up == self._enemies.size())
		self.queue_free()

func start(target: Node2D):
	for enemy in _enemies:
		enemy.start(target)
	
