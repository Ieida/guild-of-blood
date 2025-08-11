class_name StateMachine extends State


## Custom StateMachine properties
@export var props: Dictionary[StringName, Variant]
@export var states: Dictionary[StringName, State]
var active_state: State
var active_state_name: StringName


func _exit_active_state():
	active_state.exit()
	active_state.is_active = false
	active_state = null


func _change_active_state(to: StringName):
	var s: State = states[to]
	if active_state: _exit_active_state()
	active_state = s
	active_state_name = to
	s.is_active = true
	s.enter()
	print("state changed to %s" % to)


#region Custom properties
func gep(prop_name: StringName, default_val: Variant = null) -> Variant:
	return props[prop_name] if props.has(prop_name) else default_val


func sep(prop_name: StringName, val: Variant):
	props[prop_name] = val
#endregion


func exit():
	if active_state: _exit_active_state()


func run(delta: float):
	if not is_active: return
	var actv_prt: int = active_state.priority if active_state else -1000
	for k in states.keys():
		var s: State = states[k]
		if s == active_state: continue
		if s.priority >= actv_prt and s.evaluate():
			_change_active_state(k)
			break
	if active_state: active_state.run(delta)


func run_physics(delta: float):
	if active_state: active_state.run_physics(delta)


func start():
	if not machine: is_active = true
	for s in states.values():
		s.root = root
		s.machine = self
		s.start()
