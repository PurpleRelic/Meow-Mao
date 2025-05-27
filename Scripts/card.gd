extends Node2D

signal hover_on
signal hover_off

var hand_position 
var rank
var suit
var in_slot = false
var in_opponent = false

func _ready() -> void:
	get_parent().connect_card_signals(self)


func _on_area_2d_mouse_entered() -> void:
	if !in_opponent and !in_slot:
		emit_signal("hover_on",self)


func _on_area_2d_mouse_exited() -> void:
	if !in_opponent and !in_slot:
		emit_signal("hover_off",self)
