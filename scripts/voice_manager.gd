class_name VoiceManager
extends Node3D

@export var light_attack_voices: AudioStreamRandomizer
@export var heavy_attack_voices: AudioStreamRandomizer
@export var jump_voices: AudioStreamRandomizer

@export var hurt_voices: AudioStreamRandomizer

@export var death_voices: Array[AudioStream]
@export var void_out_voices: Array[AudioStream]

@onready var voice_player: AudioStreamPlayer3D = $VoicePlayerSFX

func play_light_attack() -> void:
	if !light_attack_voices: return
	voice_player.stream = light_attack_voices
	voice_player.play()

func play_heavy_attack() -> void:
	if !heavy_attack_voices:
		play_light_attack()
		return
	voice_player.stream = heavy_attack_voices
	voice_player.play()

func play_jump() -> void:
	if !jump_voices: return
	voice_player.stream = jump_voices
	voice_player.play()

func play_hurt_voice() -> void:
	if !hurt_voices: return
	voice_player.stream = hurt_voices
	voice_player.play()

func play_death_voice() -> void:
	if !death_voices: return
	voice_player.stream = death_voices.pick_random()
	voice_player.play()

func play_void_voice() -> void:
	if !void_out_voices: return
	voice_player.stream = void_out_voices.pick_random()
	voice_player.play()
