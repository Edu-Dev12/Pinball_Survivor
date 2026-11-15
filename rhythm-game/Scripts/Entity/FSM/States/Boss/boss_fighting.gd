extends EnemyState
class_name BossFighting

@export_group("States")
@export var weighted_states: Array[StateChanceData]

@export_group("Values")
@export var rest_time: float = 3.0

var rest_timer: Timer

func _ready() -> void:
	rest_timer = Timer.new()
	rest_timer.one_shot = true
	add_child(rest_timer)
	rest_timer.timeout.connect(_on_rest_timer_timeout)

func enter() -> void:
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Fighting":
			animated_sprite.play("Fighting")
	rest_timer.start(rest_time)

func _on_rest_timer_timeout() -> void:
	var next_state = choose_next_state()
	if next_state:
		transitioned.emit(self, next_state.name)

func choose_next_state() -> State:
	var random_value = randf() * 100.0
	var accumulated = 0.0
	
	for item in weighted_states:
		var actual_state : State = get_node_or_null(item.state_path)
		
		if not actual_state:
			continue
		
		accumulated += item.chance
		if random_value <= accumulated:
			return actual_state 
	return null
