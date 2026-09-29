extends RigidBody2D

@onready var input_timer: Timer = $InputTimer

var can_control := true
@export var max_charge := 1200.0
@export var min_charge := 200.0
@export var charge_speed := 800.0
var charge_force := 0.0
var is_charging := false
var saved_direction := Vector2.ZERO

func _ready() -> void:
	input_timer.timeout.connect(_set_control_state.bind(true))

func _physics_process(delta: float) -> void:
	if is_charging:
		charge_force = min(charge_force + charge_speed * delta, max_charge)

func _unhandled_input(event: InputEvent) -> void:
	if not can_control:
		return
		
	var actions = ["Left", "Right", "Up", "Down"]
	
	for action in actions:
		if event.is_action_pressed(action) and not is_charging:
			var current_dir := Input.get_vector("Left", "Right", "Up", "Down")
			if current_dir != Vector2.ZERO:
				saved_direction = current_dir
				is_charging = true
				charge_force = min_charge
				break
			
		if event.is_action_released(action) and is_charging:
			if saved_direction != Vector2.ZERO:
				apply_impulse(saved_direction * charge_force)
				can_control = false
				input_timer.start()
			
			is_charging = false
			saved_direction = Vector2.ZERO
			break

func _set_control_state(should_enable: bool) -> void:
	can_control = should_enable
	
func get_collision(body: Node):
	print(body)
	if body.is_in_group("Enemy"):
		body.queue_free()
