extends Node2D

const BASE_TIME = 10.0

var opponent_time_left
var player_time_left
var paused = true
var running_time = "Opponent"
var time_up = false

func _ready() -> void:
	reset_timers()

func _process(delta: float) -> void:
	if !paused:
		if running_time == "Opponent":
			opponent_time_left -= delta
			$"Opponent Timer/Timer Foreground".scale.x -= delta / (BASE_TIME * 2)
			$"Opponent Timer/Time Left".text = str(snapped(opponent_time_left,0.01))
			if opponent_time_left <= 0.0:
				paused = true
				$"Opponent Timer/Time Left".text = "TIME IS UP"
				time_up = true
				$"../Input Manager".time_up = true
				$"../Round Manager".endround("Player")
		else:
			player_time_left -= delta
			$"Player Timer/Timer Foreground".scale.x -= delta / (BASE_TIME * 2)
			$"Player Timer/Time Left".text = str(snapped(player_time_left,0.01))
			if player_time_left <= 0.0:
				paused = true
				$"Player Timer/Time Left".text = "TIME IS UP"
				time_up = true
				$"../Input Manager".time_up = true
				$"../Round Manager".endround("Opponent")
	
func reset_timers():
	player_time_left = BASE_TIME
	opponent_time_left = BASE_TIME
	running_time = "Opponent"
	$"Player Timer/Time Left".text = str(snapped(BASE_TIME,0.01))
	$"Opponent Timer/Time Left".text = str(snapped(BASE_TIME,0.01))
	$"Player Timer/Timer Foreground".scale.x = 0.5
	$"Opponent Timer/Timer Foreground".scale.x = 0.5
	paused = true
	time_up = false
	$"../Input Manager".time_up = false

func alternate_timers():
	if !time_up:
		if paused == true:
			paused = false
		else:
			if running_time == "Player":
				player_time_left += 0.5
				$"Player Timer/Timer Foreground".scale.x += 0.5 / (BASE_TIME * 2)
				$"Player Timer/Time Left".text = str(snapped(player_time_left,0.01))
				running_time = "Opponent"
			else:
				opponent_time_left += 0.5
				$"Opponent Timer/Timer Foreground".scale.x += 0.5 / (BASE_TIME * 2)
				$"Opponent Timer/Time Left".text = str(snapped(opponent_time_left,0.01))
				running_time = "Player"

func round_over():
	time_up = true
	paused = true
	$"../Input Manager".time_up = true
