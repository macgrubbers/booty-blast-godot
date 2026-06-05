class_name ExplodingBarrel extends RigidBody3D

@onready var fuse_duration:float = 5.0

@onready var explosion: HurtShapeCast = $HurtShapeCast
@onready var fuse = $Fuse

func _ready() -> void:
	fuse.set_wait_time(fuse_duration)
	fuse.connect("timeout", detonate)

func interact():
	if fuse.is_stopped():
		fuse.start()
		$FuseParticles.emitting = true

func detonate():
	print("BOOM!")
	explosion.activate()
	queue_free()
