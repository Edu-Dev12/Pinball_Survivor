extends Node2D
class_name FlipperControllerComponent

@export var flipperHitComponent: FlipperHitComponent

func _physics_process(delta: float) -> void:
	flipperHitComponent.flipper_charge(delta)
