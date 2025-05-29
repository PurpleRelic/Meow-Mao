extends Control


func _on_easy_pressed() -> void:
	Global.difficulty = 1
	get_tree().change_scene_to_file("res://Scenes/meow_mao.tscn")

func _on_medium_pressed() -> void:
	Global.difficulty = 2
	get_tree().change_scene_to_file("res://Scenes/meow_mao.tscn")

func _on_hard_pressed() -> void:
	Global.difficulty = 3
	get_tree().change_scene_to_file("res://Scenes/meow_mao.tscn")
