extends Control

@onready var collection_component = $"../../CollectionComponent"
@onready var money_label = $MoneyLabel

func update_moneys():
	money_label.text = "Moneys: " + str(PlayerData.moneys)
