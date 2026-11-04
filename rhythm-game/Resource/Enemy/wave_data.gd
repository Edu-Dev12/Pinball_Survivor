extends Resource
class_name WaveData

@export var all_enemies_must_be_dead_to_finish : bool = false
@export var spawn_interval_enemies: float = 0.5 # Tempo entre o nascimento de cada inimigo
@export var spawn_interval_groups: float = 5.0 # Tempo entre os grupos de inimigos nascerem
@export var time_to_next_wave : float = 5.0 # Tempo até a próxima onda
@export var wave_time: float = 30.0 # Tempo da onda
@export var enemies_to_spawn : Array[EnemyToSpawnData]
