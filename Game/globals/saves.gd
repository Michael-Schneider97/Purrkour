
extends Node

const SAVE_PATH = "user://level_progress.save"

enum LevelProgress { LOCKED, IN_PROGRESS, COMPLETE }

var levels = {
	1: LevelProgress.IN_PROGRESS,
	2: LevelProgress.LOCKED,
	3: LevelProgress.LOCKED,
	4: LevelProgress.LOCKED,
	5: LevelProgress.LOCKED
}


func _ready():
	load_progress()


func get_level_state(level: int) -> LevelProgress:
	return levels.get(level, LevelProgress.LOCKED)


func set_level_state(level: int, state: LevelProgress):
	if not levels.has(level):
		return

	levels[level] = state
	save_progress()


func complete_level(level: int):
	if not levels.has(level):
		return

	levels[level] = LevelProgress.COMPLETE

	if level < 5:
		levels[level + 1] = LevelProgress.IN_PROGRESS

	save_progress()


func save_progress():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return

	file.store_var(levels)
	file.close()


func load_progress():
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return

	var saved_data = file.get_var()
	file.close()

	if saved_data is Dictionary:
		for level in levels:
			if saved_data.has(level):
				levels[level] = saved_data[level]
