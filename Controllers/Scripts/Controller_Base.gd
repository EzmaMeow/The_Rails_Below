#This acts as the middleman between user input or ai and the character
#As a resource, it can be assign at editor level and will work as long
#as a handler and a character used the same reource instance
class_name Controller_Base extends Resource

signal client_message_received(message:Variant)
signal handler_message_received(message:Variant)

func send_clients_message(message:Variant):
	client_message_received.emit(message)
	
func send_handler_message(message:Variant):
	handler_message_received.emit(message)
#when ever the controller is done being set up,
#this should be called. could also be called
