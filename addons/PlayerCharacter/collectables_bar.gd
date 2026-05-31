extends Control

@onready var collection_component = $"../../CollectionComponent"
@onready var money_label = $MoneyLabel
@onready var gem_label = $GemLabel

func update_moneys():
	money_label.text = "Moneys: " + str(PlayerData.moneys)

func update_gems():
	gem_label.text = "Gems: " + str(PlayerData.gems)
