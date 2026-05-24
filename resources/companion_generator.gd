## ============================================================================
## COMPANION GENERATOR - Procedural Character Creation System
## ============================================================================
## Generates unique, persistent companions with:
## - Visual parameter vectors (height, frame, facial features, coloration)
## - Personality trait vectors with psychological depth
## - Consistent, emotionally-grounded backstories
## - Generative seed for deterministic recreation
## ============================================================================

extends Resource
class_name CompanionGenerator

# Personality trait definitions (Big Five extended model)
const PERSONALITY_TRAITS = {
	"openness": {"min": 0.0, "max": 1.0, "description": "Curiosity and imagination"},
	"conscientiousness": {"min": 0.0, "max": 1.0, "description": "Organization and discipline"},
	"extraversion": {"min": 0.0, "max": 1.0, "description": "Social engagement"},
	"agreeableness": {"min": 0.0, "max": 1.0, "description": "Empathy and cooperation"},
	"neuroticism": {"min": 0.0, "max": 1.0, "description": "Emotional sensitivity"},
	"resilience": {"min": 0.0, "max": 1.0, "description": "Ability to recover from trauma"},
	"dominance": {"min": 0.0, "max": 1.0, "description": "Preference for control"},
	"trust_capacity": {"min": 0.0, "max": 1.0, "description": "Ability to form bonds"},
	"idealism": {"min": 0.0, "max": 1.0, "description": "Belief in higher values"},
	"pragmatism": {"min": 0.0, "max": 1.0, "description": "Focus on practical solutions"},
}

# Visual parameter ranges
const VISUAL_PARAMETERS = {
	"height": {"min": 155, "max": 185, "unit": "cm"},
	"frame_type": {"options": ["petite", "slender", "athletic", "curvaceous", "statuesque"]},
	"skin_tone": {"min": 0.0, "max": 1.0, "hue_variance": 0.15},
	"eye_color_hue": {"min": 0.0, "max": 1.0},
	"eye_shape": {"options": ["almond", "round", "upturned", "downturned", "hooded"]},
	"hair_length": {"min": 20, "max": 120, "unit": "cm"},
	"hair_color_hue": {"min": 0.0, "max": 1.0},
	"hair_texture": {"options": ["straight", "wavy", "curly", "spiral"]},
	"facial_structure": {"options": ["delicate", "balanced", "angular", "soft", "sharp"]},
	"lip_fullness": {"min": 0.3, "max": 1.0},
	"bust_size": {"min": 0.4, "max": 1.2},
	"hip_width": {"min": 0.7, "max": 1.3},
}

# Backstory archetypes with psychological foundations
const BACKSTORY_ARCHETYPES = [
	{
		"name": "Lost Academic",
		"personality_modifiers": {"openness": 0.8, "conscientiousness": 0.7, "neuroticism": 0.5},
		"trauma_factors": ["isolation", "expectation_failure", "identity_loss"],
		"core_conflict": "Reconciling intellectual identity with emotional needs"
	},
	{
		"name": "Artistic Soul",
		"personality_modifiers": {"openness": 0.9, "conscientiousness": 0.3, "extraversion": 0.6},
		"trauma_factors": ["creative_block", "rejection", "economic_instability"],
		"core_conflict": "Finding purpose in a world that doesn't value art"
	},
	{
		"name": "Corporate Burnout",
		"personality_modifiers": {"conscientiousness": 0.8, "agreeableness": 0.4, "neuroticism": 0.7},
		"trauma_factors": ["exploitation", "dehumanization", "moral_compromise"],
		"core_conflict": "Reclaiming humanity after systematic suppression"
	},
	{
		"name": "Sheltered Idealist",
		"personality_modifiers": {"idealism": 0.8, "trust_capacity": 0.7, "resilience": 0.4},
		"trauma_factors": ["betrayal", "systemic_injustice", "naivety_exposed"],
		"core_conflict": "Maintaining hope after confronting harsh realities"
	},
	{
		"name": "Survivor",
		"personality_modifiers": {"resilience": 0.9, "neuroticism": 0.4, "trust_capacity": 0.3},
		"trauma_factors": ["abandonment", "violence", "systemic_oppression"],
		"core_conflict": "Learning to trust and heal after profound betrayal"
	},
	{
		"name": "Wandering Spirit",
		"personality_modifiers": {"extraversion": 0.8, "openness": 0.8, "conscientiousness": 0.3},
		"trauma_factors": ["rootlessness", "disconnection", "searching"],
		"core_conflict": "Finding belonging without losing freedom"
	},
]

# Detailed life event templates
const LIFE_EVENTS = [
	{
		"type": "formative_relationship",
		"impact_categories": ["trust_capacity", "attachment_style", "emotional_openness"],
		"descriptions": [
			"A close bond that was unexpectedly severed",
			"A mentor who believed in them during darkness",
			"A love that felt transcendent but ultimately unhealthy",
			"A friendship tested and ultimately strengthened",
		]
	},
	{
		"type": "professional_failure",
		"impact_categories": ["resilience", "self_worth", "drive"],
		"descriptions": [
			"Public humiliation and career derailment",
			"Years of work nullified by circumstances beyond control",
			"Realization that their talents were insufficient",
			"Betrayal by those they trusted professionally",
		]
	},
	{
		"type": "personal_discovery",
		"impact_categories": ["identity", "openness", "self_acceptance"],
		"descriptions": [
			"Realization of uncomfortable truths about themselves",
			"Discovery of hidden talent or passion",
			"Coming to terms with their sexuality or gender",
			"Recognition of inherited trauma patterns",
		]
	},
	{
		"type": "systemic_trauma",
		"impact_categories": ["trust_capacity", "resilience", "idealism"],
		"descriptions": [
			"Witnessing or experiencing discrimination",
			"Economic instability and poverty",
			"Healthcare system failure affecting loved ones",
			"Institutional betrayal by trusted authority",
		]
	},
]

# ============================================================================
## GENERATION PIPELINE
## ============================================================================

static func generate_new_companion(seed_override: int = -1) -> Dictionary:
	"""
	Generate a completely unique companion with all parameters.
	Uses seeded randomness for deterministic generation.
	"""
	var seed_value = seed_override if seed_override != -1 else randi()
	seed(seed_value)
	
	var companion = {
		"generation_seed": seed_value,
		"generation_timestamp": Time.get_ticks_msec(),
		
		# Visual identity
		"visual_parameters": _generate_visual_parameters(),
		
		# Personality vector
		"personality_traits": _generate_personality_traits(),
		
		# Psychological foundation
		"backstory": _generate_backstory(),
		"life_events": _generate_life_events(),
		"core_trauma": _identify_core_trauma(),
		"psychological_profile": _create_psychological_profile(),
		
		# Initial state
		"age": randi_range(18, 35),
		"name": _generate_name(),
	}
	
	return companion

# ============================================================================
## VISUAL GENERATION
## ============================================================================

static func _generate_visual_parameters() -> Dictionary:
	"""Generate a coherent set of visual characteristics."""
	var visuals = {}
	
	# Body structure (coherent archetype)
	var frame_type = VISUAL_PARAMETERS["frame_type"]["options"][randi() % VISUAL_PARAMETERS["frame_type"]["options"].size()]
	visuals["frame_type"] = frame_type
	visuals["height"] = randi_range(VISUAL_PARAMETERS["height"]["min"], VISUAL_PARAMETERS["height"]["max"])
	
	# Frame-coherent measurements
	match frame_type:
		"petite":
			visuals["bust_size"] = randf_range(0.4, 0.7)
			visuals["hip_width"] = randf_range(0.7, 0.95)
			visuals["height"] = randi_range(155, 165)
		"slender":
			visuals["bust_size"] = randf_range(0.5, 0.8)
			visuals["hip_width"] = randf_range(0.65, 0.9)
		"athletic":
			visuals["bust_size"] = randf_range(0.65, 0.95)
			visuals["hip_width"] = randf_range(0.8, 1.05)
		"curvaceous":
			visuals["bust_size"] = randf_range(0.85, 1.2)
			visuals["hip_width"] = randf_range(0.95, 1.3)
		"statuesque":
			visuals["bust_size"] = randf_range(0.75, 1.1)
			visuals["hip_width"] = randf_range(0.85, 1.2)
			visuals["height"] = randi_range(172, 185)
	
	# Coloration (harmonized palette)
	var dominant_hue = randf()
	visuals["skin_tone"] = randf_range(0.0, 1.0)
	visuals["skin_saturation"] = randf_range(0.6, 1.0)
	
	# Eye characteristics
	visuals["eye_color_hue"] = dominant_hue + randf_range(-0.1, 0.1)
	visuals["eye_shape"] = VISUAL_PARAMETERS["eye_shape"]["options"][randi() % VISUAL_PARAMETERS["eye_shape"]["options"].size()]
	visuals["eye_size"] = randf_range(0.8, 1.2)
	visuals["eye_expression_potential"] = randf_range(0.5, 1.0)
	
	# Hair characteristics (harmonized with eyes)
	visuals["hair_length"] = randi_range(VISUAL_PARAMETERS["hair_length"]["min"], VISUAL_PARAMETERS["hair_length"]["max"])
	visuals["hair_color_hue"] = dominant_hue + randf_range(-0.15, 0.15)
	visuals["hair_texture"] = VISUAL_PARAMETERS["hair_texture"]["options"][randi() % VISUAL_PARAMETERS["hair_texture"]["options"].size()]
	visuals["hair_shine"] = randf_range(0.4, 1.0)
	
	# Facial structure (defines expressiveness)
	visuals["facial_structure"] = VISUAL_PARAMETERS["facial_structure"]["options"][randi() % VISUAL_PARAMETERS["facial_structure"]["options"].size()]
	visuals["lip_fullness"] = randf_range(VISUAL_PARAMETERS["lip_fullness"]["min"], VISUAL_PARAMETERS["lip_fullness"]["max"])
	visuals["cheekbone_prominence"] = randf_range(0.3, 1.0)
	visuals["jaw_softness"] = randf_range(0.2, 1.0)
	
	# Skin characteristics
	visuals["skin_smoothness"] = randf_range(0.5, 1.0)
	visuals["freckle_coverage"] = randf_range(0.0, 0.4)
	visuals["beauty_marks"] = randi_range(0, 5)
	
	return visuals

# ============================================================================
## PERSONALITY GENERATION
## ============================================================================

static func _generate_personality_traits() -> Dictionary:
	"""Generate coherent personality trait vectors with psychological consistency."""
	var traits = {}
	
	# Generate base traits
	for trait in PERSONALITY_TRAITS.keys():
		traits[trait] = randf_range(PERSONALITY_TRAITS[trait]["min"], PERSONALITY_TRAITS[trait]["max"])
	
	# Apply psychological constraints (traits influence each other)
	
	# High neuroticism reduces resilience
	if traits["neuroticism"] > 0.6:
		traits["resilience"] = max(0.0, traits["resilience"] - (traits["neuroticism"] - 0.6) * 0.3)
	
	# High agreeableness increases trust capacity
	traits["trust_capacity"] += traits["agreeableness"] * 0.2
	traits["trust_capacity"] = min(1.0, traits["trust_capacity"])
	
	# High extraversion and openness often correlate
	if traits["extraversion"] > 0.6 and traits["openness"] < 0.5:
		traits["openness"] += randf_range(0.1, 0.3)
	
	# Dominance and agreeableness have inverse pressure
	var dominance_agreeableness_tension = abs(traits["dominance"] - traits["agreeableness"])
	if dominance_agreeableness_tension > 0.6:
		# Create internal conflict
		traits["neuroticism"] += randf_range(0.1, 0.2)
	
	# Idealism and pragmatism create meaningful tension
	traits["core_tension"] = abs(traits["idealism"] - traits["pragmatism"])
	
	return traits

# ============================================================================
## BACKSTORY GENERATION
## ============================================================================

static func _generate_backstory() -> Dictionary:
	"""Generate a psychologically coherent backstory."""
	var archetype = BACKSTORY_ARCHETYPES[randi() % BACKSTORY_ARCHETYPES.size()]
	
	var backstory = {
		"archetype": archetype["name"],
		"core_conflict": archetype["core_conflict"],
		"present_situation": _generate_present_situation(archetype),
		"formative_years": _generate_formative_years(archetype),
		"adolescence": _generate_adolescence(archetype),
		"young_adulthood": _generate_young_adulthood(archetype),
		"current_struggles": archetype["trauma_factors"],
	}
	
	return backstory

static func _generate_present_situation(archetype: Dictionary) -> String:
	"""Current life circumstances."""
	var situations = [
		"Seeking refuge from their previous life",
		"Attempting to rebuild after a major collapse",
		"Transitioning between identities",
		"Struggling with feelings of displacement",
		"Searching for meaning and direction",
	]
	return situations[randi() % situations.size()]

static func _generate_formative_years(archetype: Dictionary) -> Dictionary:
	"""Ages 0-12 psychological foundation."""
	var years = {
		"primary_relationship": ["mother", "father", "grandmother", "older sibling", "no_stable_figure"][randi() % 5],
		"emotional_climate": ["warm_but_chaotic", "cold_rigid", "inconsistent", "nurturing", "neglectful"][randi() % 5],
		"key_event": "A formative experience that shaped their worldview",
		"attachment_pattern": ["secure", "anxious", "avoidant", "disorganized"][randi() % 4],
	}
	return years

static func _generate_adolescence(archetype: Dictionary) -> Dictionary:
	"""Ages 13-18 identity formation."""
	var adolescence = {
		"primary_identity": ["outcast", "achiever", "social_butterfly", "invisible", "rebel"][randi() % 5],
		"peer_relationship": ["isolated", "loyal_group", "many_shallow", "complicated_romance"][randi() % 4],
		"self_perception": randf_range(0.2, 0.9),
		"major_event": "Something that challenged their emerging identity",
	}
	return adolescence

static func _generate_young_adulthood(archetype: Dictionary) -> Dictionary:
	"""Ages 19-present professional and romantic development."""
	var adulthood = {
		"career_path": ["unfulfilling", "passionate_but_struggling", "successful_but_hollow", "undefined"][randi() % 4],
		"relationship_history": ["isolation", "brief_affairs", "long_term_failure", "no_romantic_experience"][randi() % 4],
		"major_accomplishment": "Something they are genuinely proud of",
		"major_failure": "A wound that still bleeds",
		"current_coping": ["avoidance", "overwork", "escapism", "raw_processing"][randi() % 4],
	}
	return adulthood

# ============================================================================
## TRAUMA AND PSYCHOLOGICAL PROFILE
## ============================================================================

static func _generate_life_events() -> Array:
	"""Generate 4-6 significant life events that shape psychology."""
	var events = []
	var event_count = randi_range(4, 6)
	
	for i in range(event_count):
		var template = LIFE_EVENTS[randi() % LIFE_EVENTS.size()]
		var event = {
			"type": template["type"],
			"description": template["descriptions"][randi() % template["descriptions"].size()],
			"age_when_occurred": randi_range(10, 40),
			"emotional_intensity": randf_range(0.3, 1.0),
			"impact_categories": template["impact_categories"],
			"processed_level": randf_range(0.0, 0.5),
		}
		events.append(event)
	
	return events

static func _identify_core_trauma() -> Dictionary:
	"""Identify the primary psychological wound."""
	var trauma_types = [
		"abandonment",
		"invalidation",
		"powerlessness",
		"betrayal",
		"shame",
		"loss",
		"violence",
		"isolation",
	]
	
	return {
		"primary_type": trauma_types[randi() % trauma_types.size()],
		"activation_triggers": _generate_trauma_triggers(),
		"defense_mechanisms": _generate_defense_mechanisms(),
		"avoidance_patterns": _generate_avoidance_patterns(),
	}

static func _generate_trauma_triggers() -> Array:
	"""Situations that activate the core trauma response."""
	var triggers = [
		"emotional_abandonment",
		"criticism_or_judgment",
		"loss_of_control",
		"intimate_vulnerability",
		"rejection",
		"being_unheard",
		"feeling_trapped",
	]
	var result = []
	var count = randi_range(2, 4)
	for i in range(count):
		result.append(triggers[randi() % triggers.size()])
	return result

static func _generate_defense_mechanisms() -> Array:
	"""How they protect themselves psychologically."""
	var mechanisms = [
		"emotional_numbing",
		"intellectualization",
		"humor_deflection",
		"anger_projection",
		"withdrawal",
		"people_pleasing",
		"perfectionism",
		"dissociation",
	]
	var result = []
	var count = randi_range(2, 3)
	for i in range(count):
		result.append(mechanisms[randi() % mechanisms.size()])
	return result

static func _generate_avoidance_patterns() -> Array:
	"""Situations or emotions they habitually avoid."""
	var patterns = [
		"intimate_conversations",
		"conflict_confrontation",
		"being_alone",
		"large_social_gatherings",
		"silence_or_stillness",
		"their_own_needs",
		"vulnerability",
		"uncertainty",
	]
	var result = []
	var count = randi_range(2, 4)
	for i in range(count):
		result.append(patterns[randi() % patterns.size()])
	return result

# ============================================================================
## PSYCHOLOGICAL PROFILE SYNTHESIS
## ============================================================================

static func _create_psychological_profile() -> Dictionary:
	"""Create a comprehensive psychological profile."""
	return {
		"attachment_style": ["secure", "anxious", "avoidant", "fearful"][randi() % 4],
		"love_language": ["words_of_affirmation", "quality_time", "physical_touch", "acts_of_service", "gifts"][randi() % 5],
		"conflict_style": ["avoidant", "accommodating", "competing", "compromising", "collaborative"][randi() % 5],
		"intimacy_comfort": randf_range(0.2, 0.9),
		"sexual_comfort": randf_range(0.3, 0.95),
		"communication_style": ["direct", "indirect", "nonverbal", "avoidant"][randi() % 4],
		"emotional_expression": randf_range(0.2, 1.0),
		"need_for_autonomy": randf_range(0.2, 1.0),
		"need_for_intimacy": randf_range(0.2, 1.0),
		"capacity_for_joy": randf_range(0.3, 1.0),
		"capacity_for_depth": randf_range(0.4, 1.0),
	}

# ============================================================================
## NAME GENERATION
## ============================================================================

static func _generate_name() -> String:
	"""Generate an anime-appropriate female name."""
	var first_names = [
		"Yuki", "Akira", "Sakura", "Hana", "Emi", "Mika", "Rin",
		"Aiko", "Kaori", "Tomoe", "Chiyo", "Yoshi", "Asuka", "Rei",
		"Ayumi", "Shiori", "Nanako", "Misaki", "Chie", "Minako", "Noriko",
		"Kaida", "Sora", "Natsuki", "Hikari", "Tsukiko", "Hazuki", "Natsu",
	]
	
	var last_names = [
		"Tanaka", "Yamamoto", "Nakamura", "Kobayashi", "Kato", "Ito", "Nakajima",
		"Suzuki", "Sasaki", "Matsumoto", "Inoue", "Kimura", "Shimizu", "Yamada",
		"Okada", "Sato", "Nakano", "Harada", "Tamura", "Fujita", "Watanabe",
	]
	
	return first_names[randi() % first_names.size()] + " " + last_names[randi() % last_names.size()]
