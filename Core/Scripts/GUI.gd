#The UI layer for display info over the game viewport and handle shared
#input logic. 
#NOTE: not all UI may be handle here.
#NOTE: this should run self contain using only what is given to it. It is 
#usally a autoload because of this, but do not nessary need to be if resources
#and objects are used to created indirect connections
extends CanvasLayer
