mdp

const int intOpenInput = 0;
const bool boolOpenInput = false;

//state labels
label "Violation_observerA_observers" = (s_observerA_observers=1);
label "Violation_observerS_observers" = (s_observerS_observers=2);

module iReset
    s_iReset : [-1..1] init -1;
    //s_iReset=0 - IDLE
    //s_iReset=1 - RESET

    //Generated from output events
    doReset_iReset : bool init false;

    [t] (s_iReset=-1) -> (s_iReset'=0) & (doReset_iReset'=false);
    [t] (s_iReset=0) & ((trigger_controller = true)) -> (s_iReset'=1) & (doReset_iReset'=true);
    [t] (s_iReset=1) -> (s_iReset'=0) & (doReset_iReset'=false);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_iReset=0) & ((trigger_controller = false)) -> (s_iReset'=0) & (doReset_iReset'=false);
endmodule


module a1_actuators
    s_a1_actuators : [-1..1] init -1;
    //s_a1_actuators=0 - OFF
    //s_a1_actuators=1 - ON

    //Generated from output events
    update_a1_actuators : bool init false;

    //Generated from internal and output variables
    isSound_a1_actuators : bool init false;

    [t] (s_a1_actuators=-1) -> (s_a1_actuators'=0) & (update_a1_actuators'=true) & (isSound_a1_actuators' = false);
    [t] (s_a1_actuators=0) & ((trigger_controller & alarm_controller)) -> (s_a1_actuators'=1) & (update_a1_actuators'=true) & (isSound_a1_actuators' = true);
    [t] (s_a1_actuators=1) & ((trigger_controller & (alarm_controller = false))) -> (s_a1_actuators'=0) & (update_a1_actuators'=true) & (isSound_a1_actuators' = false);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_a1_actuators=0) & (((trigger_controller = false) | (alarm_controller = false))) -> (s_a1_actuators'=0) & (update_a1_actuators'=false);
    [t] (s_a1_actuators=1) & (((trigger_controller = false) | (alarm_controller = true))) -> (s_a1_actuators'=1) & (update_a1_actuators'=false);
endmodule


module v1_actuators
    s_v1_actuators : [-1..1] init -1;
    //s_v1_actuators=0 - CLOSED
    //s_v1_actuators=1 - OPEN

    //Generated from output events
    update_v1_actuators : bool init false;

    //Generated from internal and output variables
    isOpen_v1_actuators : bool init false;

    [t] (s_v1_actuators=-1) -> (s_v1_actuators'=0) & (update_v1_actuators'=true) & (isOpen_v1_actuators' = false);
    [t] (s_v1_actuators=0) & ((trigger_controller & sprinkler_controller)) -> (s_v1_actuators'=1) & (update_v1_actuators'=true) & (isOpen_v1_actuators' = true);
    [t] (s_v1_actuators=1) & ((trigger_controller & (sprinkler_controller = false))) -> (s_v1_actuators'=0) & (update_v1_actuators'=true) & (isOpen_v1_actuators' = false);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_v1_actuators=0) & (((trigger_controller = false) | (sprinkler_controller = false))) -> (s_v1_actuators'=0) & (update_v1_actuators'=false);
    [t] (s_v1_actuators=1) & (((trigger_controller = false) | (sprinkler_controller = true))) -> (s_v1_actuators'=1) & (update_v1_actuators'=false);
endmodule


module d0_sensors
    s_d0_sensors : [-1..1] init -1;
    //s_d0_sensors=0 - NORMAL
    //s_d0_sensors=1 - DETECTED

    //Generated from output events
    output_d0_sensors : bool init false;

    //Generated from internal and output variables
    detected_d0_sensors : bool init false;

    [t] (s_d0_sensors=-1) -> (s_d0_sensors'=0) & (output_d0_sensors'=true) & (detected_d0_sensors' = false);
    [t] (s_d0_sensors=0) & ((incident0_sim_sensors = true)) -> (s_d0_sensors'=1) & (output_d0_sensors'=true) & (detected_d0_sensors' = true);
    [t] (s_d0_sensors=1) & ((doReset_iReset = true)) -> (s_d0_sensors'=0) & (output_d0_sensors'=true) & (detected_d0_sensors' = false);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_d0_sensors=0) & ((incident0_sim_sensors = false)) -> (s_d0_sensors'=0) & (output_d0_sensors'=false);
    [t] (s_d0_sensors=1) & ((doReset_iReset = false)) -> (s_d0_sensors'=1) & (output_d0_sensors'=false);
endmodule


module d1_sensors
    s_d1_sensors : [-1..1] init -1;
    //s_d1_sensors=0 - NORMAL
    //s_d1_sensors=1 - DETECTED

    //Generated from output events
    output_d1_sensors : bool init false;

    //Generated from internal and output variables
    detected_d1_sensors : bool init false;

    [t] (s_d1_sensors=-1) -> (s_d1_sensors'=0) & (output_d1_sensors'=true) & (detected_d1_sensors' = false);
    [t] (s_d1_sensors=0) & ((incident1_sim_sensors = true)) -> (s_d1_sensors'=1) & (output_d1_sensors'=true) & (detected_d1_sensors' = true);
    [t] (s_d1_sensors=1) & ((doReset_iReset = true)) -> (s_d1_sensors'=0) & (output_d1_sensors'=true) & (detected_d1_sensors' = false);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_d1_sensors=0) & ((incident1_sim_sensors = false)) -> (s_d1_sensors'=0) & (output_d1_sensors'=false);
    [t] (s_d1_sensors=1) & ((doReset_iReset = false)) -> (s_d1_sensors'=1) & (output_d1_sensors'=false);
endmodule


module d2_sensors
    s_d2_sensors : [-1..1] init -1;
    //s_d2_sensors=0 - NORMAL
    //s_d2_sensors=1 - DETECTED

    //Generated from output events
    output_d2_sensors : bool init false;

    //Generated from internal and output variables
    detected_d2_sensors : bool init false;

    [t] (s_d2_sensors=-1) -> (s_d2_sensors'=0) & (output_d2_sensors'=true) & (detected_d2_sensors' = false);
    [t] (s_d2_sensors=0) & ((incident2_sim_sensors = true)) -> (s_d2_sensors'=1) & (output_d2_sensors'=true) & (detected_d2_sensors' = true);
    [t] (s_d2_sensors=1) & ((doReset_iReset = true)) -> (s_d2_sensors'=0) & (output_d2_sensors'=true) & (detected_d2_sensors' = false);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_d2_sensors=0) & ((incident2_sim_sensors = false)) -> (s_d2_sensors'=0) & (output_d2_sensors'=false);
    [t] (s_d2_sensors=1) & ((doReset_iReset = false)) -> (s_d2_sensors'=1) & (output_d2_sensors'=false);
endmodule


module sim_sensors
    s_sim_sensors : [-1..4] init -1;
    //s_sim_sensors=0 - START
    //s_sim_sensors=1 - ONE
    //s_sim_sensors=2 - TWO
    //s_sim_sensors=3 - THREE
    //s_sim_sensors=4 - NONE

    //Generated from output events
    incident0_sim_sensors : bool init false;
    incident1_sim_sensors : bool init false;
    incident2_sim_sensors : bool init false;

    [t] (s_sim_sensors=-1) -> (s_sim_sensors'=0) & (incident0_sim_sensors'=false) & (incident1_sim_sensors'=false) & (incident2_sim_sensors'=false);
    [t] (s_sim_sensors=1) & ((doReset_iReset = true)) -> (s_sim_sensors'=2) & (incident1_sim_sensors'=true) & (incident0_sim_sensors'=true) & (incident2_sim_sensors'=false);
    [t] (s_sim_sensors=2) & ((doReset_iReset = true)) -> (s_sim_sensors'=3) & (incident2_sim_sensors'=true) & (incident0_sim_sensors'=true) & (incident1_sim_sensors'=true);
    [t] (s_sim_sensors=0) -> (s_sim_sensors'=4) & (incident0_sim_sensors'=false) & (incident1_sim_sensors'=false) & (incident2_sim_sensors'=false);
    [t] (s_sim_sensors=4) -> (s_sim_sensors'=1) & (incident0_sim_sensors'=true) & (incident1_sim_sensors'=false) & (incident2_sim_sensors'=false);
    [t] (s_sim_sensors=3) & ((doReset_iReset = true)) -> (s_sim_sensors'=4) & (incident0_sim_sensors'=false) & (incident1_sim_sensors'=false) & (incident2_sim_sensors'=false);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_sim_sensors=1) & ((doReset_iReset = false)) -> (s_sim_sensors'=1) & (incident0_sim_sensors'=false) & (incident1_sim_sensors'=false) & (incident2_sim_sensors'=false);
    [t] (s_sim_sensors=2) & ((doReset_iReset = false)) -> (s_sim_sensors'=2) & (incident0_sim_sensors'=false) & (incident1_sim_sensors'=false) & (incident2_sim_sensors'=false);
    [t] (s_sim_sensors=3) & ((doReset_iReset = false)) -> (s_sim_sensors'=3) & (incident0_sim_sensors'=false) & (incident1_sim_sensors'=false) & (incident2_sim_sensors'=false);
endmodule


module controller
    s_controller : [-1..1] init -1;
    //s_controller=0 - PROCESS
    //s_controller=1 - DETECTED

    //Generated from output events
    trigger_controller : bool init false;

    //Generated from internal and output variables
    alarm_controller : bool init false;
    sprinkler_controller : bool init false;
    needsReset_controller : bool init false;

    [t] (s_controller=-1) -> (s_controller'=0) & (trigger_controller'=false) & (alarm_controller' = ((detected_d0_sensors | detected_d1_sensors) | detected_d2_sensors)) & (sprinkler_controller' = (((detected_d0_sensors & detected_d1_sensors) | (detected_d0_sensors & detected_d2_sensors)) | (detected_d1_sensors & detected_d2_sensors))) & (needsReset_controller' = ((detected_d0_sensors | detected_d1_sensors) | detected_d2_sensors));
    [t] (s_controller=0) & ((needsReset_controller = false)) -> (s_controller'=0) & (trigger_controller'=false) & (alarm_controller' = ((detected_d0_sensors | detected_d1_sensors) | detected_d2_sensors)) & (sprinkler_controller' = (((detected_d0_sensors & detected_d1_sensors) | (detected_d0_sensors & detected_d2_sensors)) | (detected_d1_sensors & detected_d2_sensors))) & (needsReset_controller' = ((detected_d0_sensors | detected_d1_sensors) | detected_d2_sensors));
    [t] (s_controller=0) & ((needsReset_controller = true)) -> (s_controller'=1) & (trigger_controller'=true);
    [t] (s_controller=1) & ((doReset_iReset = true)) -> (s_controller'=0) & (trigger_controller'=false) & (alarm_controller' = ((detected_d0_sensors | detected_d1_sensors) | detected_d2_sensors)) & (sprinkler_controller' = (((detected_d0_sensors & detected_d1_sensors) | (detected_d0_sensors & detected_d2_sensors)) | (detected_d1_sensors & detected_d2_sensors))) & (needsReset_controller' = ((detected_d0_sensors | detected_d1_sensors) | detected_d2_sensors));

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_controller=1) & ((doReset_iReset = false)) -> (s_controller'=1) & (trigger_controller'=false);
endmodule


module observerA_observers
    s_observerA_observers : [-1..2] init -1;
    //s_observerA_observers=0 - IDLE
    //s_observerA_observers=1 - Violation
    //s_observerA_observers=2 - DETECT

    //Generated from internal and output variables
    needAlarm_observerA_observers : bool init false;
    counter_observerA_observers : [0..5] init 0;

    [t] (s_observerA_observers=-1) -> (s_observerA_observers'=0) & (counter_observerA_observers' = 0);
    [t] (s_observerA_observers=2) & (((counter_observerA_observers >= 3) | (needAlarm_observerA_observers = isSound_a1_actuators)) & ((counter_observerA_observers >= 3) & (needAlarm_observerA_observers != isSound_a1_actuators))) -> (s_observerA_observers'=1);
    [t] (s_observerA_observers=0) & ((((incident0_sim_sensors | incident1_sim_sensors | incident2_sim_sensors)) = true)) -> (s_observerA_observers'=2) & (needAlarm_observerA_observers' = ((detected_d0_sensors | detected_d1_sensors) | detected_d2_sensors)) & (counter_observerA_observers' = (counter_observerA_observers < 5) ? (counter_observerA_observers + 1) : counter_observerA_observers);
    [t] (s_observerA_observers=2) & (((counter_observerA_observers < 3) & (needAlarm_observerA_observers != isSound_a1_actuators))) -> (s_observerA_observers'=2) & (needAlarm_observerA_observers' = ((detected_d0_sensors | detected_d1_sensors) | detected_d2_sensors)) & (counter_observerA_observers' = (counter_observerA_observers < 5) ? (counter_observerA_observers + 1) : counter_observerA_observers);
    [t] (s_observerA_observers=2) & (((counter_observerA_observers >= 3) | (needAlarm_observerA_observers = isSound_a1_actuators)) & ((counter_observerA_observers < 3) | (needAlarm_observerA_observers = isSound_a1_actuators)) & (doReset_iReset = true)) -> (s_observerA_observers'=0) & (counter_observerA_observers' = 0);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_observerA_observers=0) & ((((incident0_sim_sensors | incident1_sim_sensors | incident2_sim_sensors)) = false)) -> (s_observerA_observers'=0);
    [t] (s_observerA_observers=1) -> (s_observerA_observers'=1);
    [t] (s_observerA_observers=2) & (((counter_observerA_observers >= 3) | (needAlarm_observerA_observers = isSound_a1_actuators)) & ((counter_observerA_observers < 3) | (needAlarm_observerA_observers = isSound_a1_actuators)) & (doReset_iReset = false)) -> (s_observerA_observers'=2);
endmodule


module observerS_observers
    s_observerS_observers : [-1..2] init -1;
    //s_observerS_observers=0 - IDLE
    //s_observerS_observers=1 - DETECT
    //s_observerS_observers=2 - Violation

    //Generated from internal and output variables
    counter_observerS_observers : [0..5] init 0;
    needSprinkler_observerS_observers : bool init false;

    [t] (s_observerS_observers=-1) -> (s_observerS_observers'=0) & (counter_observerS_observers' = 0);
    [t] (s_observerS_observers=0) & ((((incident0_sim_sensors | incident1_sim_sensors | incident2_sim_sensors)) = true)) -> (s_observerS_observers'=1) & (needSprinkler_observerS_observers' = (((detected_d0_sensors & detected_d1_sensors) | (detected_d0_sensors & detected_d2_sensors)) | (detected_d1_sensors & detected_d2_sensors))) & (counter_observerS_observers' = (counter_observerS_observers < 5) ? (counter_observerS_observers + 1) : counter_observerS_observers);
    [t] (s_observerS_observers=1) & ((doReset_iReset = true)) -> (s_observerS_observers'=0) & (counter_observerS_observers' = 0);
    [t] (s_observerS_observers=1) & ((doReset_iReset = false) & ((counter_observerS_observers >= 3) | (needSprinkler_observerS_observers = isOpen_v1_actuators)) & ((counter_observerS_observers >= 3) & (needSprinkler_observerS_observers != isOpen_v1_actuators))) -> (s_observerS_observers'=2);
    [t] (s_observerS_observers=1) & ((doReset_iReset = false) & ((counter_observerS_observers < 3) & (needSprinkler_observerS_observers != isOpen_v1_actuators))) -> (s_observerS_observers'=1) & (needSprinkler_observerS_observers' = (((detected_d0_sensors & detected_d1_sensors) | (detected_d0_sensors & detected_d2_sensors)) | (detected_d1_sensors & detected_d2_sensors))) & (counter_observerS_observers' = (counter_observerS_observers < 5) ? (counter_observerS_observers + 1) : counter_observerS_observers);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_observerS_observers=0) & ((((incident0_sim_sensors | incident1_sim_sensors | incident2_sim_sensors)) = false)) -> (s_observerS_observers'=0);
    [t] (s_observerS_observers=1) & ((doReset_iReset = false) & ((counter_observerS_observers >= 3) | (needSprinkler_observerS_observers = isOpen_v1_actuators)) & ((counter_observerS_observers < 3) | (needSprinkler_observerS_observers = isOpen_v1_actuators))) -> (s_observerS_observers'=1);
    [t] (s_observerS_observers=2) -> (s_observerS_observers'=2);
endmodule
