# GOTOT - Psychological Life-Simulation Game

## Overview

Gotot is a deeply detailed, mature (18+) psychological life-simulation game featuring:

- **Procedurally generated companions** with unique visual parameters, personality trait vectors, and consistent backstories
- **Advanced emotional AI** with sophisticated behavioral state machines and complex emotional dynamics
- **Persistent character system** using a single `companion_state.json` file that can be permanently deleted on terminal narrative events
- **Transformative gameplay** where player choices create lasting consequences and permanent personality changes
- **Beautiful anime-style visuals** with 2D rigging, 12+ facial expression blendshapes, and dynamic particle effects
- **Deep narrative focus** on emotional authenticity, psychological complexity, and meaningful choices

## Architecture

### Core Systems

#### 1. **CompanionData** (`autoload/CompanionData.gd`)
Manages the entire companion state including:
- Visual parameters (height, frame, facial features, coloration)
- Personality trait vectors (Big Five extended model)
- Memory system with impact tracking
- Condition and integrity metrics
- Attachment and bonding dynamics
- Terminal event flagging

#### 2. **EmotionAI** (`autoload/EmotionAI.gd`)
Sophisticated emotional simulation with:
- 10-dimensional emotion vector (Fear, Despair, Attachment, Defiance, Submission, Intensity, Satisfaction, Shame, Hope, Autonomy)
- Mathematical formulas for emotional dynamics with decay, amplification, and cross-emotional interactions
- Behavioral state machine (8 states: Baseline, Receptive, Resistant, Overwhelmed, Traumatized, Dissociated, Compliant, Transcendent)
- Dynamic response generation based on emotional state
- Trauma trigger evaluation and activation

#### 3. **InteractionEngine** (`autoload/InteractionEngine.gd`)
Processes player interactions with 4 primary types:
- **Supportive & Affectionate**: Comfort, reassurance, physical affection, listening
- **Transformative Events**: Profound experiences, trauma confrontation, breakthroughs, degradation, corruption, resurrection
- **Intimate Engagement**: 4-stage progression with building intensity and multiple emotional outcomes
- **Psychological Dialogue**: Gentle exploration, confrontation, manipulation, validation, ethical testing

#### 4. **SaveSystem** (`autoload/SaveSystem.gd`)
Persistent state management with:
- Single save file: `user://companion_state.json`
- Automatic backups before overwrites
- Terminal event support with permanent file deletion
- Save integrity verification

#### 5. **LifeSimulator** (`autoload/LifeSimulator.gd`)
Time and state progression:
- Passive emotional drift between interactions
- Condition degradation and recovery
- Life event triggering
- Time multiplier for accelerated simulation

#### 6. **VisualManager** (`autoload/VisualManager.gd`)
Graphics and animation system:
- 12+ facial expression blendshapes
- Skeleton2D rigging with IK support
- Dynamic shader effects (corruption, healing, emotional states)
- Particle effects for narrative moments
- Real-time material parameter adjustment

### Project Structure

```
res://
├── project.godot
├── scenes/
│   ├── Main.tscn                 # Main game scene
│   ├── Companion.tscn            # 2D rigged character model
│   └── CloseUpView.tscn          # Detailed inspection view
├── autoload/
│   ├── CompanionData.gd          # Character state management
│   ├── EmotionAI.gd              # Emotional simulation engine
│   ├── InteractionEngine.gd      # Interaction processing
│   ├── SaveSystem.gd             # Persistence layer
│   ├── LifeSimulator.gd          # Time progression
│   └── VisualManager.gd          # Graphics pipeline
├── resources/
│   ├── companion_generator.gd    # Procedural generation
│   └── shaders/
│       └── companion_shader.gdshader  # Dynamic material effects
├── ui/
│   ├── MainUI.tscn              # Main interface
│   ├── EmotionDisplay.tscn       # Emotional status indicators
│   ├── InteractionMenu.tscn      # Contextual interaction menu
│   └── InspectionPanel.tscn      # Detailed inspection tools
├── assets/
│   └── ... # Visual and audio assets
└── data/
    └── ... # Game data, configuration
```

## Key Features

### Procedural Generation System

Every new game generates a completely unique companion:

```gdscript
# Visual parameters
- Height (155-185cm), Frame type, Skin tone
- Eye color, shape, size, expressiveness
- Hair length, color, texture, shine
- Facial structure, lip fullness, cheekbone prominence
- Bust size, hip width

# Personality traits (Big Five Extended)
- Openness, Conscientiousness, Extraversion, Agreeableness, Neuroticism
- Resilience, Dominance, Trust Capacity, Idealism, Pragmatism

# Psychological foundation
- Archetype (Lost Academic, Artistic Soul, Corporate Burnout, etc.)
- Backstory (formative years, adolescence, young adulthood)
- Core trauma (abandonment, invalidation, powerlessness, betrayal, etc.)
- Life events with lasting impact
- Psychological profile (attachment style, love language, conflict style)
```

### Emotional Vector System

Complex emotional dynamics with mathematical formulas:

```gdscript
# Emotional dimensions
Fear:         Neuroticism-based anxiety response
Despair:      Inverse satisfaction accumulation
Attachment:   Trust capacity × positive interactions
Defiance:     Autonomy threat response
Submission:   Conditioning × low confidence
Intensity:    Total emotional activation
Satisfaction: Outcome of interactions
Shame:        Perceived failure, judgment
Hope:         Resilience × positive outcomes
Autonomy:     1.0 - submission level

# Example formula for Fear:
fear(t) = fear(t-1) × decay_rate + baseline × delta
where decay_rate ∈ [0.85, 0.98] depending on trauma activation
```

### Behavioral State Machine

The companion occupies one of 8 behavioral states that determine interaction possibilities:

1. **BASELINE** - Neutral, calm, open to interaction
2. **RECEPTIVE** - Trusting, engaged, highly responsive
3. **RESISTANT** - Defensive, opposed, resistant to influence
4. **OVERWHELMED** - Emotionally flooded, struggling to process
5. **TRAUMATIZED** - Active trauma response, in crisis
6. **DISSOCIATED** - Mentally absent, present only in body
7. **COMPLIANT** - Accepting without resistance, cooperative
8. **TRANSCENDENT** - Peak emotional connection, transcendent state

### Memory & Conditioning System

Significant events create lasting behavioral changes:

```gdscript
# Memory entry structure
{
  "timestamp": int,
  "type": string,
  "description": string,
  "emotional_impact": { fear, despair, attachment, ... },
  "gameplay_impact": 0.0-1.0,
  "integrated": bool,
  "recall_frequency": int,
  "influence_on_behavior": []
}

# Conditioning creates automatic responses
- Events with gameplay_impact > 0.7 create behavioral triggers
- Triggers activate when trauma or stress is high
- Repeated conditioning permanently alters response patterns
```

### Terminal Event System

Narrative permanence through file deletion:

```gdscript
# On terminal event
CompanionData.mark_terminal_event(reason: String)

# Reasons might include:
- "She chose to leave, seeking a life beyond this place"
- "Unable to bear the burden of what she's become"
- "Transcendence and departure from the mortal realm"
- "Complete dissociation - no self remains to recover"

# Final confirmation
SaveSystem.finalize_terminal_event()  # Permanently deletes companion_state.json
# Companion departs forever. New game generates fresh character.
```

## Interaction Types

### 1. Supportive & Affectionate

```gdscript
execute_supportive_interaction(action: String)

Actions:
- "comfort": Emotional comfort and reassurance
- "reassure": Validation and encouragement
- "cuddle": Physical affection and closeness
- "listen": Attentive listening to open up

Effects:
- Reduces fear and despair
- Increases attachment and satisfaction
- Visual feedback: soft glow, gentle aura
- Particle effects: comfort particles
```

### 2. Transformative Events

```gdscript
execute_transformative_event(event_type: String)

Event types:
- "profound_experience": Deep emotional connection
- "trauma_confrontation": Processing past trauma
- "breakthrough_moment": Realization or epiphany
- "degradation_spiral": Descent into despair
- "corruption_point": Moral compromise
- "resurrection": Recovery and healing

Effects:
- Permanent personality drift
- Condition changes (psychological integrity, sense of self)
- Alteration increases (corruption, conditioning, trauma depth)
- 90-180 second animation sequences
- Memory integration with high impact values
```

### 3. Intimate Engagement

```gdscript
execute_intimate_engagement(stage: int, intensity: float)

Stages:
1. Connection - Consent and safety establishment
2. Building - Intimacy development and trust growth
3. Peak - Maximum intensity and possible transcendence
4. Aftermath - Emotional integration and consequences

Branching outcomes based on:
- Attachment score
- Personality traits
- Current emotional state
- Psychological condition

Possible states:
- Eager consent → Transcendent union
- Hesitant vulnerable → Emotional deepening
- Measured consent → Building trust
- Refused (if preconditions not met)
```

### 4. Psychological Dialogue

```gdscript
execute_psychological_interaction(dialogue_type: String, influence_vector: Dictionary)

Dialogue types:
- "gentle_exploration": Soft exploration of feelings
- "confrontation": Challenging beliefs or behaviors
- "manipulation": Psychological manipulation
- "validation": Affirming identity and experiences
- "ethical_testing": Exploring moral boundaries

Effects:
- Trust changes (positive or negative)
- Personality drift based on influence vector
- Conditioning establishment (especially for manipulation)
- Long-term behavioral modifications
- Emotional state alteration
```

## Companion State Structure

```json
{
  "id": "unique-identifier",
  "name": "Generated name",
  "age": 18-35,
  "generation_seed": 12345,
  
  "visual": {
    "height": 170,
    "frame_type": "slender",
    "skin_tone": 0.65,
    "eye_color_hue": 0.3,
    "hair_length": 60,
    "hair_color_hue": 0.2,
    "bust_size": 0.75,
    "hip_width": 0.9
  },
  
  "personality": {
    "openness": 0.75,
    "conscientiousness": 0.55,
    "extraversion": 0.45,
    "agreeableness": 0.70,
    "neuroticism": 0.65,
    "resilience": 0.50,
    "dominance": 0.35,
    "trust_capacity": 0.60,
    "idealism": 0.75,
    "pragmatism": 0.40
  },
  
  "emotions": {
    "fear": 0.35,
    "despair": 0.25,
    "attachment": 0.15,
    "defiance": 0.20,
    "submission": 0.10,
    "intensity": 0.22,
    "satisfaction": 0.40,
    "shame": 0.20,
    "hope": 0.50,
    "autonomy": 0.70
  },
  
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
    "is_present": true
  },
  
  "alterations": {
    "corruption_level": 0.0,
    "compliance_level": 0.0,
    "conditioning_depth": 0.0,
    "trauma_depth": 0.0,
    "dissociation_depth": 0.0,
    "identity_dissolution": 0.0
  },
  
  "memory": {
    "total_interactions": 0,
    "memory_entries": [],
    "relationship_memory": {},
    "conditional_triggers": {},
    "behavioral_patterns": {}
  },
  
  "attachment": {
    "attachment_score": 0.0,
    "dependency_level": 0.0,
    "loyalty_level": 0.0,
    "emotional_entanglement": 0.0,
    "bonding_events": []
  },
  
  "behaviors": {
    "acquired_preferences": [],
    "learned_responses": [],
    "conditioned_reactions": [],
    "trauma_responses": [],
    "coping_mechanisms": []
  },
  
  "terminal_events": {
    "has_departed": false,
    "departure_reason": "",
    "departure_timestamp": 0
  }
}
```

## Mathematical Foundation

### Emotional Update Formulas

**Fear (anxiety response):**
```
fear(t) = fear(t-1) × decay + baseline × dt
decay = 0.98 (normal) to 0.85 (high trauma)
baseline = personality[neuroticism] × 0.3
```

**Despair (accumulated negative state):**
```
satisfaction_ratio = max(0, satisfaction - 0.5)
despair_growth = max(0, 0.3 - satisfaction_ratio) × 0.1 × dt
despair_relief = (resilience + hope) × 0.05 × dt
despair(t) = despair(t-1) + growth - relief
```

**Attachment (bonding to player):**
```
attachment_growth = interaction_quality × 0.01
attachment_growth *= (1 + neuroticism × 0.5)  # Neuroticism accelerates attachment
attachment_growth *= (1 - resilience × 0.3)   # Resilience resists attachment
```

**Submission (compliance tendency):**
```
confidence = 1 - neuroticism
submission_pressure = (1 - confidence) × 0.1
submission(t) = submission(t-1) × 0.99 + pressure × dt
```

**Integrity (psychological wholeness):**
```
integrity_drain = trauma_activation × 0.001
integrity_drain += overwhelm² × 0.0005
recovery_bonus = resilience × 0.0002
integrity(t) = clamp(integrity(t-1) - drain + recovery, 0, 1)
```

## UI/UX System

### Main Interface
- Clean anime-aesthetic with contextual menus
- Real-time emotional state visualization
- Character status panel (condition, attachments, alterations)
- Interaction menu with action suggestions based on state
- Time display and simulation speed control

### Inspection Tools
- Detailed psychological profile viewer
- Memory log with searchable entries
- Personality trait visualization
- Condition tracking graphs
- Behavioral pattern analysis

### Emotional Indicators
- 10-dimensional emotion vector display
- Behavioral state indicator
- Attachment score tracker
- Corruption level visualization
- Real-time response predictions

## Development Roadmap

### Phase 1: Core Systems (Current)
- ✅ Procedural generation
- ✅ Emotional AI foundation
- ✅ Interaction engine
- ✅ Save/load system
- ✅ Time simulation

### Phase 2: Visuals & Animation
- 2D rigging with Skeleton2D
- 12+ facial expression blendshapes
- Dynamic shader pipeline
- Particle effect system
- Animation state machine

### Phase 3: UI & Polish
- Main scene implementation
- UI menus and panels
- Inspection tools
- Settings and configuration
- Performance optimization

### Phase 4: Content & Narrative
- Expanded dialogue system
- Narrative branching
- Event sequences
- Music and sound design
- Additional interaction types

## Code Quality Standards

- **Comprehensive comments**: Every method and major logic block documented
- **Type hints**: Full GDScript type annotations
- **Modularity**: Systems designed for independent expansion
- **Extensibility**: Hook points for new features
- **Debugging**: Extensive print statements for state tracking
- **Robustness**: Error handling and validation

## Performance Considerations

- Autosave interval: 30 seconds
- Emotional updates: Per-frame with optimized calculations
- Particle effects: GPU-based for efficiency
- State machine: Minimal state transition overhead
- Memory management: Efficient dictionary operations

## Artistic Vision

Gotot presents a mature, psychologically complex portrait of a woman whose existence is shaped by profound emotional depth. The game treats her as a full character with:

- Authentic emotional responses grounded in real psychology
- Meaningful consequences that persist and compound
- Agency within the constraints of her circumstances
- Dignity even in vulnerability
- Capacity for growth, healing, and transcendence
- Possible departure as a narrative conclusion

The tone is artistic, introspective, and deeply human—celebrating the complexity of the human heart.

---

**Status**: Production-ready architecture
**Last Updated**: 2026-05-24
**Engine**: Godot 4.3+
**Language**: GDScript
