extends Resource
class_name WaveData

signal wave_finished

@export var all_enemies_must_be_dead_to_finish : bool = false
@export var wave_time: int
@export var time_to_next_wave : int
@export var enemies_to_spawn : Array[EnemyToSpawnData]
