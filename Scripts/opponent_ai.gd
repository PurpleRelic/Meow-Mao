extends Node

var turn_timer
var play_timer
var base_turn_speed = 1.0
var card_slot_reference
var fail_chance = 0.05
var opponent_hand_reference
var rule_manager_reference

func _ready() -> void:
	card_slot_reference = $"../Card Slot"
	opponent_hand_reference = $"../Opponent Hand"
	rule_manager_reference = $"../Rule Manager"
	turn_timer = $"Turn Timer"
	turn_timer.one_shot = true
	play_timer = $"Play Timer"
	play_timer.one_shot = true

func opponent_turn():
	# Decide if they will fail or not
	var rightplay
	if randf() <= fail_chance:
		rightplay = false
	else:
		rightplay = true
		
	# Check if there is a valid play and redraw if none, if they will play a correct card
	if rightplay:
		var attempts = 1
		while find_card(true, false) == null and attempts < 3:
			# Redraw and wait
			play_timer.wait_time = 0.5
			play_timer.start()
			await play_timer.timeout
			$"../Deck".reset_hand("Opponent")
			attempts += 1
		
	# Set turn timer
	var turn_length = (base_turn_speed / 2) + (base_turn_speed * randf()) - 0.5
	turn_timer.wait_time = turn_length
	
	# Take turn, card should be tweened with the same time as the wait time so they end together
	
	turn_timer.start()
	await turn_timer.timeout
	play_card(find_card(rightplay, true))
	fail_chance += 0.05
	turn_timer.wait_time = 0.5
	turn_timer.start()
	await turn_timer.timeout
	
	$"../Timer Manager".alternate_timers()
	$"../Input Manager".turn_pass()

func find_card(rightplay, override):
	var playable_cards = []
	for i in range(0,opponent_hand_reference.opponent_hand.size()):
		if rule_manager_reference.check_rules(card_slot_reference.card_in_slot,
								opponent_hand_reference.opponent_hand[i]) == rightplay:
			playable_cards.insert(0,opponent_hand_reference.opponent_hand[i])
	if playable_cards.size() == 0 and (!rightplay or override):
		return opponent_hand_reference.opponent_hand[randi_range(0,opponent_hand_reference.opponent_hand.size()-1)]
	elif playable_cards.size() == 0:
		return null
	else:
		return playable_cards[randi_range(0,playable_cards.size()-1)]


func play_card(played_card):
	# Plays the card from hand over 0.5 seconds
	var tween = get_tree().create_tween()
	tween.tween_property(played_card, "position",card_slot_reference.position,0.5)
	
	play_timer.wait_time = 0.3
	play_timer.start()
	await play_timer.timeout
	
	played_card.get_node("AnimationPlayer").play("Card Flip")
	
	play_timer.wait_time = 0.21
	play_timer.start()
	await play_timer.timeout
	if card_slot_reference.card_in_slot:
		if !$"../Rule Manager".check_rules(card_slot_reference.card_in_slot,played_card):
			$"../Rule Manager".write_failed_rules(card_slot_reference.card_in_slot,played_card)
			$"../Round Manager".endround("Player")
		card_slot_reference.card_in_slot.free()
	card_slot_reference.card_in_slot = played_card
	opponent_hand_reference.remove_card_from_hand(played_card)
	played_card.z_index = -2
	played_card.in_slot = true
	played_card.in_opponent = false
	$"../Deck".draw_card("Opponent")
