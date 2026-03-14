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

## 关卡进度
var game_percentage: float = 0.0
## 钻石数量
var diamond_count: int = 0
## 皇冠数量
var crown_count: int = 0
## 当前游戏状态
var state: GameState = GameState.READY
## 音频文件
var music_clip: AudioStream
## 音频长度
var music_length: float
## 已过时间
var elapsed_time: float = 0.0

func _ready() -> void:
    assert(line != null, "GameManager尚未设置Line对象！")
    # 连接Line的信号
    line.level_start.connect(_on_level_start)
    line.level_complete.connect(_on_level_complete)
    line.level_failed.connect(_on_level_failed)
    music_clip = line.get_node("Music").stream
    music_length = music_clip.get_length()

func _process(delta: float) -> void:
    if state == GameState.PLAYING:
        elapsed_time += delta
        game_percentage = min(elapsed_time / music_length, 1.0)
    
    #debug output
    print("State: %s, Time: %.2f/%.2f, Progress: %.2f%%, Diamonds: %d/%d, Crowns: %d/%d" % [state, elapsed_time, music_length, round(game_percentage * 100), diamond_count, max_diamonds, crown_count, max_crowns])

func _on_level_start() -> void:
    state = GameState.PLAYING

func _on_level_complete() -> void:
    state = GameState.COMPLETED
    #TODO: 显示结束UI，保存关卡数据等

func _on_level_failed() -> void:
    state = GameState.FAILED
    #TODO: 可复活时展示复活UI，否则展示结束UI，保存关卡数据等

func _on_diamond_collected() -> void:
    diamond_count += 1

func _on_crown_collected() -> void:
    crown_count += 1