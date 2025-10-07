# The_Rails_Below

This is a test project that may develop into a game. 

The current game plan is something like a trade simulation using an underground 
rail system in a world where a war render the surface unsafe for human.

Note on current file structure:
	-Assets: contains any shared art, sound, ot meshes.
	-Core: The files related to run and handle the game
	-Any other named folder are for independent systems that the game may used
The file structure could chang, but I may try to keep it like this to allow
more independent systems to be designed. Note that sometimes scenes may be located
in core instead of their related group, but this should only for scenes that depend
on other custom systems.

TODO: Maybe reimport the tunnel meshes with uv mapping that have padding around 
the islands so there is no bleeding if sampling.
