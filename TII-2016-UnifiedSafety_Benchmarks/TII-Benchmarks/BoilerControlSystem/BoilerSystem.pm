mdp

const int intOpenInput = 0;
const bool boolOpenInput = false;

//parameter list
const int PARAM_threshold_controller = 300;

const int PARAM_threshold_observer = 300;

//state labels
label "Violation_observer" = (s_observer=1);


module flow_1oo2
    s_flow_1oo2 : [-1..2] init -1;
    //s_flow_1oo2=0 - IDLE
    //s_flow_1oo2=1 - INPUT1
    //s_flow_1oo2=2 - INPUT2

    //Generated from output events
    output_flow_1oo2 : bool init false;

    //Generated from internal and output variables
    oValue_flow_1oo2 : bool init false;

    [t] (s_flow_1oo2=-1) -> (s_flow_1oo2'=0) & (output_flow_1oo2'=false);
    [t] (s_flow_1oo2=0) & ((output_compFI_1 = true)) -> (s_flow_1oo2'=1) & (output_flow_1oo2'=true) & (oValue_flow_1oo2' = oValue_compFI_1);
    [t] (s_flow_1oo2=0) & ((output_compFI_1 = false) & (output_compFI_2 = true)) -> (s_flow_1oo2'=2) & (output_flow_1oo2'=true) & (oValue_flow_1oo2' = oValue_compFI_2);
    [t] (s_flow_1oo2=1) & ((output_compFI_2 = true)) -> (s_flow_1oo2'=2) & (output_flow_1oo2'=true) & (oValue_flow_1oo2' = oValue_compFI_2);
    [t] (s_flow_1oo2=2) & ((output_compFI_1 = true)) -> (s_flow_1oo2'=1) & (output_flow_1oo2'=true) & (oValue_flow_1oo2' = oValue_compFI_1);
    [t] (s_flow_1oo2=2) & ((output_compFI_1 = false) & (output_compFI_2 = true)) -> (s_flow_1oo2'=2) & (output_flow_1oo2'=true) & (oValue_flow_1oo2' = oValue_compFI_2);
    [t] (s_flow_1oo2=1) & ((output_compFI_2 = false) & (output_compFI_1 = true)) -> (s_flow_1oo2'=1) & (output_flow_1oo2'=true) & (oValue_flow_1oo2' = oValue_compFI_1);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_flow_1oo2=0) & ((output_compFI_1 = false) & (output_compFI_2 = false)) -> (s_flow_1oo2'=0) & (output_flow_1oo2'=false);
    [t] (s_flow_1oo2=1) & ((output_compFI_2 = false) & (output_compFI_1 = false)) -> (s_flow_1oo2'=1) & (output_flow_1oo2'=false);
    [t] (s_flow_1oo2=2) & ((output_compFI_1 = false) & (output_compFI_2 = false)) -> (s_flow_1oo2'=2) & (output_flow_1oo2'=false);
endmodule


module compFI_1
    s_compFI_1 : [-1..1] init -1;
    //s_compFI_1=0 - START
    //s_compFI_1=1 - INPUT_REC

    //Generated from output events
    output_compFI_1 : bool init false;

    //Generated from internal and output variables
    oValue_compFI_1 : bool init false;

    [t] (s_compFI_1=-1) -> (s_compFI_1'=0) & (output_compFI_1'=false);
    [t] (s_compFI_1=0) & ((update_valve = true)) -> (s_compFI_1'=1) & (output_compFI_1'=true) & (oValue_compFI_1' = isOpen_valve);
    [t] (s_compFI_1=1) & ((update_valve = true)) -> (s_compFI_1'=1) & (output_compFI_1'=true) & (oValue_compFI_1' = isOpen_valve);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_compFI_1=0) & ((update_valve = false)) -> (s_compFI_1'=0) & (output_compFI_1'=false);
    [t] (s_compFI_1=1) & ((update_valve = false)) -> (s_compFI_1'=1) & (output_compFI_1'=false);
endmodule


module compFI_2
    s_compFI_2 : [-1..1] init -1;
    //s_compFI_2=0 - START
    //s_compFI_2=1 - INPUT_REC

    //Generated from output events
    output_compFI_2 : bool init false;

    //Generated from internal and output variables
    oValue_compFI_2 : bool init false;

    [t] (s_compFI_2=-1) -> (s_compFI_2'=0) & (output_compFI_2'=false);
    [t] (s_compFI_2=0) & ((update_valve = true)) -> (s_compFI_2'=1) & (output_compFI_2'=true) & (oValue_compFI_2' = isOpen_valve);
    [t] (s_compFI_2=1) & ((update_valve = true)) -> (s_compFI_2'=1) & (output_compFI_2'=true) & (oValue_compFI_2' = isOpen_valve);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_compFI_2=0) & ((update_valve = false)) -> (s_compFI_2'=0) & (output_compFI_2'=false);
    [t] (s_compFI_2=1) & ((update_valve = false)) -> (s_compFI_2'=1) & (output_compFI_2'=false);
endmodule


module valve
    s_valve : [-1..1] init -1;
    //s_valve=0 - CLOSED
    //s_valve=1 - OPEN

    //Generated from output events
    update_valve : bool init false;

    //Generated from internal and output variables
    isOpen_valve : bool init false;

    [t] (s_valve=-1) -> (s_valve'=0) & (update_valve'=true) & (isOpen_valve' = false);
    [t] (s_valve=0) & ((trigger_controller & valveCtl_controller)) -> (s_valve'=1) & (update_valve'=true) & (isOpen_valve' = true);
    [t] (s_valve=1) & ((trigger_controller & (valveCtl_controller = false))) -> (s_valve'=0) & (update_valve'=true) & (isOpen_valve' = false);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_valve=0) & (((trigger_controller = false) | (valveCtl_controller = false))) -> (s_valve'=0) & (update_valve'=false);
    [t] (s_valve=1) & (((trigger_controller = false) | (valveCtl_controller = true))) -> (s_valve'=1) & (update_valve'=false);
endmodule


module cylinder
    s_cylinder : [-1..1] init -1;
    //s_cylinder=0 - BUILDUP
    //s_cylinder=1 - RELIEF

    //Generated from output events
    update_cylinder : bool init false;

    //Generated from internal and output variables
    pressure_cylinder : [0..1000] init 0;

    [t] (s_cylinder=-1) -> (s_cylinder'=0) & (update_cylinder'=true) & (pressure_cylinder' = (pressure_cylinder < 990) ? (pressure_cylinder + 10) : pressure_cylinder);
    [t] (s_cylinder=0) & (((output_flow_1oo2 = false) | (isOpen_valve = false))) -> (s_cylinder'=0) & (update_cylinder'=true) & (pressure_cylinder' = (pressure_cylinder < 990) ? (pressure_cylinder + 10) : pressure_cylinder);
    [t] (s_cylinder=0) & ((output_flow_1oo2 & isOpen_valve)) -> (s_cylinder'=1) & (update_cylinder'=true) & (pressure_cylinder' = (pressure_cylinder > 10) ? (pressure_cylinder - 10) : 0);
    [t] (s_cylinder=1) & ((isOpen_valve = true)) -> (s_cylinder'=1) & (update_cylinder'=true) & (pressure_cylinder' = (pressure_cylinder > 10) ? (pressure_cylinder - 10) : 0);
    [t] (s_cylinder=1) & ((isOpen_valve = false)) -> (s_cylinder'=0) & (update_cylinder'=true) & (pressure_cylinder' = (pressure_cylinder < 990) ? (pressure_cylinder + 10) : pressure_cylinder);
endmodule


module controller
    s_controller : [-1..2] init -1;
    //s_controller=0 - CLOSED
    //s_controller=1 - OPEN
    //s_controller=2 - CHECK

    //Generated from output events
    trigger_controller : bool init false;

    //Generated from internal and output variables
    valveCtl_controller : bool init false;
    warning_controller : bool init false;

    [t] (s_controller=-1) -> (s_controller'=0) & (trigger_controller'=true) & (valveCtl_controller' = false) & (warning_controller' = false);
    [t] (s_controller=0) & ((update_cylinder & (pressure_cylinder > PARAM_threshold_controller))) -> (s_controller'=1) & (trigger_controller'=true) & (valveCtl_controller' = true);
    [t] (s_controller=2) & ((update_cylinder & (pressure_cylinder <= PARAM_threshold_controller))) -> (s_controller'=0) & (trigger_controller'=true) & (valveCtl_controller' = false) & (warning_controller' = false);
    [t] (s_controller=1) -> (s_controller'=2) & (trigger_controller'=false) & (warning_controller' = (oValue_flow_1oo2 = false));
    [t] (s_controller=2) & (((update_cylinder = false) | (pressure_cylinder > PARAM_threshold_controller))) -> (s_controller'=2) & (trigger_controller'=false) & (warning_controller' = (oValue_flow_1oo2 = false));

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_controller=0) & (((update_cylinder = false) | (pressure_cylinder <= PARAM_threshold_controller))) -> (s_controller'=0) & (trigger_controller'=false);
endmodule


module observer
    s_observer : [-1..3] init -1;
    //s_observer=0 - IDLE
    //s_observer=1 - Violation
    //s_observer=2 - REQ
    //s_observer=3 - RES

    //Generated from internal and output variables
    counter_observer : [0..100] init 0;

    [t] (s_observer=-1) -> (s_observer'=0) & (counter_observer' = 0);
    [t] (s_observer=0) & (((output_flow_1oo2 | trigger_controller | update_cylinder) & (pressure_cylinder >= PARAM_threshold_observer))) -> (s_observer'=2) & (counter_observer' = (counter_observer < 100) ? (counter_observer + 1) : counter_observer);
    [t] (s_observer=2) & ((counter_observer > 4)) -> (s_observer'=3);
    [t] (s_observer=3) & (((output_flow_1oo2 | trigger_controller | update_cylinder) & (pressure_cylinder < PARAM_threshold_observer))) -> (s_observer'=0) & (counter_observer' = 0);
    [t] (s_observer=3) & (((((output_flow_1oo2 | trigger_controller | update_cylinder)) = false) | (pressure_cylinder >= PARAM_threshold_observer)) & ((((output_flow_1oo2 | trigger_controller | update_cylinder)) = false) | ((oValue_flow_1oo2 = false) & (warning_controller = false)))) -> (s_observer'=1);
    [t] (s_observer=2) & ((counter_observer <= 4)) -> (s_observer'=2) & (counter_observer' = (counter_observer < 100) ? (counter_observer + 1) : counter_observer);
    [t] (s_observer=3) & (((((output_flow_1oo2 | trigger_controller | update_cylinder)) = false) | (pressure_cylinder >= PARAM_threshold_observer)) & ((output_flow_1oo2 | trigger_controller | update_cylinder) & (oValue_flow_1oo2 | warning_controller))) -> (s_observer'=3);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_observer=0) & (((((output_flow_1oo2 | trigger_controller | update_cylinder)) = false) | (pressure_cylinder < PARAM_threshold_observer))) -> (s_observer'=0);
    [t] (s_observer=1) -> (s_observer'=1);
endmodule



