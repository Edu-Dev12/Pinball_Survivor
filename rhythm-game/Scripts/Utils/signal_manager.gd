@warning_ignore_start("unused_signal")
extends Node

# Level Management
signal level_timer_ended
signal level_won
signal next_level_reached(next_level: String)
signal level_loaded(new_tilemap: TileMapLayer)
signal game_over

# Player Management
signal player_spawned(player: CharacterBody2D)
signal player_died

# Camera Management
signal request_camera_reference
signal respond_camera_reference(camera: Camera2D)
signal disable_camera_follow
