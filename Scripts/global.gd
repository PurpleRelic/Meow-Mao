extends Node

var turn = "Player"
var round_status = 0 # 0 is start of round, 1 is during round, 2 is after round
var difficulty = 2 # 1 is easy, 2 is medium, 3 is hard

var input_manager
var card_manager
var card_slot
var player_hand
var opponent_hand
var deck
var timer_manager
var opponent_ai
var rule_manager
var round_manager
