class_name CloudBackground extends Node2D

var scene: PackedScene

var _cloud_layers: Array[CloudLayer]

func _ready() -> void:
	self.scene = preload("res://scenes/cloudsprite.tscn")
	self._cloud_layers = [
		CloudLayer.new(3.3, 75.0, 1.5, -2),
		CloudLayer.new(5.5, 25.0, 2.0, -3),
	]

func _process(delta: float) -> void:
	# XXX: will this change on resizes? is this expensive?
	var viewport_rect = self.get_viewport_rect()
	for layer in self._cloud_layers:
		layer.process(viewport_rect, delta)
		layer.maybe_new_clouds(viewport_rect, self, delta)

class CloudLayer extends RefCounted:
	const X_SCALE_MAX = 2.5
	const Y_SCALE_MULT_MAX = 1.2


	var clouds: Array[Sprite2D]
	var cloud_speed: float
	var avg_cloud_gap_sec: float
	var cloud_scale: float
	var z_index: int

	var _cached_height: float
	var _since_last_cloud_sec: float
	var _next_cloud_sec: float

	func _init(
		pavg_cloud_gap_sec: float,
		pcloud_speed: float,
		pcloud_scale: float,
		pz_index: int):
		self.clouds = []
		self.cloud_speed = pcloud_speed
		self.avg_cloud_gap_sec = pavg_cloud_gap_sec
		self.cloud_scale = pcloud_scale
		self.z_index = pz_index

		self._cached_height = -1

		self._next_cloud_sec = self.gen_next_cloud_sec()
		self._since_last_cloud_sec = self._next_cloud_sec / 2.0

	func gen_next_cloud_sec() -> float:
		return randfn(
			self.avg_cloud_gap_sec,
			self.avg_cloud_gap_sec * 2.0 / 5.0)

	func maybe_new_clouds(
		viewport_rect: Rect2,
		bg: CloudBackground,
		delta_sec: float):
		self._since_last_cloud_sec += delta_sec
		if self._since_last_cloud_sec < self._next_cloud_sec:
			return

		var cloud = bg.scene.instantiate()

		if self._cached_height < 0:
			self._cached_height = cloud.get_rect().size.y

		var y = -X_SCALE_MAX * Y_SCALE_MULT_MAX * self._cached_height
		cloud.position = Vector2(randi() % roundi(viewport_rect.size.x), y)
		cloud.frame = randi() % (cloud.vframes * cloud.hframes)

		var x_scale = randf_range(1.0, X_SCALE_MAX) * self.cloud_scale
		cloud.scale.x *= x_scale
		# don't make y scale be too different from x scale
		cloud.scale.y *= x_scale * randf_range(0.8, Y_SCALE_MULT_MAX)
		cloud.z_index = self.z_index

		bg.add_child(cloud)
		self.clouds.append(cloud)

		self._since_last_cloud_sec = 0
		self._next_cloud_sec =  self.gen_next_cloud_sec()

	func process(viewport_rect: Rect2, delta_sec: float):
		# XXX: smells bad
		var new_clouds: Array[Sprite2D] = []
		for cloud in self.clouds:
			cloud.position.y += self.cloud_speed * delta_sec
			var y_max = viewport_rect.size.y + (X_SCALE_MAX * Y_SCALE_MULT_MAX * self._cached_height)
			if cloud.position.y >= y_max:
				cloud.queue_free()
			else:
				new_clouds.append(cloud)
		self.clouds = new_clouds
