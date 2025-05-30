extends Node2D

var playerpoints = 0
var opponentpoints = 0

func _ready() -> void:
	Global.round_manager = self

func endround(winner):
	if winner == "Player":
		playerpoints += 1
		$Winner.text = str("Winner of round " + str((playerpoints+opponentpoints)) + " is: Player")
		$Winner.modulate = Color(255,255,255,255)
		match playerpoints:
			1:
				$"PPoint Chip1".visible = true
			2:
				$"PPoint Chip2".visible = true
			3:
				$"PPoint Chip3".visible = true
			_:
				print("Player exceeded 3 points")
	else:
		opponentpoints += 1
		$Winner.text = str("Winner of round " + str((playerpoints+opponentpoints)) + " is: Opponent")
		$Winner.modulate = Color(255,255,255,255)
		match opponentpoints:
			1:
				$"OPoint Chip1".visible = true
			2:
				$"OPoint Chip2".visible = true
			3:
				$"OPoint Chip3".visible = true
			_:
				print("Opponent exceeded 3 points")
	Global.round_status = 2
	if playerpoints >= 3 or opponentpoints >= 3:
		if playerpoints >= 3:
			$Winner.text = "TOTAL WINNER IS: PLAYER"
		else:
			$Winner.text = "TOTAL WINNER IS: OPPONENT"
		$AnimationPlayer.play("RESET")
		$AnimationPlayer.play("Final Winner")
	else:
		newround()

func newround():
	$Button.visible = true
	$Button.disabled = false
	await $Button.pressed
	$Button.visible = false
	$Button.disabled = true
	$Winner.modulate = Color(255,255,255,0)
	Global.opponent_ai.fail_chance = 0.0
	Global.opponent_ai.base_turn_speed += (0.25 / float(Global.difficulty))
	Global.rule_manager.add_rule()
	Global.timer_manager.reset_timers()
	Global.round_status = 0
