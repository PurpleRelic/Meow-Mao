extends Node2D

signal left_mouse_clicked
signal left_mouse_released

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_DECK = 4

func _ready() -> void:
	Global.input_manager = self

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("left_mouse_clicked")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_released")

func raycast_at_cursor():
	if Global.turn == "Opponent" or Global.round_status == 2:
		return
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var highest_card = null
		var found_deck = false
		for i in range(result.size()):
			var result_collision_mask = result[i].collider.collision_mask
			if result_collision_mask == COLLISION_MASK_CARD:
				# Card clicked
				var card_found = result[i].collider.get_parent()
				if card_found and !card_found.in_opponent:
					if not highest_card or (card_found.z_index > highest_card.z_index):
						highest_card = card_found
			elif result_collision_mask == COLLISION_MASK_DECK:
				# Deck clicked
				found_deck = true
		if found_deck:
			Global.deck.reset_hand("Player")
		elif highest_card:
			Global.card_manager.start_drag(highest_card)
			
