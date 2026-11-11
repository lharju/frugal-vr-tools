extends StaticBody3D
class_name Interractable

@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D

func interact() -> void:
	gpu_particles_3d.restart()
	
