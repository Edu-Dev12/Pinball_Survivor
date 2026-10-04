extends Node

@onready var bgm_streamer := $BackgroundMusic

var current_music_index := 0
var musics := [
]

func _ready() -> void:
	bgm_streamer.finished.connect(_on_music_finished)

func change_current_music(music: AudioStream):
	bgm_streamer.stream = music
	bgm_streamer.bus = "Music"
	bgm_streamer.play()

#Da play na musica atual da lista, possibilitando uma fila de musicas
func play_current_music() -> void:
	if musics.is_empty():
		return
	
	bgm_streamer.stream = musics[current_music_index]
	bgm_streamer.bus = "Music"
	bgm_streamer.play()

func _on_music_finished() -> void:
	if musics.is_empty():
		return
		
	current_music_index += 1
	if current_music_index >= musics.size():
		current_music_index = 0
	play_current_music()

func stop_music():
	bgm_streamer.stop()

func play_sound_effect(stream: AudioStream, bus: String = "SFX", volume_db: float = 0.0, pitch_min: float = 0.90, pitch_max: float = 1.05) -> void:
	var new_sfx := AudioStreamPlayer.new()

	new_sfx.stream = stream
	new_sfx.bus = bus
	new_sfx.volume_db = volume_db
	new_sfx.pitch_scale = randf_range(pitch_min, pitch_max)
	
	new_sfx.finished.connect(
		destroy_stream_player.bind(new_sfx)
	)
	add_child(new_sfx)
	new_sfx.play()

func destroy_stream_player(stream_player: AudioStreamPlayer) -> void:
	stream_player.queue_free()
