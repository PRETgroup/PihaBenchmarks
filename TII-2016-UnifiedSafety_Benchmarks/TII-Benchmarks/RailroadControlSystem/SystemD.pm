mdp

const int intOpenInput = 0;
const bool boolOpenInput = false;

//state labels
label "Violation_observer" = (s_observer=2);


module controller
    s_controller : [-1..1] init -1;
    //s_controller=0 - RAISE
    //s_controller=1 - LOWER

    //Generated from output events
    raise_controller : bool init false;
    lower_controller : bool init false;

    [t] (s_controller=-1) -> (s_controller'=0) & (raise_controller'=true) & (lower_controller'=false);
    [t] (s_controller=0) & ((((inR_track1_trainTracks | inR_track0_trainTracks | inR_track2_trainTracks)) = true)) -> (s_controller'=1) & (lower_controller'=true) & (raise_controller'=false);
    [t] (s_controller=0) & ((((inR_track1_trainTracks | inR_track0_trainTracks | inR_track2_trainTracks)) = false) & (((inI_track1_trainTracks | inI_track0_trainTracks | inI_track2_trainTracks)) = true)) -> (s_controller'=1) & (lower_controller'=true) & (raise_controller'=false);
    [t] (s_controller=1) & ((((inR_track1_trainTracks | inR_track0_trainTracks | inR_track2_trainTracks)) = false) & (((inI_track1_trainTracks | inI_track0_trainTracks | inI_track2_trainTracks)) = false) & (((exited_track0_trainTracks | exited_track1_trainTracks | exited_track2_trainTracks)) = true)) -> (s_controller'=0) & (raise_controller'=true) & (lower_controller'=false);
    [t] (s_controller=1) & ((((inR_track1_trainTracks | inR_track0_trainTracks | inR_track2_trainTracks)) = true)) -> (s_controller'=1) & (lower_controller'=true) & (raise_controller'=false);
    [t] (s_controller=1) & ((((inR_track1_trainTracks | inR_track0_trainTracks | inR_track2_trainTracks)) = false) & (((inI_track1_trainTracks | inI_track0_trainTracks | inI_track2_trainTracks)) = true)) -> (s_controller'=1) & (lower_controller'=true) & (raise_controller'=false);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_controller=0) & ((((inR_track1_trainTracks | inR_track0_trainTracks | inR_track2_trainTracks)) = false) & (((inI_track1_trainTracks | inI_track0_trainTracks | inI_track2_trainTracks)) = false)) -> (s_controller'=0) & (raise_controller'=false) & (lower_controller'=false);
    [t] (s_controller=1) & ((((inR_track1_trainTracks | inR_track0_trainTracks | inR_track2_trainTracks)) = false) & (((inI_track1_trainTracks | inI_track0_trainTracks | inI_track2_trainTracks)) = false) & (((exited_track0_trainTracks | exited_track1_trainTracks | exited_track2_trainTracks)) = false)) -> (s_controller'=1) & (raise_controller'=false) & (lower_controller'=false);
endmodule


module trains_trainTracks
    s_trains_trainTracks : [-1..7] init -1;
    //s_trains_trainTracks=0 - ABSENT
    //s_trains_trainTracks=1 - APPROACHING0
    //s_trains_trainTracks=2 - APPROACHING1
    //s_trains_trainTracks=3 - APPROACHING2
    //s_trains_trainTracks=4 - APPROACHING0_1
    //s_trains_trainTracks=5 - BOTHEXITED
    //s_trains_trainTracks=6 - E0
    //s_trains_trainTracks=7 - E1

    //Generated from output events
    approaching1_trains_trainTracks : bool init false;
    approaching2_trains_trainTracks : bool init false;
    approaching0_trains_trainTracks : bool init false;

    [t] (s_trains_trainTracks=-1) -> (s_trains_trainTracks'=0) & (approaching1_trains_trainTracks'=false) & (approaching2_trains_trainTracks'=false) & (approaching0_trains_trainTracks'=false);
    [t] (s_trains_trainTracks=1) & ((exited_track0_trainTracks = true)) -> (s_trains_trainTracks'=2) & (approaching1_trains_trainTracks'=true) & (approaching2_trains_trainTracks'=false) & (approaching0_trains_trainTracks'=false);
    [t] (s_trains_trainTracks=2) & ((exited_track1_trainTracks = true)) -> (s_trains_trainTracks'=3) & (approaching2_trains_trainTracks'=true) & (approaching1_trains_trainTracks'=false) & (approaching0_trains_trainTracks'=false);
    [t] (s_trains_trainTracks=3) & ((exited_track2_trainTracks = true)) -> (s_trains_trainTracks'=4) & (approaching0_trains_trainTracks'=true) & (approaching1_trains_trainTracks'=true) & (approaching2_trains_trainTracks'=false);
    [t] (s_trains_trainTracks=0) -> (s_trains_trainTracks'=1) & (approaching0_trains_trainTracks'=true) & (approaching1_trains_trainTracks'=false) & (approaching2_trains_trainTracks'=false);
    [t] (s_trains_trainTracks=4) & (((exited_track0_trainTracks = false) | (exited_track1_trainTracks = false)) & (exited_track0_trainTracks = true)) -> (s_trains_trainTracks'=6) & (approaching1_trains_trainTracks'=false) & (approaching2_trains_trainTracks'=false) & (approaching0_trains_trainTracks'=false);
    [t] (s_trains_trainTracks=4) & (((exited_track0_trainTracks = false) | (exited_track1_trainTracks = false)) & (exited_track0_trainTracks = false) & (exited_track1_trainTracks = true)) -> (s_trains_trainTracks'=7) & (approaching1_trains_trainTracks'=false) & (approaching2_trains_trainTracks'=false) & (approaching0_trains_trainTracks'=false);
    [t] (s_trains_trainTracks=7) & ((exited_track0_trainTracks = true)) -> (s_trains_trainTracks'=5) & (approaching1_trains_trainTracks'=false) & (approaching2_trains_trainTracks'=false) & (approaching0_trains_trainTracks'=false);
    [t] (s_trains_trainTracks=6) & ((exited_track1_trainTracks = true)) -> (s_trains_trainTracks'=5) & (approaching1_trains_trainTracks'=false) & (approaching2_trains_trainTracks'=false) & (approaching0_trains_trainTracks'=false);
    [t] (s_trains_trainTracks=4) & ((exited_track0_trainTracks & exited_track1_trainTracks)) -> (s_trains_trainTracks'=5) & (approaching1_trains_trainTracks'=false) & (approaching2_trains_trainTracks'=false) & (approaching0_trains_trainTracks'=false);
    [t] (s_trains_trainTracks=5) -> (s_trains_trainTracks'=0) & (approaching1_trains_trainTracks'=false) & (approaching2_trains_trainTracks'=false) & (approaching0_trains_trainTracks'=false);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_trains_trainTracks=1) & ((exited_track0_trainTracks = false)) -> (s_trains_trainTracks'=1) & (approaching1_trains_trainTracks'=false) & (approaching2_trains_trainTracks'=false) & (approaching0_trains_trainTracks'=false);
    [t] (s_trains_trainTracks=2) & ((exited_track1_trainTracks = false)) -> (s_trains_trainTracks'=2) & (approaching1_trains_trainTracks'=false) & (approaching2_trains_trainTracks'=false) & (approaching0_trains_trainTracks'=false);
    [t] (s_trains_trainTracks=3) & ((exited_track2_trainTracks = false)) -> (s_trains_trainTracks'=3) & (approaching1_trains_trainTracks'=false) & (approaching2_trains_trainTracks'=false) & (approaching0_trains_trainTracks'=false);
    [t] (s_trains_trainTracks=4) & (((exited_track0_trainTracks = false) | (exited_track1_trainTracks = false)) & (exited_track0_trainTracks = false) & (exited_track1_trainTracks = false)) -> (s_trains_trainTracks'=4) & (approaching1_trains_trainTracks'=false) & (approaching2_trains_trainTracks'=false) & (approaching0_trains_trainTracks'=false);
    [t] (s_trains_trainTracks=6) & ((exited_track1_trainTracks = false)) -> (s_trains_trainTracks'=6) & (approaching1_trains_trainTracks'=false) & (approaching2_trains_trainTracks'=false) & (approaching0_trains_trainTracks'=false);
    [t] (s_trains_trainTracks=7) & ((exited_track0_trainTracks = false)) -> (s_trains_trainTracks'=7) & (approaching1_trains_trainTracks'=false) & (approaching2_trains_trainTracks'=false) & (approaching0_trains_trainTracks'=false);
endmodule


module track0_trainTracks
    s_track0_trainTracks : [-1..5] init -1;
    //s_track0_trainTracks=0 - START
    //s_track0_trainTracks=1 - ENTER_R
    //s_track0_trainTracks=2 - IN_R
    //s_track0_trainTracks=3 - ENTER_I
    //s_track0_trainTracks=4 - IN_I
    //s_track0_trainTracks=5 - EXIT

    //Generated from output events
    enterR_track0_trainTracks : bool init false;
    enterI_track0_trainTracks : bool init false;
    inR_track0_trainTracks : bool init false;
    inI_track0_trainTracks : bool init false;
    exited_track0_trainTracks : bool init false;

    //Generated from internal and output variables
    counter_track0_trainTracks : [0..5] init 0;

    [t] (s_track0_trainTracks=-1) -> (s_track0_trainTracks'=0) & (enterR_track0_trainTracks'=false) & (enterI_track0_trainTracks'=false) & (inR_track0_trainTracks'=false) & (inI_track0_trainTracks'=false) & (exited_track0_trainTracks'=false);
    [t] (s_track0_trainTracks=0) & ((approaching0_trains_trainTracks = true)) -> (s_track0_trainTracks'=1) & (enterR_track0_trainTracks'=true) & (inR_track0_trainTracks'=true) & (enterI_track0_trainTracks'=false) & (inI_track0_trainTracks'=false) & (exited_track0_trainTracks'=false) & (counter_track0_trainTracks' = 0);
    [t] (s_track0_trainTracks=1) -> (s_track0_trainTracks'=2) & (inR_track0_trainTracks'=true) & (enterR_track0_trainTracks'=false) & (enterI_track0_trainTracks'=false) & (inI_track0_trainTracks'=false) & (exited_track0_trainTracks'=false) & (counter_track0_trainTracks' = (counter_track0_trainTracks < 5) ? (counter_track0_trainTracks + 1) : counter_track0_trainTracks);
    [t] (s_track0_trainTracks=2) & ((counter_track0_trainTracks = 5)) -> (s_track0_trainTracks'=3) & (enterI_track0_trainTracks'=true) & (enterR_track0_trainTracks'=false) & (inR_track0_trainTracks'=false) & (inI_track0_trainTracks'=false) & (exited_track0_trainTracks'=false) & (counter_track0_trainTracks' = 0);
    [t] (s_track0_trainTracks=3) -> (s_track0_trainTracks'=4) & (inI_track0_trainTracks'=true) & (enterR_track0_trainTracks'=false) & (enterI_track0_trainTracks'=false) & (inR_track0_trainTracks'=false) & (exited_track0_trainTracks'=false) & (counter_track0_trainTracks' = (counter_track0_trainTracks < 5) ? (counter_track0_trainTracks + 1) : counter_track0_trainTracks);
    [t] (s_track0_trainTracks=4) & ((counter_track0_trainTracks = 3)) -> (s_track0_trainTracks'=5) & (exited_track0_trainTracks'=true) & (enterR_track0_trainTracks'=false) & (enterI_track0_trainTracks'=false) & (inR_track0_trainTracks'=false) & (inI_track0_trainTracks'=false);
    [t] (s_track0_trainTracks=5) & ((approaching0_trains_trainTracks = true)) -> (s_track0_trainTracks'=1) & (enterR_track0_trainTracks'=true) & (inR_track0_trainTracks'=true) & (enterI_track0_trainTracks'=false) & (inI_track0_trainTracks'=false) & (exited_track0_trainTracks'=false) & (counter_track0_trainTracks' = 0);
    [t] (s_track0_trainTracks=2) & ((counter_track0_trainTracks != 5)) -> (s_track0_trainTracks'=2) & (inR_track0_trainTracks'=true) & (enterR_track0_trainTracks'=false) & (enterI_track0_trainTracks'=false) & (inI_track0_trainTracks'=false) & (exited_track0_trainTracks'=false) & (counter_track0_trainTracks' = (counter_track0_trainTracks < 5) ? (counter_track0_trainTracks + 1) : counter_track0_trainTracks);
    [t] (s_track0_trainTracks=4) & ((counter_track0_trainTracks != 3)) -> (s_track0_trainTracks'=4) & (inI_track0_trainTracks'=true) & (enterR_track0_trainTracks'=false) & (enterI_track0_trainTracks'=false) & (inR_track0_trainTracks'=false) & (exited_track0_trainTracks'=false) & (counter_track0_trainTracks' = (counter_track0_trainTracks < 5) ? (counter_track0_trainTracks + 1) : counter_track0_trainTracks);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_track0_trainTracks=0) & ((approaching0_trains_trainTracks = false)) -> (s_track0_trainTracks'=0) & (enterR_track0_trainTracks'=false) & (enterI_track0_trainTracks'=false) & (inR_track0_trainTracks'=false) & (inI_track0_trainTracks'=false) & (exited_track0_trainTracks'=false);
    [t] (s_track0_trainTracks=5) & ((approaching0_trains_trainTracks = false)) -> (s_track0_trainTracks'=5) & (enterR_track0_trainTracks'=false) & (enterI_track0_trainTracks'=false) & (inR_track0_trainTracks'=false) & (inI_track0_trainTracks'=false) & (exited_track0_trainTracks'=false);
endmodule


module track2_trainTracks
    s_track2_trainTracks : [-1..5] init -1;
    //s_track2_trainTracks=0 - START
    //s_track2_trainTracks=1 - ENTER_R
    //s_track2_trainTracks=2 - IN_R
    //s_track2_trainTracks=3 - ENTER_I
    //s_track2_trainTracks=4 - IN_I
    //s_track2_trainTracks=5 - EXIT

    //Generated from output events
    enterR_track2_trainTracks : bool init false;
    enterI_track2_trainTracks : bool init false;
    inR_track2_trainTracks : bool init false;
    inI_track2_trainTracks : bool init false;
    exited_track2_trainTracks : bool init false;

    //Generated from internal and output variables
    counter_track2_trainTracks : [0..5] init 0;

    [t] (s_track2_trainTracks=-1) -> (s_track2_trainTracks'=0) & (enterR_track2_trainTracks'=false) & (enterI_track2_trainTracks'=false) & (inR_track2_trainTracks'=false) & (inI_track2_trainTracks'=false) & (exited_track2_trainTracks'=false);
    [t] (s_track2_trainTracks=0) & ((approaching2_trains_trainTracks = true)) -> (s_track2_trainTracks'=1) & (enterR_track2_trainTracks'=true) & (inR_track2_trainTracks'=true) & (enterI_track2_trainTracks'=false) & (inI_track2_trainTracks'=false) & (exited_track2_trainTracks'=false) & (counter_track2_trainTracks' = 0);
    [t] (s_track2_trainTracks=1) -> (s_track2_trainTracks'=2) & (inR_track2_trainTracks'=true) & (enterR_track2_trainTracks'=false) & (enterI_track2_trainTracks'=false) & (inI_track2_trainTracks'=false) & (exited_track2_trainTracks'=false) & (counter_track2_trainTracks' = (counter_track2_trainTracks < 5) ? (counter_track2_trainTracks + 1) : counter_track2_trainTracks);
    [t] (s_track2_trainTracks=2) & ((counter_track2_trainTracks = 5)) -> (s_track2_trainTracks'=3) & (enterI_track2_trainTracks'=true) & (enterR_track2_trainTracks'=false) & (inR_track2_trainTracks'=false) & (inI_track2_trainTracks'=false) & (exited_track2_trainTracks'=false) & (counter_track2_trainTracks' = 0);
    [t] (s_track2_trainTracks=3) -> (s_track2_trainTracks'=4) & (inI_track2_trainTracks'=true) & (enterR_track2_trainTracks'=false) & (enterI_track2_trainTracks'=false) & (inR_track2_trainTracks'=false) & (exited_track2_trainTracks'=false) & (counter_track2_trainTracks' = (counter_track2_trainTracks < 5) ? (counter_track2_trainTracks + 1) : counter_track2_trainTracks);
    [t] (s_track2_trainTracks=4) & ((counter_track2_trainTracks = 3)) -> (s_track2_trainTracks'=5) & (exited_track2_trainTracks'=true) & (enterR_track2_trainTracks'=false) & (enterI_track2_trainTracks'=false) & (inR_track2_trainTracks'=false) & (inI_track2_trainTracks'=false);
    [t] (s_track2_trainTracks=5) & ((approaching2_trains_trainTracks = true)) -> (s_track2_trainTracks'=1) & (enterR_track2_trainTracks'=true) & (inR_track2_trainTracks'=true) & (enterI_track2_trainTracks'=false) & (inI_track2_trainTracks'=false) & (exited_track2_trainTracks'=false) & (counter_track2_trainTracks' = 0);
    [t] (s_track2_trainTracks=2) & ((counter_track2_trainTracks != 5)) -> (s_track2_trainTracks'=2) & (inR_track2_trainTracks'=true) & (enterR_track2_trainTracks'=false) & (enterI_track2_trainTracks'=false) & (inI_track2_trainTracks'=false) & (exited_track2_trainTracks'=false) & (counter_track2_trainTracks' = (counter_track2_trainTracks < 5) ? (counter_track2_trainTracks + 1) : counter_track2_trainTracks);
    [t] (s_track2_trainTracks=4) & ((counter_track2_trainTracks != 3)) -> (s_track2_trainTracks'=4) & (inI_track2_trainTracks'=true) & (enterR_track2_trainTracks'=false) & (enterI_track2_trainTracks'=false) & (inR_track2_trainTracks'=false) & (exited_track2_trainTracks'=false) & (counter_track2_trainTracks' = (counter_track2_trainTracks < 5) ? (counter_track2_trainTracks + 1) : counter_track2_trainTracks);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_track2_trainTracks=0) & ((approaching2_trains_trainTracks = false)) -> (s_track2_trainTracks'=0) & (enterR_track2_trainTracks'=false) & (enterI_track2_trainTracks'=false) & (inR_track2_trainTracks'=false) & (inI_track2_trainTracks'=false) & (exited_track2_trainTracks'=false);
    [t] (s_track2_trainTracks=5) & ((approaching2_trains_trainTracks = false)) -> (s_track2_trainTracks'=5) & (enterR_track2_trainTracks'=false) & (enterI_track2_trainTracks'=false) & (inR_track2_trainTracks'=false) & (inI_track2_trainTracks'=false) & (exited_track2_trainTracks'=false);
endmodule


module track1_trainTracks
    s_track1_trainTracks : [-1..5] init -1;
    //s_track1_trainTracks=0 - START
    //s_track1_trainTracks=1 - ENTER_R
    //s_track1_trainTracks=2 - IN_R
    //s_track1_trainTracks=3 - ENTER_I
    //s_track1_trainTracks=4 - IN_I
    //s_track1_trainTracks=5 - EXIT

    //Generated from output events
    enterR_track1_trainTracks : bool init false;
    enterI_track1_trainTracks : bool init false;
    inR_track1_trainTracks : bool init false;
    inI_track1_trainTracks : bool init false;
    exited_track1_trainTracks : bool init false;

    //Generated from internal and output variables
    counter_track1_trainTracks : [0..5] init 0;

    [t] (s_track1_trainTracks=-1) -> (s_track1_trainTracks'=0) & (enterR_track1_trainTracks'=false) & (enterI_track1_trainTracks'=false) & (inR_track1_trainTracks'=false) & (inI_track1_trainTracks'=false) & (exited_track1_trainTracks'=false);
    [t] (s_track1_trainTracks=0) & ((approaching1_trains_trainTracks = true)) -> (s_track1_trainTracks'=1) & (enterR_track1_trainTracks'=true) & (inR_track1_trainTracks'=true) & (enterI_track1_trainTracks'=false) & (inI_track1_trainTracks'=false) & (exited_track1_trainTracks'=false) & (counter_track1_trainTracks' = 0);
    [t] (s_track1_trainTracks=1) -> (s_track1_trainTracks'=2) & (inR_track1_trainTracks'=true) & (enterR_track1_trainTracks'=false) & (enterI_track1_trainTracks'=false) & (inI_track1_trainTracks'=false) & (exited_track1_trainTracks'=false) & (counter_track1_trainTracks' = (counter_track1_trainTracks < 5) ? (counter_track1_trainTracks + 1) : counter_track1_trainTracks);
    [t] (s_track1_trainTracks=2) & ((counter_track1_trainTracks = 5)) -> (s_track1_trainTracks'=3) & (enterI_track1_trainTracks'=true) & (enterR_track1_trainTracks'=false) & (inR_track1_trainTracks'=false) & (inI_track1_trainTracks'=false) & (exited_track1_trainTracks'=false) & (counter_track1_trainTracks' = 0);
    [t] (s_track1_trainTracks=3) -> (s_track1_trainTracks'=4) & (inI_track1_trainTracks'=true) & (enterR_track1_trainTracks'=false) & (enterI_track1_trainTracks'=false) & (inR_track1_trainTracks'=false) & (exited_track1_trainTracks'=false) & (counter_track1_trainTracks' = (counter_track1_trainTracks < 5) ? (counter_track1_trainTracks + 1) : counter_track1_trainTracks);
    [t] (s_track1_trainTracks=4) & ((counter_track1_trainTracks = 3)) -> (s_track1_trainTracks'=5) & (exited_track1_trainTracks'=true) & (enterR_track1_trainTracks'=false) & (enterI_track1_trainTracks'=false) & (inR_track1_trainTracks'=false) & (inI_track1_trainTracks'=false);
    [t] (s_track1_trainTracks=5) & ((approaching1_trains_trainTracks = true)) -> (s_track1_trainTracks'=1) & (enterR_track1_trainTracks'=true) & (inR_track1_trainTracks'=true) & (enterI_track1_trainTracks'=false) & (inI_track1_trainTracks'=false) & (exited_track1_trainTracks'=false) & (counter_track1_trainTracks' = 0);
    [t] (s_track1_trainTracks=2) & ((counter_track1_trainTracks != 5)) -> (s_track1_trainTracks'=2) & (inR_track1_trainTracks'=true) & (enterR_track1_trainTracks'=false) & (enterI_track1_trainTracks'=false) & (inI_track1_trainTracks'=false) & (exited_track1_trainTracks'=false) & (counter_track1_trainTracks' = (counter_track1_trainTracks < 5) ? (counter_track1_trainTracks + 1) : counter_track1_trainTracks);
    [t] (s_track1_trainTracks=4) & ((counter_track1_trainTracks != 3)) -> (s_track1_trainTracks'=4) & (inI_track1_trainTracks'=true) & (enterR_track1_trainTracks'=false) & (enterI_track1_trainTracks'=false) & (inR_track1_trainTracks'=false) & (exited_track1_trainTracks'=false) & (counter_track1_trainTracks' = (counter_track1_trainTracks < 5) ? (counter_track1_trainTracks + 1) : counter_track1_trainTracks);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_track1_trainTracks=0) & ((approaching1_trains_trainTracks = false)) -> (s_track1_trainTracks'=0) & (enterR_track1_trainTracks'=false) & (enterI_track1_trainTracks'=false) & (inR_track1_trainTracks'=false) & (inI_track1_trainTracks'=false) & (exited_track1_trainTracks'=false);
    [t] (s_track1_trainTracks=5) & ((approaching1_trains_trainTracks = false)) -> (s_track1_trainTracks'=5) & (enterR_track1_trainTracks'=false) & (enterI_track1_trainTracks'=false) & (inR_track1_trainTracks'=false) & (inI_track1_trainTracks'=false) & (exited_track1_trainTracks'=false);
endmodule


module gate
    s_gate : [-1..3] init -1;
    //s_gate=0 - DOWN
    //s_gate=1 - GOINGUP
    //s_gate=2 - GOINGDOWN
    //s_gate=3 - UP

    //Generated from output events
    status_gate : bool init false;

    //Generated from internal and output variables
    down_gate : bool init false;
    up_gate : bool init false;
    goingDown_gate : bool init false;
    goingUp_gate : bool init false;
    upCounter_gate : [0..5] init 0;
    downCounter_gate : [0..5] init 0;

    [t] (s_gate=-1) -> (s_gate'=0) & (status_gate'=true) & (down_gate' = true) & (up_gate' = false) & (goingUp_gate' = false) & (goingDown_gate' = false) & (downCounter_gate' = 0) & (upCounter_gate' = 0);
    [t] (s_gate=0) & ((raise_controller = true)) -> (s_gate'=1) & (status_gate'=true) & (down_gate' = false) & (up_gate' = false) & (goingUp_gate' = true) & (goingDown_gate' = false) & (downCounter_gate' = 0) & (upCounter_gate' = (upCounter_gate < 5) ? (upCounter_gate + 1) : upCounter_gate);
    [t] (s_gate=1) & ((lower_controller = false) & (upCounter_gate != 3)) -> (s_gate'=1) & (status_gate'=true) & (down_gate' = false) & (up_gate' = false) & (goingUp_gate' = true) & (goingDown_gate' = false) & (downCounter_gate' = 0) & (upCounter_gate' = (upCounter_gate < 5) ? (upCounter_gate + 1) : upCounter_gate);
    [t] (s_gate=1) & ((lower_controller = true)) -> (s_gate'=2) & (status_gate'=true) & (down_gate' = false) & (up_gate' = false) & (goingUp_gate' = false) & (goingDown_gate' = true) & (upCounter_gate' = 0) & (downCounter_gate' = (downCounter_gate < 5) ? (downCounter_gate + 1) : downCounter_gate);
    [t] (s_gate=2) & ((raise_controller = true)) -> (s_gate'=1) & (status_gate'=true) & (down_gate' = false) & (up_gate' = false) & (goingUp_gate' = true) & (goingDown_gate' = false) & (downCounter_gate' = 0) & (upCounter_gate' = (upCounter_gate < 5) ? (upCounter_gate + 1) : upCounter_gate);
    [t] (s_gate=2) & ((raise_controller = false) & (downCounter_gate != 3)) -> (s_gate'=2) & (status_gate'=true) & (down_gate' = false) & (up_gate' = false) & (goingUp_gate' = false) & (goingDown_gate' = true) & (upCounter_gate' = 0) & (downCounter_gate' = (downCounter_gate < 5) ? (downCounter_gate + 1) : downCounter_gate);
    [t] (s_gate=3) & ((lower_controller = true)) -> (s_gate'=2) & (status_gate'=true) & (down_gate' = false) & (up_gate' = false) & (goingUp_gate' = false) & (goingDown_gate' = true) & (upCounter_gate' = 0) & (downCounter_gate' = (downCounter_gate < 5) ? (downCounter_gate + 1) : downCounter_gate);
    [t] (s_gate=1) & ((lower_controller = false) & (upCounter_gate = 3)) -> (s_gate'=3) & (status_gate'=true) & (down_gate' = false) & (up_gate' = true) & (goingUp_gate' = false) & (goingDown_gate' = false) & (downCounter_gate' = 0) & (upCounter_gate' = 0);
    [t] (s_gate=2) & ((raise_controller = false) & (downCounter_gate = 3)) -> (s_gate'=0) & (status_gate'=true) & (down_gate' = true) & (up_gate' = false) & (goingUp_gate' = false) & (goingDown_gate' = false) & (downCounter_gate' = 0) & (upCounter_gate' = 0);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_gate=0) & ((raise_controller = false)) -> (s_gate'=0) & (status_gate'=false);
    [t] (s_gate=3) & ((lower_controller = false)) -> (s_gate'=3) & (status_gate'=false);
endmodule


module observer
    s_observer : [-1..6] init -1;
    //s_observer=0 - OUT
    //s_observer=1 - ENTER
    //s_observer=2 - Violation
    //s_observer=3 - GOINGDOWN
    //s_observer=4 - DOWN
    //s_observer=5 - APPROACH
    //s_observer=6 - SHOULDLOWER

    [t] (s_observer=-1) -> (s_observer'=0);
    [t] (s_observer=3) & ((((exited_track0_trainTracks | exited_track1_trainTracks | exited_track2_trainTracks)) = true)) -> (s_observer'=0);
    [t] (s_observer=3) & ((((exited_track0_trainTracks | exited_track1_trainTracks | exited_track2_trainTracks)) = false) & (goingDown_gate = true)) -> (s_observer'=3);
    [t] (s_observer=3) & ((((exited_track0_trainTracks | exited_track1_trainTracks | exited_track2_trainTracks)) = false) & (goingDown_gate = false) & (down_gate = false)) -> (s_observer'=2);
    [t] (s_observer=4) & ((((exited_track0_trainTracks | exited_track1_trainTracks | exited_track2_trainTracks)) = false) & (down_gate = true)) -> (s_observer'=4);
    [t] (s_observer=4) & ((((exited_track0_trainTracks | exited_track1_trainTracks | exited_track2_trainTracks)) = true)) -> (s_observer'=0);
    [t] (s_observer=3) & ((((exited_track0_trainTracks | exited_track1_trainTracks | exited_track2_trainTracks)) = false) & (goingDown_gate = false) & (down_gate = true)) -> (s_observer'=4);
    [t] (s_observer=4) & ((((exited_track0_trainTracks | exited_track1_trainTracks | exited_track2_trainTracks)) = false) & (down_gate = false)) -> (s_observer'=2);
    [t] (s_observer=0) & ((((approaching0_trains_trainTracks | approaching1_trains_trainTracks | approaching2_trains_trainTracks)) = true)) -> (s_observer'=5);
    [t] (s_observer=5) -> (s_observer'=1);
    [t] (s_observer=1) -> (s_observer'=6);
    [t] (s_observer=6) & ((goingDown_gate | down_gate)) -> (s_observer'=3);
    [t] (s_observer=6) & (((goingDown_gate = false) & (down_gate = false))) -> (s_observer'=2);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_observer=0) & ((((approaching0_trains_trainTracks | approaching1_trains_trainTracks | approaching2_trains_trainTracks)) = false)) -> (s_observer'=0);
    [t] (s_observer=2) -> (s_observer'=2);
endmodule



