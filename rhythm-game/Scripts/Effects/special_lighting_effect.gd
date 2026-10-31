extends Node2D

@onready var lightning_sphere: GPUParticles2D = $LightningSphere
@onready var lightning_particles: GPUParticles2D = $LightningParticles
@onready var lightning_flare: GPUParticles2D = $LightningFlare
@onready var impact_rect: ColorRect = $CanvasLayer/ImpactRect
@onready var wave_effect: GPUParticles2D = $WaveEffect

func _ready() -> void:
	#trigger_impact_frame()
	lightning_sphere.emitting = true
	lightning_particles.emitting = true
	lightning_flare.emitting = true
	wave_effect.emitting = true
	
	Engine.time_scale = 0.1
	
	var tween = create_tween()
	tween.set_speed_scale(1.0 / Engine.time_scale)
	
	# Mantém no slow motion total por um breve período (ex: 0.1 segundos reais)
	tween.tween_interval(0.1)
	
	# Transiciona o time_scale suavemente de 0.1 de volta para 1.0 ao longo de 0.4 segundos reais
	tween.tween_property(Engine, "time_scale", 1.0, 1.0).set_trans(Tween.TRANS_LINEAR)


func trigger_impact_frame() -> void:
	var mat = impact_rect.material as ShaderMaterial
	if not mat: return
	
	mat.set_shader_parameter("mix_amount", 1.0)
	mat.set_shader_parameter("flip_colors", false) 
	
	var tween = create_tween()
	if Engine.time_scale > 0.0:
		tween.set_speed_scale(1.0 / Engine.time_scale)
	
	tween.tween_interval(0.005)
	tween.tween_property(mat, "shader_parameter/mix_amount", 0.0, 0.01)
