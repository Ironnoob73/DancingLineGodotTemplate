extends Node

enum GameState {
    READY,
    PLAYING,
    COMPLETED,
    FAILED
}

## 场景ID。用于关卡数据保存。必须在整个项目内保持唯一。
@export var level_id: int
## 最大钻石数量
@export var max_diamonds: int = 10
## 最大皇冠数量
@export var max_crowns: int = 3

## 主角Line对象。
@export var line: CharacterBody3D
# TODO: 各类UI

## Level percentage (0.0 - 1.0)
var game_percentage: float = 0.0
## Diamond count
var diamond_count: int = 0
## Crown count
var crown_count: int = 0
## Current game state
var state: GameState = GameState.READY
## Audio file
var music_clip: AudioStream
## Audio length
var music_length: float
## Time elapsed since level start
var elapsed_time: float = 0.0

func _ready() -> void:
    assert(line != null, "GameManager尚未设置Line对象！")
    # Connect signals
    line.level_start.connect(_on_level_start)
    line.level_complete.connect(_on_level_complete)
    line.level_failed.connect(_on_level_failed)
    # Get music length for progress calculation
    music_clip = line.get_node("Music").stream
    music_length = music_clip.get_length()

func _process(delta: float) -> void:
    # Update game percentage when playing
    if state == GameState.PLAYING:
        elapsed_time += delta
        game_percentage = min(elapsed_time / music_length, 1.0)
    
    # debug output
    # [ ]: Disable this in production
    print("State: %s, Time: %.2f/%.2f, Progress: %.2f%%, Diamonds: %d/%d, Crowns: %d/%d" % [state, elapsed_time, music_length, round(game_percentage * 100), diamond_count, max_diamonds, crown_count, max_crowns])

func _on_level_start() -> void:
    state = GameState.PLAYING

func _on_level_complete() -> void:
    state = GameState.COMPLETED
    #TODO: Ending UI, save level data, etc.

func _on_level_failed() -> void:
    state = GameState.FAILED
    #TODO: Revive if available, Ending UI, save level data, etc.

func _on_diamond_collected() -> void:
    diamond_count += 1

func _on_crown_collected() -> void:
    crown_count += 1