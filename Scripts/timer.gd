extends Node2D

const BASE_TIME = 10.0

var opponent_time_left
var player_time_left
var running_time = "Opponent"

func _ready() -> void:
	reset_timers()
	Global.timer_manager = self

func _process(delta: float) -> void:
	if Global.round_status == 1:
		if Global.turn == "Opponent":
			opponent_time_left -= delta
			$"Opponent Timer/Timer Foreground".scale.x -= delta / (BASE_TIME * 2)
			$"Opponent Timer/Time Left".text = str(snapped(opponent_time_left,0.01))
			if opponent_time_left <= 0.0:
				Global.round_status = 2
				$"Opponent Timer/Time Left".text = "TIME IS UP"
				Global.round_manager.endround("Player")
		else:
			player_time_left -= delta
			$"Player Timer/Timer Foreground".scale.x -= delta / (BASE_TIME * 2)
			$"Player Timer/Time Left".text = str(snapped(player_time_left,0.01))
			if player_time_left <= 0.0:
				Global.round_status = 2
				$"Player Timer/Time Left".text = "TIME IS UP"
				Global.round_manager.endround("Opponent")
	
func reset_timers():
	player_time_left = BASE_TIME
	opponent_time_left = BASE_TIME
	$"Player Timer/Time Left".text = str(snapped(BASE_TIME,0.01))
	$"Opponent Timer/Time Left".text = str(snapped(BASE_TIME,0.01))
	$"Player Timer/Timer Foreground".scale.x = 0.5
	$"Opponent Timer/Timer Foreground".scale.x = 0.5

func alternate_timers():
	if Global.round_status != 2:
		if Global.round_status == 0:
			Global.round_status = 1
		else:
			if Global.turn == "Player":
				player_time_left += 0.5
				$"Player Timer/Timer Foreground".scale.x += 0.5 / (BASE_TIME * 2)
				$"Player Timer/Time Left".text = str(snapped(player_time_left,0.01))
			else:
				opponent_time_left += 0.5
				$"Opponent Timer/Timer Foreground".scale.x += 0.5 / (BASE_TIME * 2)
				$"Opponent Timer/Time Left".text = str(snapped(opponent_time_left,0.01))
