class_name AnimationStateMachine extends StateMachine

var target_sprite: AnimatedSprite2D;
var frame_signals: Array;

func set_animation(s: String = _current_state) -> bool:
	if frozen:
		return false;
	
	if target_sprite.sprite_frames.has_animation(s):
		target_sprite.play(s)
		return true;
	else:
		Debug.message("cannot play %s because it doesn't exist." % s);
		unfreeze()
		return false;
		
func bind_frame(anim_name: String, frame: int, c: Callable, remove_on_trigger: bool = false) -> void:
	if !frame_signals.has({"animation": anim_name, "frame": frame, "cb": c, "once": remove_on_trigger}):
		frame_signals.append({"animation": anim_name, "frame": frame, "cb": c, "once": remove_on_trigger});
	
func bind_animation_end(anim_name: String, c: Callable, remove_on_trigger: bool = false) -> void:
	if target_sprite.sprite_frames.has_animation(anim_name):
		Debug.err("The animation %s does not exist." % anim_name);
		return;
	if target_sprite.sprite_frames.get_animation_loop(anim_name) == true:
		Debug.err("The animation %s is set to loop, there is no animation end." % anim_name);
		return;
		
	var frame: int = target_sprite.sprite_frames.get_frame_count(anim_name) - 1;
	if !frame_signals.has({"animation": anim_name, "frame": frame, "cb": c, "once": remove_on_trigger}):
		frame_signals.append({"animation": anim_name, "frame": frame, "cb": c, "once": remove_on_trigger});

func _init(animated_sprite: AnimatedSprite2D) -> void:
	target_sprite = animated_sprite;
	states = target_sprite.sprite_frames.get_animation_names();
	state_entered.connect(set_animation)
	
	target_sprite.frame_changed.connect(_on_frame_change)
	
func _on_frame_change() -> void:
	for e: Variant in frame_signals:
		if e.animation == target_sprite.animation && target_sprite.frame == e.frame:
			e.cb.call();
			if e.once:
				frame_signals.erase(e)
