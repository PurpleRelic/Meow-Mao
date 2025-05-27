extends Node

# RULES
# 1: Cards cannot be the same suit twice
# 2: Cards must be within 4 of previous rank
# 3: Cards cannot be even/odd twice (Faces are neither)
# 4: Cards cannot be within 2 of previous rank
# 5: Cards must be higher, unless placed on face card

var rules_active = [0,0,0,0,0]
var num_rules = 0

func _ready() -> void:
	add_rule()

func add_rule():
	if rules_active.size() == num_rules:
		write_rules()
		return
	var to_activate = randi_range(1,rules_active.size()-num_rules)
	var current = 0
	for i in range(0,rules_active.size()):
		if rules_active[i] == 0:
			current += 1
		if current == to_activate:
			rules_active[i] = 1
			num_rules += 1
			break
	write_rules()

func write_rules():
	var rules_text = "Rules (Aces are 1):\n\n"
	if rules_active[0] == 1:
		rules_text += "Cards cannot be the same suit twice\n\n"
	if rules_active[1] == 1:
		rules_text += "Cards must be within 4 of previous rank\n\n"
	if rules_active[2] == 1:
		rules_text += "Cards cannot be even/odd twice (Faces are neither)\n\n"
	if rules_active[3] == 1:
		rules_text += "Cards cannot be within 2 of previous rank\n\n"
	if rules_active[4] == 1:
		rules_text += "Cards must be higher, unless placed on face card\n\n"
	$"Rules Text".text = rules_text

func write_failed_rules(slot_card,played_card):
	var rules_text = "Rules (Aces are 1):\n\n"
	if rules_active[0] == 1:
		if rule1(slot_card,played_card):
			rules_text += "Cards cannot be the same suit twice\n\n"
		else:
			rules_text += "[color=red]Cards cannot be the same suit twice[/color]\n\n"
	if rules_active[1] == 1:
		if rule2(slot_card,played_card):
			rules_text += "Cards must be within 4 of previous rank\n\n"
		else:
			rules_text += "[color=red]Cards must be within 4 of previous rank[/color]\n\n"
	if rules_active[2] == 1:
		if rule3(slot_card,played_card):
			rules_text += "Cards cannot be even/odd twice (Faces are neither)\n\n"
		else:
			rules_text += "[color=red]Cards cannot be even/odd twice (Faces are neither)[/color]\n\n"
	if rules_active[3] == 1:
		if rule4(slot_card,played_card):
			rules_text += "Cards cannot be within 2 of previous rank\n\n"
		else:
			rules_text += "[color=red]Cards cannot be within 2 of previous rank[/color]\n\n"
	if rules_active[4] == 1:
		if rule5(slot_card,played_card):
			rules_text += "Cards must be higher, unless placed on face card\n\n"
		else:
			rules_text += "[color=red]Cards must be higher, unless placed on face card[/color]\n\n"
	$"Rules Text".text = rules_text

func check_rules(slot_card,played_card):
	if rules_active[0] == 1 and !rule1(slot_card,played_card):
		return false
	if rules_active[1] == 1 and !rule2(slot_card,played_card):
		return false
	if rules_active[2] == 1 and !rule3(slot_card,played_card):
		return false
	if rules_active[3] == 1 and !rule4(slot_card,played_card):
		return false
	if rules_active[4] == 1 and !rule5(slot_card,played_card):
		return false
	return true

# 1: Cards cannot be the same suit twice
func rule1(slot_card,played_card):
	if slot_card.suit == played_card.suit:
		return false
	return true

# 2: Cards must be within 4 of previous rank
func rule2(slot_card,played_card):
	if (slot_card.rank - played_card.rank) >= -4 and (slot_card.rank - played_card.rank) <= 4:
		return true
	return false

# 3: Cards cannot be even/odd twice (Faces are neither)
func rule3(slot_card,played_card):
	if slot_card.rank >= 11 or played_card.rank >= 11:
		return true
	if slot_card.rank % 2 == played_card.rank % 2:
		return false
	return true

# 4: Cards cannot be within 2 of previous rank
func rule4(slot_card,played_card):
	if (slot_card.rank - played_card.rank) >= -2 and (slot_card.rank - played_card.rank) <= 2:
		return false
	return true

# 5: Cards must be higher, unless placed on face card
func rule5(slot_card,played_card):
	if slot_card.rank >= 11:
		return true
	if slot_card.rank >= played_card.rank:
		return false
	return true
