extends PositionEffect
class_name ScoreEffectData

func setup(effect_node: Node2D, context: Dictionary) -> void:
	super(effect_node, context)
	if context.has("score"):
		effect_node.score = context.get("score")
