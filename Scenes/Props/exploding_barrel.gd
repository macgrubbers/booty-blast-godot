class_name ExplodingBarrel extends RigidBody3D

@onready var fuse_duration:float = 3.0

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
	$FuseParticles.emitting = false
	$ExplosionParticles.emitting = true
	$Meshes.visible = false
	$CollisionShape3D.disabled = true
	explosion.activate()
	await $ExplosionParticles.finished
	queue_free()
