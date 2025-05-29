extends Node

var turn_timer
var play_timer
var base_turn_speed = 1.5
var fail_chance = 0.0

func _ready() -> void:
	turn_timer = $"Turn Timer"
	turn_timer.one_shot = true
	play_timer = $"Play Timer"
	play_timer.one_shot = true
	Global.opponent_ai = self
	base_turn_speed = (1.5 / Global.difficulty) + 0.5

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
			Global.deck.reset_hand("Opponent")
			attempts += 1
		
	# Set turn timer
	var turn_length = (base_turn_speed / 2) + (base_turn_speed * randf()) - 0.5
	turn_timer.wait_time = turn_length
	
	# Take turn, card should be tweened with the same time as the wait time so they end together
	
	turn_timer.start()
	await turn_timer.timeout
	play_card(find_card(rightplay, true))
	fail_chance += (0.1 / float(Global.difficulty))
	turn_timer.wait_time = 0.5
	turn_timer.start()
	await turn_timer.timeout
	
	Global.timer_manager.alternate_timers()
	Global.turn = "Player"

func find_card(rightplay, override):
	var playable_cards = []
	for i in range(0,Global.opponent_hand.opponent_hand.size()):
		if Global.rule_manager.check_rules(Global.card_slot.card_in_slot,
								Global.opponent_hand.opponent_hand[i]) == rightplay:
			playable_cards.insert(0,Global.opponent_hand.opponent_hand[i])
	if playable_cards.size() == 0 and (!rightplay or override):
		return Global.opponent_hand.opponent_hand[randi_range(0,Global.opponent_hand.opponent_hand.size()-1)]
	elif playable_cards.size() == 0:
		return null
	else:
		return playable_cards[randi_range(0,playable_cards.size()-1)]


func play_card(played_card):
	# Plays the card from hand over 0.5 seconds
	var tween = get_tree().create_tween()
	tween.tween_property(played_card, "position",Global.card_slot.position,0.5)
	
	play_timer.wait_time = 0.3
	play_timer.start()
	await play_timer.timeout
	
	played_card.get_node("AnimationPlayer").play("Card Flip")
	
	play_timer.wait_time = 0.21
	play_timer.start()
	await play_timer.timeout
	if Global.card_slot.card_in_slot:
		if !Global.rule_manager.check_rules(Global.card_slot.card_in_slot,played_card):
			Global.rule_manager.write_failed_rules(Global.card_slot.card_in_slot,played_card)
			Global.round_manager.endround("Player")
		Global.card_slot.card_in_slot.free()
	Global.card_slot.card_in_slot = played_card
	Global.opponent_hand.remove_card_from_hand(played_card)
	played_card.z_index = -2
	played_card.in_slot = true
	played_card.in_opponent = false
	Global.deck.draw_card("Opponent")
