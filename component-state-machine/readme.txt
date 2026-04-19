Base implementation of the State design pattern with a Finite State Machine with a component-based approach and States represented as Nodes.

Setup:
	- Attach "StateMachine.tscn" to the node you wish to control.
	- Assign the parent node to the controlled_object variable in the inspector.
	- Implement the different states of the object according to your needs, inheriting from the State class defined in "state.gd" (which also contains comments explaining the two main methods of the State class).
	- Create a node for each state as a child of the StateMachine.
	- Assign each state to their variables in the inspector for each State node.
	- Assign the initial state node to the initial_state variable of the StateMachine in the inspector.

Freely available in https://github.com/GravityI/godot-component-sandbox/tree/main/component-state-machine
