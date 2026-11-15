class_name DirectionalEffectData
extends EffectData

func setup(effect_node: Node2D, context: Dictionary) -> void:
	# Chama o comportamento padrão (ajustar posição)
	super(effect_node, context)
	
	# Aplica a lógica de direção específica deste efeito
	if context.has("direction") and effect_node.has_method("set_direction"):
		effect_node.set_direction(context.get("direction"))
