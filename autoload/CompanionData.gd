## ============================================================================
## COMPANION DATA SYSTEM - Persistent Character State Management
## ============================================================================
## Manages the entire companion state: personality, appearance, memory,
## emotional condition, history, and transformative alterations.
## Single source of truth for all companion data.
## ============================================================================

extends Node
class_name CompanionData

# Reference to the actual companion data dictionary
var companion: Dictionary = {}
var is_loaded: bool = false

# ============================================================================
## COMPANION STATE SCHEMA - Complete Structure
## ============================================================================

const COMPANION_STATE_SCHEMA = {
	# === IDENTIFICATION & GENERATION ===
	"id": "",
	"generation_seed": 0,
	"generation_timestamp": 0,
	"creation_date": "",
	"name": "",
	"age": 0,
	
	# === VISUAL PARAMETERS ===
	"visual": {
		"height": 0,
		"frame_type": "",
		"skin_tone": 0.0,
		"skin_saturation": 0.0,
		"skin_smoothness": 0.0,
		"freckle_coverage": 0.0,
		"beauty_marks": 0,
		"eye_color_hue": 0.0,
		"eye_shape": "",
		"eye_size": 0.0,
		"eye_expression_potential": 0.0,
		"hair_length": 0,
		"hair_color_hue": 0.0,
		"hair_texture": "",
		"hair_shine": 0.0,
		"facial_structure": "",
		"lip_fullness": 0.0,
		"cheekbone_prominence": 0.0,
		"jaw_softness": 0.0,
		"bust_size": 0.0,
		"hip_width": 0.0,
	},
	
	# === PERSONALITY TRAITS (Big Five Extended) ===
	"personality": {
		"openness": 0.0,
		"conscientiousness": 0.0,
		"extraversion": 0.0,
		"agreeableness": 0.0,
		"neuroticism": 0.0,
		"resilience": 0.0,
		"dominance": 0.0,
		"trust_capacity": 0.0,
		"idealism": 0.0,
		"pragmatism": 0.0,
	},
	
	# === BACKSTORY & PSYCHOLOGICAL FOUNDATION ===
	"backstory": {},
	"psychological_profile": {},
	"trauma": {},
	"life_events": [],
	
	# === EMOTIONAL STATE VECTORS ===
	"emotions": {
		"fear": 0.0,
		"despair": 0.0,
		"attachment": 0.0,
		"defiance": 0.0,
		"submission": 0.0,
		"intensity": 0.0,
		"satisfaction": 0.0,
		"shame": 0.0,
		"hope": 0.0,
		"autonomy": 0.0,
	},
	
	# === CURRENT CONDITION & INTEGRITY SYSTEM ===
	"condition": {
		"psychological_integrity": 1.0,
		"emotional_stability": 1.0,
		"sense_of_self": 1.0,
		"trust_in_player": 0.0,
		"mental_fatigue": 0.0,
		"emotional_overwhelm": 0.0,
		"trauma_activation_level": 0.0,
		"dissociation_level": 0.0,
		"submission_level": 0.0,
		"can_communicate": true,
		"can_engage_intimacy": true,
		"can_make_decisions": true,
		"is_present": true,
		"physical_state": 1.0,
		"sleep_quality": 0.7,
		"stress_level": 0.5,
		"general_wellbeing": 0.7,
	},
	
	# === ALTERATION & TRANSFORMATION LEVELS ===
	"alterations": {
		"corruption_level": 0.0,
		"compliance_level": 0.0,
		"conditioning_depth": 0.0,
		"trauma_depth": 0.0,
		"dissociation_depth": 0.0,
		"identity_dissolution": 0.0,
	},
	
	# === RESPONSE MODIFIERS ===
	"response_modifiers": {
		"verbal_responsiveness": 1.0,
		"physical_responsiveness": 1.0,
		"emotional_reactivity": 1.0,
		"resistance_to_suggestion": 1.0,
		"recovery_speed": 1.0,
		"dopamine_sensitivity": 1.0,
		"pain_sensitivity": 1.0,
		"pleasure_sensitivity": 1.0,
	},
	
	# === MEMORY SYSTEM ===
	"memory": {
		"total_interactions": 0,
		"memory_entries": [],
		"relationship_memory": {},
		"conditional_triggers": {},
		"behavioral_patterns": {},
	},
	
	# === ATTACHMENT & BONDING ===
	"attachment": {
		"attachment_score": 0.0,
		"dependency_level": 0.0,
		"loyalty_level": 0.0,
		"emotional_entanglement": 0.0,
		"bonding_events": [],
	},
	
	# === PERSISTENT BEHAVIOR FLAGS ===
	"behaviors": {
		"acquired_preferences": [],
		"learned_responses": [],
		"conditioned_reactions": [],
		"trauma_responses": [],
		"coping_mechanisms": [],
	},
	
	# === SESSION DATA ===
	"current_session": {
		"session_start_time": 0,
		"last_interaction_time": 0,
		"current_activity": "",
		"current_emotional_state": {},
		"physical_location": "",
	},
	
	# === TERMINAL EVENT FLAGS ===
	"terminal_events": {
		"has_departed": false,
		"departure_reason": "",
		"departure_timestamp": 0,
	},
}

# ============================================================================
## INITIALIZATION & LOADING
## ============================================================================

func _ready():
	add_to_group("autoload")

func initialize_new_companion() -> void:
	"""Create a new companion from procedural generation."""
	var generator = CompanionGenerator.new()
	var generated = generator.generate_new_companion()
	
	companion = COMPANION_STATE_SCHEMA.duplicate(true)
	
	companion["id"] = str(randi())
	companion["generation_seed"] = generated["generation_seed"]
	companion["generation_timestamp"] = generated["generation_timestamp"]
	companion["creation_date"] = Time.get_datetime_string_from_system()
	companion["name"] = generated["name"]
	companion["age"] = generated["age"]
	
	companion["visual"] = generated["visual_parameters"]
	companion["personality"] = generated["personality_traits"]
	companion["backstory"] = generated["backstory"]
	companion["psychological_profile"] = generated["psychological_profile"]
	companion["trauma"] = generated["core_trauma"]
	companion["life_events"] = generated["life_events"]
	
	_initialize_emotional_state()
	
	is_loaded = true
	print("[CompanionData] New companion created: %s (Age %d)" % [companion["name"], companion["age"]])

func load_companion_from_file(path: String = "user://companion_state.json") -> bool:
	"""Load companion data from persistent JSON file."""
	if not ResourceLoader.exists(path):
		push_error("Companion state file not found: %s" % path)
		return false
	
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open companion state file")
		return false
	
	var json_string = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	
	if error != OK:
		push_error("Failed to parse companion JSON: ", error)
		return false
	
	companion = json.data
	is_loaded = true
	
	print("[CompanionData] Loaded companion: %s (Age %d)" % [companion["name"], companion["age"]])
	return true

func _initialize_emotional_state() -> void:
	"""Set initial emotional state based on psychology."""
	companion["emotions"]["fear"] = companion["personality"]["neuroticism"] * 0.4
	companion["emotions"]["despair"] = companion["personality"]["neuroticism"] * 0.3
	companion["emotions"]["hope"] = companion["personality"]["resilience"] * 0.6
	companion["emotions"]["attachment"] = companion["personality"]["trust_capacity"] * 0.2
	companion["emotions"]["defiance"] = companion["personality"]["dominance"] * 0.5

# ============================================================================
## MEMORY SYSTEM
## ============================================================================

func add_memory_entry(event_type: String, description: String, emotional_impact: Dictionary, 
					  gameplay_impact: float = 0.5) -> void:
	"""Add a significant event to memory with impact tracking."""
	
	var memory_entry = {
		"timestamp": Time.get_ticks_msec(),
		"type": event_type,
		"description": description,
		"emotional_impact": emotional_impact,
		"gameplay_impact": gameplay_impact,
		"integrated": false,
		"recall_frequency": 0,
		"influence_on_behavior": [],
	}
	
	companion["memory"]["memory_entries"].append(memory_entry)
	companion["memory"]["total_interactions"] += 1
	
	_integrate_emotional_impact(emotional_impact)
	
	if gameplay_impact > 0.7:
		_create_behavioral_trigger(event_type, description, emotional_impact)

func _integrate_emotional_impact(impact: Dictionary) -> void:
	"""Apply emotional impact to current state."""
	for emotion in impact.keys():
		if emotion in companion["emotions"]:
			companion["emotions"][emotion] += impact[emotion]
			companion["emotions"][emotion] = clamp(companion["emotions"][emotion], 0.0, 1.0)

func _create_behavioral_trigger(event_type: String, description: String, impact: Dictionary) -> void:
	"""Create lasting behavioral changes from significant events."""
	var trigger = {
		"type": event_type,
		"description": description,
		"activation_condition": "",
		"response_behavior": [],
		"strength": 0.0,
	}
	companion["behaviors"]["conditioned_reactions"].append(trigger)

# ============================================================================
## PERSONALITY DRIFT & TRANSFORMATION
## ============================================================================

func apply_personality_drift(drift_vector: Dictionary, intensity: float = 0.1) -> void:
	"""Apply gradual personality change through accumulated experience."""
	
	for trait in drift_vector.keys():
		if trait in companion["personality"]:
			var drift_amount = drift_vector[trait] * intensity
			companion["personality"][trait] += drift_amount
			companion["personality"][trait] = clamp(companion["personality"][trait], 0.0, 1.0)
	
	var total_drift = drift_vector.values().reduce(func(a, b): return abs(a) + abs(b), 0.0)
	if total_drift > 0.3:
		companion["alterations"]["corruption_level"] += intensity * 0.05

func apply_conditioning(conditioning_type: String, strength: float) -> void:
	"""Apply psychological conditioning with lasting effects."""
	
	var conditioning_effect = {
		"type": conditioning_type,
		"strength": strength,
		"applied_timestamp": Time.get_ticks_msec(),
		"permanent_effect": true,
	}
	
	companion["behaviors"]["learned_responses"].append(conditioning_effect)
	companion["alterations"]["conditioning_depth"] = min(1.0, 
		companion["alterations"]["conditioning_depth"] + strength * 0.1)

# ============================================================================
## CONDITION STATE MANAGEMENT
## ============================================================================

func update_psychological_integrity(delta: float) -> void:
	"""Update the companion's psychological integrity."""
	
	var integrity_drain = 0.0
	
	integrity_drain += companion["condition"]["trauma_activation_level"] * 0.001
	integrity_drain += pow(companion["condition"]["emotional_overwhelm"], 2) * 0.0005
	
	companion["condition"]["sense_of_self"] = lerp(
		companion["condition"]["sense_of_self"],
		1.0 - companion["condition"]["dissociation_level"],
		delta * 0.1
	)
	
	var recovery_bonus = companion["personality"]["resilience"] * 0.0002
	
	companion["condition"]["psychological_integrity"] = clamp(
		companion["condition"]["psychological_integrity"] - integrity_drain + recovery_bonus,
		0.0,
		1.0
	)
	
	_update_functional_status()

func _update_functional_status() -> void:
	"""Update what the companion is capable of."""
	
	var integrity = companion["condition"]["psychological_integrity"]
	var overwhelm = companion["condition"]["emotional_overwhelm"]
	
	companion["condition"]["can_communicate"] = (
		integrity > 0.3 and overwhelm < 0.8 and 
		companion["condition"]["dissociation_level"] < 0.7
	)
	
	companion["condition"]["can_engage_intimacy"] = (
		integrity > 0.4 and overwhelm < 0.7 and
		companion["condition"]["dissociation_level"] < 0.5 and
		companion["condition"]["trauma_activation_level"] < 0.6
	)
	
	companion["condition"]["can_make_decisions"] = (
		integrity > 0.5 and companion["alterations"]["compliance_level"] < 0.7
	)
	
	companion["condition"]["is_present"] = (
		companion["condition"]["dissociation_level"] < 0.8
	)

# ============================================================================
## ATTACHMENT & BONDING
## ============================================================================

func update_attachment_to_player(delta: float, interaction_quality: float) -> void:
	"""Update attachment score based on interactions."""
	
	var attachment_growth = interaction_quality * 0.01
	
	attachment_growth *= (1.0 + companion["personality"]["neuroticism"] * 0.5)
	attachment_growth *= (1.0 - companion["personality"]["resilience"] * 0.3)
	
	companion["attachment"]["attachment_score"] += attachment_growth
	companion["attachment"]["attachment_score"] = clamp(companion["attachment"]["attachment_score"], 0.0, 1.0)
	
	companion["attachment"]["dependency_level"] = lerp(
		companion["attachment"]["dependency_level"],
		companion["attachment"]["attachment_score"] * companion["personality"]["neuroticism"],
		delta * 0.05
	)
	
	if interaction_quality > 0.7:
		companion["attachment"]["loyalty_level"] += interaction_quality * 0.005

# ============================================================================
## TERMINAL EVENT SYSTEM
## ============================================================================

func mark_terminal_event(reason: String) -> void:
	"""Mark companion as experiencing terminal event."""
	
	companion["terminal_events"]["has_departed"] = true
	companion["terminal_events"]["departure_reason"] = reason
	companion["terminal_events"]["departure_timestamp"] = Time.get_ticks_msec()
	
	print("[CompanionData] TERMINAL EVENT: %s has departed. Reason: %s" % [
		companion["name"], reason
	])

func has_terminal_event() -> bool:
	return companion["terminal_events"]["has_departed"]

func get_terminal_reason() -> String:
	return companion["terminal_events"]["departure_reason"]

# ============================================================================
## UTILITY METHODS
## ============================================================================

func get_companion_name() -> String:
	return companion["name"]

func get_emotional_state() -> Dictionary:
	return companion["emotions"].duplicate()

func get_current_condition() -> Dictionary:
	return companion["condition"].duplicate()

func get_personality_profile() -> Dictionary:
	return companion["personality"].duplicate()

func to_json_string() -> String:
	"""Export companion data as JSON string."""
	var json = JSON.new()
	return json.stringify(companion)

func clone_companion() -> Dictionary:
	"""Create a deep copy of companion data."""
	return companion.duplicate(true)
