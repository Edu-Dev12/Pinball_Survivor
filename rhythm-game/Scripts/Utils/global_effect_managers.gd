extends Node

func spawn_effects(effects: Array[EffectData], context: Dictionary) -> void:
	for effect_data in effects:
		if not effect_data or not effect_data.effect_scene:
			continue
			
		var instance = effect_data.effect_scene.instantiate() as Node2D
		
		if instance:
			effect_data.setup(instance, context)
			instance.z_index = effect_data.z_index
			add_child(instance)
