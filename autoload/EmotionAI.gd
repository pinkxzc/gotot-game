## ============================================================================
## EMOTION AI SYSTEM - Advanced Psychological & Behavioral Modeling
## ============================================================================
## Sophisticated emotional state machine with complex behavioral logic,
## state transitions, psychological consistency, and dynamic response generation.
## ============================================================================

extends Node
class_name EmotionAI

# Emotional state influence coefficients (tunable parameters)
const EMOTION_COEFFICIENTS = {
	"fear": {
		"avoidance_multiplier": 2.5,
		"trust_reduction": 0.8,
		"emotional_reactivity": 1.8,
		"submission_tendency": 0.6,
	},
	"despair": {
		"passivity_multiplier": 3.0,
		"resistance_reduction": 0.3,
		"compliance_increase": 0.9,
		"hope_negation": 0.1,
	},
	"attachment": {
		"dependence_multiplier": 2.0,
		"cooperation_bonus": 0.8,
		"loyalty_increase": 0.7,
		"autonomy_reduction": 0.5,
	},
	"defiance": {
		"resistance_multiplier": 2.2,
		"compliance_reduction": 0.4,
		"conflict_tendency": 1.5,
		"submission_negation": 0.2,
	},
	"submission": {
		"compliance_multiplier": 2.5,
		"autonomy_loss": 0.9,
		"self_assertion_reduction": 0.3,
		"influence_receptivity": 2.0,
	},
	"intensity": {
		"reaction_speed": 2.0,
		"emotional_amplitude": 1.5,
		"recovery_time": 0.6,
	},
	"shame": {
		"social_withdrawal": 1.8,
		"self_criticism": 2.0,
		"performance_degradation": 1.5,
		"trust_reduction": 0.7,
	},
}

# Behavioral state machine
enum BEHAVIORAL_STATE {
	BASELINE,        # Normal, stable
	RECEPTIVE,       # Open, trusting
	RESISTANT,       # Defensive, opposing
	OVERWHELMED,     # Too much input, shutting down
	TRAUMATIZED,     # Active trauma response
	DISSOCIATED,     # Present physically, absent mentally
	COMPLIANT,       # Accepting suggestions without resistance
	TRANSCENDENT,    # Peak experience of connection/intensity
}

# Current behavioral state
var current_behavioral_state: int = BEHAVIORAL_STATE.BASELINE

# ============================================================================
## EMOTIONAL UPDATE LOOP - Core Simulation
## ============================================================================

func _process(delta: float) -> void:
	if not CompanionData.is_loaded:
		return
	
	_update_emotional_vectors(delta)
	_update_behavioral_state(delta)
	_evaluate_behavioral_triggers(delta)
	_apply_personality_influence(delta)

func _update_emotional_vectors(delta: float) -> void:
	"""
	Core emotional update with decay, influence, and cross-emotional interactions.
	Implements sophisticated mathematical formulas for emotional dynamics.
	"""
	
	var emotions = CompanionData.companion["emotions"]
	var personality = CompanionData.companion["personality"]
	var condition = CompanionData.companion["condition"]
	
	# === FEAR DYNAMICS ===
	var fear_baseline = personality["neuroticism"] * 0.3
	var fear_decay = 0.98
	
	if condition["trauma_activation_level"] > 0.3:
		fear_decay = lerp(fear_decay, 0.85, condition["trauma_activation_level"])
	
	emotions["fear"] = emotions["fear"] * fear_decay + fear_baseline * delta
	
	# === DESPAIR DYNAMICS ===
	var satisfaction_ratio = max(0.0, emotions["satisfaction"] - 0.5)
	var despair_growth = max(0.0, 0.3 - satisfaction_ratio) * delta * 0.1
	
	emotions["despair"] = min(1.0, emotions["despair"] + despair_growth)
	
	var despair_relief = (personality["resilience"] + emotions["hope"]) * 0.05 * delta
	emotions["despair"] = max(0.0, emotions["despair"] - despair_relief)
	
	# === ATTACHMENT DYNAMICS ===
	if personality["trust_capacity"] > 0.6 and condition["trust_in_player"] > 0.5:
		emotions["attachment"] += 0.01 * delta
	
	if condition["trauma_activation_level"] > 0.5:
		emotions["attachment"] *= 0.95
	
	emotions["attachment"] = clamp(emotions["attachment"], 0.0, 1.0)
	
	# === DEFIANCE DYNAMICS ===
	var autonomy_threat = max(0.0, condition["submission_level"] - personality["need_for_autonomy"])
	emotions["defiance"] = lerp(emotions["defiance"], 
		emotions["defiance"] + autonomy_threat * 0.2, delta * 0.1)
	
	emotions["defiance"] *= (1.0 - condition["submission_level"] * 0.05)
	emotions["defiance"] = clamp(emotions["defiance"], 0.0, 1.0)
	
	# === SUBMISSION DYNAMICS ===
	var confidence = min(1.0, 1.0 - personality["neuroticism"])
	var submission_pressure = (1.0 - confidence) * 0.1
	
	emotions["submission"] += submission_pressure * delta
	emotions["submission"] *= 0.99
	emotions["submission"] = clamp(emotions["submission"], 0.0, 1.0)
	
	# === INTENSITY DYNAMICS ===
	var total_emotion_magnitude = (
		abs(emotions["fear"]) +
		abs(emotions["defiance"]) +
		abs(emotions["submission"]) +
		abs(emotions["shame"])
	) / 4.0
	
	emotions["intensity"] = lerp(emotions["intensity"], total_emotion_magnitude, delta * 0.2)
	
	# === SHAME DYNAMICS ===
	if condition["psychological_integrity"] < 0.5:
		emotions["shame"] += 0.05 * delta
	
	emotions["shame"] *= 0.98
	emotions["shame"] = clamp(emotions["shame"], 0.0, 1.0)
	
	# === HOPE DYNAMICS ===
	var hope_baseline = personality["resilience"] * 0.4
	emotions["hope"] = lerp(emotions["hope"], hope_baseline, delta * 0.05)
	
	emotions["hope"] *= (1.0 - emotions["despair"] * 0.1)
	emotions["hope"] = clamp(emotions["hope"], 0.0, 1.0)
	
	# === AUTONOMY DYNAMICS ===
	emotions["autonomy"] = 1.0 - condition["submission_level"]
	emotions["autonomy"] *= (1.0 - condition["dissociation_level"])
	emotions["autonomy"] = clamp(emotions["autonomy"], 0.0, 1.0)

# ============================================================================
## BEHAVIORAL STATE MACHINE
## ============================================================================

func _update_behavioral_state(delta: float) -> void:
	"""
	Determine current behavioral state based on emotional vectors.
	State determines response types and interaction possibilities.
	"""
	
	var emotions = CompanionData.companion["emotions"]
	var condition = CompanionData.companion["condition"]
	var personality = CompanionData.companion["personality"]
	
	var new_state = current_behavioral_state
	
	# === TRAUMA STATE (highest priority) ===
	if condition["trauma_activation_level"] > 0.7:
		new_state = BEHAVIORAL_STATE.TRAUMATIZED
	
	# === DISSOCIATED STATE ===
	elif condition["dissociation_level"] > 0.6:
		new_state = BEHAVIORAL_STATE.DISSOCIATED
	
	# === OVERWHELMED STATE ===
	elif condition["emotional_overwhelm"] > 0.8 or emotions["intensity"] > 0.85:
		new_state = BEHAVIORAL_STATE.OVERWHELMED
	
	# === COMPLIANT STATE ===
	elif condition["compliance_level"] > 0.6 and emotions["defiance"] < 0.3:
		new_state = BEHAVIORAL_STATE.COMPLIANT
	
	# === RESISTANT STATE ===
	elif emotions["defiance"] > 0.6 or condition["submission_level"] < 0.2:
		new_state = BEHAVIORAL_STATE.RESISTANT
	
	# === RECEPTIVE STATE ===
	elif condition["trust_in_player"] > 0.6 and emotions["attachment"] > 0.5:
		new_state = BEHAVIORAL_STATE.RECEPTIVE
	
	# === TRANSCENDENT STATE ===
	elif (emotions["attachment"] > 0.8 and emotions["satisfaction"] > 0.7 and
		  condition["trust_in_player"] > 0.8 and emotions["intensity"] > 0.6):
		new_state = BEHAVIORAL_STATE.TRANSCENDENT
	
	# === DEFAULT BASELINE ===
	else:
		new_state = BEHAVIORAL_STATE.BASELINE
	
	current_behavioral_state = new_state

func get_current_behavioral_state() -> String:
	"""Get human-readable current behavioral state."""
	return BEHAVIORAL_STATE.keys()[current_behavioral_state]

func get_behavioral_state_description() -> String:
	"""Get detailed description of current behavioral state."""
	match current_behavioral_state:
		BEHAVIORAL_STATE.BASELINE:
			return "Calm and neutral, open to interaction"
		BEHAVIORAL_STATE.RECEPTIVE:
			return "Trusting and engaged, highly responsive"
		BEHAVIORAL_STATE.RESISTANT:
			return "Defensive and opposed, resistant to influence"
		BEHAVIORAL_STATE.OVERWHELMED:
			return "Emotionally flooded, struggling to process"
		BEHAVIORAL_STATE.TRAUMATIZED:
			return "Active trauma response, in crisis"
		BEHAVIORAL_STATE.DISSOCIATED:
			return "Mentally absent, present only in body"
		BEHAVIORAL_STATE.COMPLIANT:
			return "Accepting without resistance, cooperative"
		BEHAVIORAL_STATE.TRANSCENDENT:
			return "Peak emotional connection, transcendent state"
	return "Unknown state"

# ============================================================================
## BEHAVIORAL TRIGGER EVALUATION
## ============================================================================

func _evaluate_behavioral_triggers(delta: float) -> void:
	"""
	Evaluate conditional triggers that cause automatic behavioral responses.
	Triggers are created from significant past events.
	"""
	
	var behaviors = CompanionData.companion["behaviors"]
	var condition = CompanionData.companion["condition"]
	
	for trigger in behaviors["conditioned_reactions"]:
		if _should_trigger_activate(trigger):
			_activate_conditioned_response(trigger)

func _should_trigger_activate(trigger: Dictionary) -> bool:
	"""Determine if a trigger should activate based on current state."""
	var condition = CompanionData.companion["condition"]
	var emotions = CompanionData.companion["emotions"]
	
	return condition["trauma_activation_level"] > 0.5 or condition["emotional_overwhelm"] > 0.6

func _activate_conditioned_response(trigger: Dictionary) -> void:
	"""Execute a conditioned behavioral response."""
	var condition = CompanionData.companion["condition"]
	
	for response in trigger["response_behavior"]:
		match response:
			"withdraw":
				condition["dissociation_level"] += 0.1
			"comply":
				condition["compliance_level"] += 0.15
			"defend":
				CompanionData.companion["emotions"]["defiance"] += 0.2

# ============================================================================
## PERSONALITY INFLUENCE ON EMOTIONAL DYNAMICS
## ============================================================================

func _apply_personality_influence(delta: float) -> void:
	"""
	Apply personality traits to emotional dynamics.
	Personality permanently shapes how emotions develop and respond.
	"""
	
	var emotions = CompanionData.companion["emotions"]
	var personality = CompanionData.companion["personality"]
	var alterations = CompanionData.companion["alterations"]
	
	emotions["fear"] += personality["neuroticism"] * 0.001 * delta
	emotions["despair"] += personality["neuroticism"] * 0.0005 * delta
	emotions["shame"] += personality["neuroticism"] * 0.0005 * delta
	
	var resilience_buffer = personality["resilience"] * 0.002
	emotions["despair"] -= resilience_buffer * delta
	emotions["fear"] -= resilience_buffer * delta * 0.5
	
	emotions["attachment"] += personality["agreeableness"] * 0.001 * delta
	
	var autonomy_pressure = personality["dominance"] * 0.005
	emotions["defiance"] += autonomy_pressure * delta
	emotions["submission"] -= autonomy_pressure * delta * 0.3
	
	emotions["despair"] += alterations["corruption_level"] * 0.0005 * delta
	emotions["shame"] += alterations["corruption_level"] * 0.0003 * delta

# ============================================================================
## DYNAMIC RESPONSE GENERATION
## ============================================================================

func generate_response_to_interaction(interaction_type: String, intensity: float = 0.5) -> Dictionary:
	"""
	Generate appropriate behavioral response based on current emotional state.
	Response varies based on behavioral state, personality, and condition.
	"""
	
	var response = {
		"facial_expression": "",
		"body_language": "",
		"verbal_response": "",
		"emotional_change": {},
		"behavior_modification": "",
		"animation_request": "",
		"visual_feedback": [],
		"intensity_actual": 0.0,
	}
	
	match current_behavioral_state:
		BEHAVIORAL_STATE.BASELINE:
			response = _generate_baseline_response(interaction_type, intensity)
		BEHAVIORAL_STATE.RECEPTIVE:
			response = _generate_receptive_response(interaction_type, intensity)
		BEHAVIORAL_STATE.RESISTANT:
			response = _generate_resistant_response(interaction_type, intensity)
		BEHAVIORAL_STATE.OVERWHELMED:
			response = _generate_overwhelmed_response(interaction_type, intensity)
		BEHAVIORAL_STATE.TRAUMATIZED:
			response = _generate_traumatized_response(interaction_type, intensity)
		BEHAVIORAL_STATE.DISSOCIATED:
			response = _generate_dissociated_response(interaction_type, intensity)
		BEHAVIORAL_STATE.COMPLIANT:
			response = _generate_compliant_response(interaction_type, intensity)
		BEHAVIORAL_STATE.TRANSCENDENT:
			response = _generate_transcendent_response(interaction_type, intensity)
	
	return response

func _generate_baseline_response(interaction_type: String, intensity: float) -> Dictionary:
	"""Generate response from neutral emotional state."""
	var emotions = CompanionData.companion["emotions"]
	
	var response = {
		"facial_expression": "neutral_interest",
		"body_language": "open_relaxed",
		"verbal_response": "That's... nice. What would you like to do?",
		"emotional_change": {
			"attachment": intensity * 0.05,
			"satisfaction": intensity * 0.1,
		},
		"animation_request": "idle_breathing",
		"intensity_actual": intensity * 0.6,
	}
	
	if interaction_type == "affectionate":
		response["facial_expression"] = "subtle_smile"
		response["body_language"] = "slight_lean_forward"
		response["verbal_response"] = "That feels... good."
		response["emotional_change"]["attachment"] = intensity * 0.15
	
	return response

func _generate_receptive_response(interaction_type: String, intensity: float) -> Dictionary:
	"""Generate response from trusting, engaged state."""
	var response = {
		"facial_expression": "warm_smile",
		"body_language": "open_engaged",
		"verbal_response": "Yes... I want this.",
		"emotional_change": {
			"attachment": intensity * 0.25,
			"satisfaction": intensity * 0.3,
		},
		"animation_request": "lean_into_player",
		"intensity_actual": intensity * 0.9,
	}
	
	if interaction_type == "intimate":
		response["emotional_change"]["intensity"] = intensity * 0.4
		response["animation_request"] = "intimate_responsiveness"
	
	return response

func _generate_resistant_response(interaction_type: String, intensity: float) -> Dictionary:
	"""Generate response from defensive state."""
	var response = {
		"facial_expression": "guarded_uncertain",
		"body_language": "withdraw_defensive",
		"verbal_response": "I'm not sure about this...",
		"emotional_change": {
			"defiance": intensity * 0.2,
			"fear": intensity * 0.1,
		},
		"animation_request": "step_back",
		"intensity_actual": intensity * 0.3,
	}
	
	return response

func _generate_overwhelmed_response(interaction_type: String, intensity: float) -> Dictionary:
	"""Generate response from emotionally flooded state."""
	var response = {
		"facial_expression": "distressed_overwhelmed",
		"body_language": "curled_defensive",
		"verbal_response": "I... I can't... it's too much...",
		"emotional_change": {
			"fear": intensity * 0.3,
			"despair": intensity * 0.2,
		},
		"animation_request": "breathing_difficulty",
		"intensity_actual": 0.0,
	}
	
	return response

func _generate_traumatized_response(interaction_type: String, intensity: float) -> Dictionary:
	"""Generate response from active trauma state."""
	var response = {
		"facial_expression": "terror_blank",
		"body_language": "freeze_protective",
		"verbal_response": "No... no please... don't...",
		"emotional_change": {
			"fear": 0.5,
			"shame": 0.3,
		},
		"animation_request": "trauma_freeze",
		"intensity_actual": 0.0,
	}
	
	return response

func _generate_dissociated_response(interaction_type: String, intensity: float) -> Dictionary:
	"""Generate response from mentally absent state."""
	var response = {
		"facial_expression": "empty_absent",
		"body_language": "hollow_mechanical",
		"verbal_response": "...",
		"emotional_change": {},
		"animation_request": "dissociated_stare",
		"intensity_actual": 0.0,
	}
	
	return response

func _generate_compliant_response(interaction_type: String, intensity: float) -> Dictionary:
	"""Generate response from compliant state."""
	var response = {
		"facial_expression": "accepting_obedient",
		"body_language": "present_compliant",
		"verbal_response": "Yes... whatever you want.",
		"emotional_change": {
			"submission": intensity * 0.3,
			"compliance": intensity * 0.2,
		},
		"animation_request": "await_instruction",
		"intensity_actual": intensity * 0.7,
	}
	
	return response

func _generate_transcendent_response(interaction_type: String, intensity: float) -> Dictionary:
	"""Generate response from peak emotional connection."""
	var response = {
		"facial_expression": "ecstatic_transcendent",
		"body_language": "fully_present_merged",
		"verbal_response": "Yes... YES... this is... everything...",
		"emotional_change": {
			"satisfaction": intensity * 0.5,
			"intensity": intensity * 0.6,
			"attachment": intensity * 0.3,
		},
		"animation_request": "transcendent_response",
		"intensity_actual": intensity * 1.2,
	}
	
	return response

# ============================================================================
## TRAUMA TRIGGER MANAGEMENT
## ============================================================================

func evaluate_trauma_activation(trigger_type: String, intensity: float = 0.5) -> float:
	"""
	Evaluate if trauma triggers should activate.
	Returns activation level 0.0-1.0.
	"""
	
	var trauma = CompanionData.companion["trauma"]
	var activation_level = 0.0
	
	if trigger_type in trauma["activation_triggers"]:
		activation_level = intensity
		
		var resilience = CompanionData.companion["personality"]["resilience"]
		activation_level *= (1.0 - resilience * 0.5)
	
	return activation_level

func apply_trauma_activation(activation_level: float) -> void:
	"""Apply trauma activation to condition system."""
	var condition = CompanionData.companion["condition"]
	
	condition["trauma_activation_level"] = activation_level
	condition["emotional_overwhelm"] += activation_level * 0.3
	
	condition["psychological_integrity"] -= activation_level * 0.1
