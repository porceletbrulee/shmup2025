class_name Bullet extends Area2D

@onready var _visible_on_screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready():
	self._visible_on_screen_notifier.screen_exited.connect(self.queue_free)
