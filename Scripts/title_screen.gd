extends Control


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/meow_mao.tscn")


func _on_rules_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/rules_explanation.tscn")
