extends EffectData
class_name PositionEffect

func setup(effect_node: Node2D, context: Dictionary) -> void:
	if context.has("position"):
		effect_node.global_position = context.get("position")
