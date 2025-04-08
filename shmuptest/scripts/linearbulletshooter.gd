class_name LinearBulletShooter extends RefCounted

var _bullet_res: Resource
var _velocity_from_time: Callable

var _elapsed_sec
var _since_last_shoot_sec: float

## @param bullet_res: the resource for the bullet
## @param velocity_from_time(elapsed_sec: float,
##					         since_last_shoot_sec: float) -> Array[bool, Vector2]
## The Callable should return true when a bullet should be
## made and the bullet should have velocity specified
## by the second return value. The parameter is the total seconds elapsed
## and the seconds since the last shoot returned true
func _init(bullet_res: Resource,
		   velocity_from_time: Callable):
	self._bullet_res = bullet_res
	self._velocity_from_time = velocity_from_time
	self._elapsed_sec = 0.0
	self._since_last_shoot_sec = 0.0

func maybe_shoot(delta_sec: float, target: Node2D) -> Node2D:
	self._elapsed_sec += delta_sec
	self._since_last_shoot_sec += delta_sec
	var ret = self._velocity_from_time.call(self._elapsed_sec,
											self._since_last_shoot_sec)
	var make_bullet = ret[0]
	var v = ret[1]
	if not make_bullet:
		return null

	self._since_last_shoot_sec = 0.0

	var bullet = self._bullet_res.instantiate()
	bullet.prepare(v, target)
	return bullet
	
