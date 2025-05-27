extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2

var screen_size
var card_being_dragged
var is_hovering
var player_hand_reference
var deck_reference
var timer_reference

func connect_card_signals(card):
	card.connect("hover_on",on_hover_over_card)
	card.connect("hover_off",on_hover_off_card)

func on_hover_over_card(card):
	if !is_hovering:
		is_hovering = true
		highlight_card(card,true)
	
func on_hover_off_card(card):
	if !card_being_dragged:
		highlight_card(card,false)
		var new_card = check_for_card()
		if new_card:
			highlight_card(new_card,true)
		else:
			is_hovering = false

func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(1.1,1.1)
		card.z_index = 2
	else:
		card.scale = Vector2(1,1)
		card.z_index = 1
	
func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../Player Hand"
	$"../Input Manager".connect("left_mouse_released",on_left_click_released)
	deck_reference = $"../Deck"
	timer_reference = $"../Timer Manager"

func _process(_delta: float) -> void:
	if card_being_dragged:
		var mousepos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mousepos.x,0,screen_size.x),clamp(mousepos.y,0,screen_size.y))

func start_drag(card):
	var slot_found = check_for_card_slot()
	if !slot_found:
		card.scale = Vector2(1,1)
		card_being_dragged = card

func end_drag():
	var slot_found = check_for_card_slot()
	if slot_found:
		var rulepass = true
		var tween = get_tree().create_tween()
		tween.tween_property(card_being_dragged, "position",slot_found.position,0.05)
		if slot_found.card_in_slot:
			if !$"../Rule Manager".check_rules(slot_found.card_in_slot,card_being_dragged):
				$"../Rule Manager".write_failed_rules(slot_found.card_in_slot,card_being_dragged)
				$"../Round Manager".endround("Opponent")
				rulepass = false
			slot_found.card_in_slot.free()
		highlight_card(card_being_dragged,false)
		slot_found.card_in_slot = card_being_dragged
		card_being_dragged.in_slot = true
		player_hand_reference.remove_card_from_hand(card_being_dragged)
		card_being_dragged.z_index = -2
		deck_reference.draw_card("Player")
		if rulepass:
			timer_reference.alternate_timers()
			$"../Input Manager".turn_pass()
			$"../Opponent AI".opponent_turn()
	else:
		card_being_dragged.scale = Vector2(1.1,1.1)
		player_hand_reference.add_card_to_hand(card_being_dragged,0)
	card_being_dragged = null

func check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		#return result[0].collider.get_parent()
		return get_highest_card(result)
	return null

func get_highest_card(cards):
	var highest_card = cards[0].collider.get_parent()
	for i in range(1,cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_card.z_index:
			highest_card = current_card
	return highest_card

func on_left_click_released():
	if card_being_dragged:
		end_drag()

func change_card_rank(card,new_rank):
	var final_rank
	if new_rank == 1:
		final_rank = "A"
	elif new_rank == 11:
		final_rank = "J"
	elif new_rank == 12:
		final_rank = "Q"
	elif new_rank == 13:
		final_rank = "K"
	else:
		final_rank = str(new_rank)
	card.get_node("Rank1").text = final_rank
	card.get_node("Rank2").text = final_rank
	card.get_node("Rank3").text = final_rank
	card.get_node("Rank4").text = final_rank
	card.rank = new_rank

func change_card_suit(card,new_suit):
	card.get_node("Suit1").texture = load(str("res://Images/"+new_suit+".png"))
	card.get_node("Suit2").texture = load(str("res://Images/"+new_suit+".png"))
	card.get_node("Suit3").texture = load(str("res://Images/"+new_suit+".png"))
	card.get_node("Suit4").texture = load(str("res://Images/"+new_suit+".png"))
	card.suit = new_suit
