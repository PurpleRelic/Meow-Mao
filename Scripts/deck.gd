extends Node2D

const CARD_PATH = "res://Scenes/Card.tscn"
const DEFAULT_DRAW_SPEED = 0.3

var deck = ["AH","2H","3H","4H","5H","6H","7H","8H","9H","10H","JH","QH","KH",
					"AD","2D","3D","4D","5D","6D","7D","8D","9D","10D","JD","QD","KD",
					"AC","2C","3C","4C","5C","6C","7C","8C","9C","10C","JC","QC","KC",
					"AS","2S","3S","4S","5S","6S","7S","8S","9S","10S","JS","QS","KS"]
var card_database_reference
var player_hand_reference
var opponent_hand_reference

func _ready() -> void:
	$"Cards Left".text = str("Cards Left: " + str(deck.size()) + "\nClick to Reset Hand")
	player_hand_reference = $"../Player Hand"
	opponent_hand_reference = $"../Opponent Hand"
	card_database_reference = preload("res://Scripts/card_database.gd")
	deck.shuffle()
	for i in range(5):
		draw_card("Player")
		draw_card("Opponent")

func reset_hand(turn):
	if turn == "Player":
		player_hand_reference.remove_hand()
	else:
		opponent_hand_reference.remove_hand()
	for i in range(5):
		draw_card(turn)

func reset_deck():
	deck = ["AH","2H","3H","4H","5H","6H","7H","8H","9H","10H","JH","QH","KH",
					"AD","2D","3D","4D","5D","6D","7D","8D","9D","10D","JD","QD","KD",
					"AC","2C","3C","4C","5C","6C","7C","8C","9C","10C","JC","QC","KC",
					"AS","2S","3S","4S","5S","6S","7S","8S","9S","10S","JS","QS","KS"]
	#for i in range(player_hand_reference.player_hand.size()):
	#	deck.erase(player_hand_reference.player_hand[i])
	deck.shuffle()
	$"Cards Left".text = str("Cards Left: " + str(deck.size()) + "\nClick to Reset Hand")
	$Sprite2D.texture = load("res://Images/Card Back.png")

func draw_card(turn):
	if deck.size() == 0:
		reset_deck()
	var card_drawn = deck[0]
	deck.erase(card_drawn)
	
	if deck.size() == 0:
		$Sprite2D.texture = load("res://Images/Grey Card Back.png")
		$"Cards Left".text = "Deck Is Empty\nClick to Refresh"
	else:
		$"Cards Left".text = str("Cards Left: " + str(deck.size()) + "\nClick to Reset Hand")
	var card_scene = preload(CARD_PATH)
	var new_card = card_scene.instantiate()
	new_card.position = self.position
	$"../Card Manager".add_child(new_card)
	$"../Card Manager".change_card_rank(new_card,card_database_reference.CARDS[card_drawn][0])
	$"../Card Manager".change_card_suit(new_card,card_database_reference.CARDS[card_drawn][1])
	new_card.name = "Card"
	if turn == "Player":
		player_hand_reference.add_card_to_hand(new_card,DEFAULT_DRAW_SPEED)
		new_card.get_node("AnimationPlayer").play("Card Flip")
	else:
		opponent_hand_reference.add_card_to_hand(new_card,DEFAULT_DRAW_SPEED)
		new_card.in_opponent = true
