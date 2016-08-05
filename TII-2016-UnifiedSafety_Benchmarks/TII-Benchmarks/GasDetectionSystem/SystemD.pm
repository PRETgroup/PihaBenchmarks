mdp

const int intOpenInput = 0;
const bool boolOpenInput = false;

//parameter list
const int PARAM_threshold_sensor2 = 30;

const int PARAM_threshold_sensor1 = 30;

const int PARAM_threshold_observer = 30;

//state labels
label "Violation_observer" = (s_observer=2);


module source
    s_source : [-1..1] init -1;
    //s_source=0 - START
    //s_source=1 - BUILDUP

    //Generated from output events
    output_source : bool init false;

    //Generated from internal and output variables
    gasValue_source : [0..100] init 0;

    [t] (s_source=-1) -> (s_source'=0) & (output_source'=true) & (gasValue_source' = (ventilation_vent & (gasValue_source > 5)) ? (gasValue_source - 5) : gasValue_source);
    [t] (s_source=1) -> (s_source'=0) & (output_source'=true) & (gasValue_source' = (ventilation_vent & (gasValue_source > 5)) ? (gasValue_source - 5) : gasValue_source);
    [t] (s_source=0) -> (s_source'=1) & (output_source'=true) & (gasValue_source' = (gasValue_source < 100) ? (gasValue_source + 1) : gasValue_source);
endmodule


module sensor2
    s_sensor2 : [-1..1] init -1;
    //s_sensor2=0 - START
    //s_sensor2=1 - INPUT_REC

    //Generated from output events
    output_sensor2 : bool init false;

    //Generated from internal and output variables
    outValue_sensor2 : bool init false;

    [t] (s_sensor2=-1) -> (s_sensor2'=0) & (output_sensor2'=false);
    [t] (s_sensor2=0) & ((output_source = true)) -> (s_sensor2'=1) & (output_sensor2'=true) & (outValue_sensor2' = (gasValue_source > PARAM_threshold_sensor2));
    [t] (s_sensor2=1) & ((output_source = true)) -> (s_sensor2'=1) & (output_sensor2'=true) & (outValue_sensor2' = (gasValue_source > PARAM_threshold_sensor2));

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_sensor2=0) & ((output_source = false)) -> (s_sensor2'=0) & (output_sensor2'=false);
    [t] (s_sensor2=1) & ((output_source = false)) -> (s_sensor2'=1) & (output_sensor2'=false);
endmodule


module sensor1
    s_sensor1 : [-1..1] init -1;
    //s_sensor1=0 - START
    //s_sensor1=1 - INPUT_REC

    //Generated from output events
    output_sensor1 : bool init false;

    //Generated from internal and output variables
    outValue_sensor1 : bool init false;

    [t] (s_sensor1=-1) -> (s_sensor1'=0) & (output_sensor1'=false);
    [t] (s_sensor1=0) & ((output_source = true)) -> (s_sensor1'=1) & (output_sensor1'=true) & (outValue_sensor1' = (gasValue_source > PARAM_threshold_sensor1));
    [t] (s_sensor1=1) & ((output_source = true)) -> (s_sensor1'=1) & (output_sensor1'=true) & (outValue_sensor1' = (gasValue_source > PARAM_threshold_sensor1));

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_sensor1=0) & ((output_source = false)) -> (s_sensor1'=0) & (output_sensor1'=false);
    [t] (s_sensor1=1) & ((output_source = false)) -> (s_sensor1'=1) & (output_sensor1'=false);
endmodule


module vent
    s_vent : [-1..2] init -1;
    //s_vent=0 - OFF
    //s_vent=1 - ON
    //s_vent=2 - WAIT_ON

    //Generated from output events
    output_vent : bool init false;

    //Generated from internal and output variables
    ventilation_vent : bool init false;
    counter_vent : [0..5] init 0;

    [t] (s_vent=-1) -> (s_vent'=0) & (output_vent'=true) & (ventilation_vent' = false) & (counter_vent' = 0);
    [t] (s_vent=0) & ((ouput_controller & ventilation_controller)) -> (s_vent'=1) & (output_vent'=true) & (ventilation_vent' = true) & (counter_vent' = 0);
    [t] (s_vent=1) & ((ouput_controller & (ventilation_controller = false))) -> (s_vent'=2) & (output_vent'=false) & (counter_vent' = (counter_vent < 5) ? (counter_vent + 1) : counter_vent);
    [t] (s_vent=2) & (((ouput_controller = false) | (ventilation_controller = false)) & (counter_vent = 5)) -> (s_vent'=0) & (output_vent'=true) & (ventilation_vent' = false) & (counter_vent' = 0);
    [t] (s_vent=2) & ((ouput_controller & ventilation_controller)) -> (s_vent'=1) & (output_vent'=true) & (ventilation_vent' = true) & (counter_vent' = 0);
    [t] (s_vent=2) & (((ouput_controller = false) | (ventilation_controller = false)) & (counter_vent != 5)) -> (s_vent'=2) & (output_vent'=false) & (counter_vent' = (counter_vent < 5) ? (counter_vent + 1) : counter_vent);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_vent=0) & (((ouput_controller = false) | (ventilation_controller = false))) -> (s_vent'=0) & (output_vent'=false);
    [t] (s_vent=1) & (((ouput_controller = false) | (ventilation_controller = true))) -> (s_vent'=1) & (output_vent'=false);
endmodule


module controller
    s_controller : [-1..1] init -1;
    //s_controller=0 - START
    //s_controller=1 - DETECT

    //Generated from output events
    ouput_controller : bool init false;

    //Generated from internal and output variables
    ventilation_controller : bool init false;

    [t] (s_controller=-1) -> (s_controller'=0) & (ouput_controller'=false);
    [t] (s_controller=0) & ((((output_sensor1 | output_sensor2)) = true)) -> (s_controller'=1) & (ouput_controller'=true) & (ventilation_controller' = (outValue_sensor1 | outValue_sensor2));
    [t] (s_controller=1) & ((((output_sensor1 | output_sensor2)) = true)) -> (s_controller'=1) & (ouput_controller'=true) & (ventilation_controller' = (outValue_sensor1 | outValue_sensor2));

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_controller=0) & ((((output_sensor1 | output_sensor2)) = false)) -> (s_controller'=0) & (ouput_controller'=false);
    [t] (s_controller=1) & ((((output_sensor1 | output_sensor2)) = false)) -> (s_controller'=1) & (ouput_controller'=false);
endmodule


module observer
    s_observer : [-1..2] init -1;
    //s_observer=0 - IDLE
    //s_observer=1 - SHOULDVENT
    //s_observer=2 - Violation

    //Generated from internal and output variables
    counter_observer : [0..5] init 0;

    [t] (s_observer=-1) -> (s_observer'=0) & (counter_observer' = 0);
    [t] (s_observer=0) & ((gasValue_source >= PARAM_threshold_observer)) -> (s_observer'=1) & (counter_observer' = (counter_observer < 5) ? (counter_observer + 1) : counter_observer);
    [t] (s_observer=1) & ((gasValue_source >= PARAM_threshold_observer) & ((counter_observer != 5) | (ventilation_vent = true)) & ((counter_observer < 5) & (ventilation_vent = false))) -> (s_observer'=1) & (counter_observer' = (counter_observer < 5) ? (counter_observer + 1) : counter_observer);
    [t] (s_observer=1) & ((gasValue_source >= PARAM_threshold_observer) & ((counter_observer = 5) & (ventilation_vent = false))) -> (s_observer'=2);
    [t] (s_observer=1) & ((gasValue_source < PARAM_threshold_observer)) -> (s_observer'=0) & (counter_observer' = 0);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_observer=0) & ((gasValue_source < PARAM_threshold_observer)) -> (s_observer'=0);
    [t] (s_observer=1) & ((gasValue_source >= PARAM_threshold_observer) & ((counter_observer != 5) | (ventilation_vent = true)) & ((counter_observer >= 5) | (ventilation_vent = true))) -> (s_observer'=1);
    [t] (s_observer=2) -> (s_observer'=2);
endmodule



