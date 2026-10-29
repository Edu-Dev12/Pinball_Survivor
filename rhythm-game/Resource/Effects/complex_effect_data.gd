class_name ComplexEffectData
extends EffectData

@export_group("Configurações do Efeito")
@export var use_position: bool = true
@export var use_direction: bool = false
@export var use_score: bool = false
@export var use_sprite: bool = false
@export var use_scale: bool = false

func setup(effect_node: Node2D, context: Dictionary) -> void:
	super(effect_node, context)
	
	if use_position and context.has("position"):
		effect_node.global_position = context.get("position")
		
	if use_direction and context.has("direction"):
		effect_node.effect_direction = context.get("direction")
			
	if use_score and context.has("score"):
		effect_node.score = context.get("score")
			
	if use_sprite and context.has("sprite"):
		effect_node.effect_sprite = context.get("sprite")
			
	if use_scale and context.has("scale"):
		effect_node.effect_scale = context.get("scale")
