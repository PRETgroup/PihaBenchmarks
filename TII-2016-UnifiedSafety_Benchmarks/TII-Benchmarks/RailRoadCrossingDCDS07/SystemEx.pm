mdp

const int intOpenInput = 0;
const bool boolOpenInput = false;

//state labels
label "Violation_observer" = (s_observer=1);


module crossing
    s_crossing : [-1..1] init -1;
    //s_crossing=0 - OPEN
    //s_crossing=1 - CLOSE

    //Generated from output events
    closed_crossing : bool init false;

    [t] (s_crossing=-1) -> (s_crossing'=0) & (closed_crossing'=false);
    [t] (s_crossing=0) & (s_crossing_fail=0) & ((snd_d1_transmit = true)) -> (s_crossing'=1) & (closed_crossing'=true);
    [t] (s_crossing=1) & (s_crossing_fail=0) & ((snd_d2_transmit = true)) -> (s_crossing'=0) & (closed_crossing'=false);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_crossing=0) & (s_crossing_fail=0) & ((snd_d1_transmit = false)) -> (s_crossing'=0) & (closed_crossing'=false);
    [t] (s_crossing=1) & (s_crossing_fail=0) & ((snd_d2_transmit = false)) -> (s_crossing'=1) & (closed_crossing'=false);
    [t] (s_crossing_fail=1) -> (closed_crossing'=false);
endmodule


module source
    s_source : [-1..4] init -1;
    //s_source=0 - START
    //s_source=1 - NEAR
    //s_source=2 - REACHED
    //s_source=3 - EXIT
    //s_source=4 - SECURED

    //Generated from output events
    near_source : bool init false;
    reached_source : bool init false;
    exit_source : bool init false;

    //Generated from internal and output variables
    reachedCounter_source : [0..5] init 0;
    exitCounter_source : [0..5] init 0;

    [t] (s_source=-1) -> (s_source'=0) & (near_source'=false) & (reached_source'=false) & (exit_source'=false) & (reachedCounter_source' = 0) & (exitCounter_source' = 0);
    [t] (s_source=0) -> (s_source'=1) & (near_source'=true) & (reached_source'=false) & (exit_source'=false);
    [t] (s_source=3) & ((open_train = true)) -> (s_source'=0) & (near_source'=false) & (reached_source'=false) & (exit_source'=false) & (reachedCounter_source' = 0) & (exitCounter_source' = 0);
    [t] (s_source=1) -> (s_source'=2) & (reached_source'=true) & (near_source'=false) & (exit_source'=false);
    [t] (s_source=2) & ((snd_d0_recieve = true)) -> (s_source'=4) & (reached_source'=true) & (near_source'=false) & (exit_source'=false) & (exitCounter_source' = (exitCounter_source < 5) ? (exitCounter_source + 1) : exitCounter_source);
    [t] (s_source=4) & ((exitCounter_source = 5)) -> (s_source'=3) & (exit_source'=true) & (near_source'=false) & (reached_source'=false);
    [t] (s_source=4) & ((exitCounter_source != 5)) -> (s_source'=4) & (reached_source'=true) & (near_source'=false) & (exit_source'=false) & (exitCounter_source' = (exitCounter_source < 5) ? (exitCounter_source + 1) : exitCounter_source);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_source=2) & ((snd_d0_recieve = false)) -> (s_source'=2) & (near_source'=false) & (reached_source'=false) & (exit_source'=false);
    [t] (s_source=3) & ((open_train = false)) -> (s_source'=3) & (near_source'=false) & (reached_source'=false) & (exit_source'=false);
endmodule


module train
    s_train : [-1..5] init -1;
    //s_train=0 - IDLE
    //s_train=1 - WFR
    //s_train=2 - WFS
    //s_train=3 - BRAKE
    //s_train=4 - WFC
    //s_train=5 - FINISH

    //Generated from output events
    close_train : bool init false;
    open_train : bool init false;
    secure_train : bool init false;
    brake_train : bool init false;

    //Generated from internal and output variables
    secureCounter_train : [0..5] init 0;
    closeCounter_train : [0..5] init 0;

    [t] (s_train=-1) -> (s_train'=0) & (open_train'=true) & (close_train'=false) & (secure_train'=false) & (brake_train'=false) & (closeCounter_train' = 0) & (secureCounter_train' = 0);
    [t] (s_train=0) & ((near_source = true)) -> (s_train'=1) & (secure_train'=true) & (close_train'=false) & (open_train'=false) & (brake_train'=false);
    [t] (s_train=1) & ((reached_source = true)) -> (s_train'=2) & (close_train'=false) & (open_train'=false) & (secure_train'=false) & (brake_train'=false) & (secureCounter_train' = (secureCounter_train < 5) ? (secureCounter_train + 1) : secureCounter_train);
    [t] (s_train=2) & ((snd_d0_recieve = true)) -> (s_train'=4) & (close_train'=true) & (open_train'=false) & (secure_train'=false) & (brake_train'=false);
    [t] (s_train=2) & (s_brake_fail=0) & ((snd_d0_recieve = false) & (secureCounter_train >= 5)) -> (s_train'=3) & (brake_train'=true) & (close_train'=false) & (open_train'=false) & (secure_train'=false);
    [t] (s_train=2) & ((snd_d0_recieve = false) & (secureCounter_train < 5)) -> (s_train'=2) & (close_train'=false) & (open_train'=false) & (secure_train'=false) & (brake_train'=false) & (secureCounter_train' = (secureCounter_train < 5) ? (secureCounter_train + 1) : secureCounter_train);
    [t] (s_train=5) & ((exit_source = true)) -> (s_train'=0) & (open_train'=true) & (close_train'=false) & (secure_train'=false) & (brake_train'=false) & (closeCounter_train' = 0) & (secureCounter_train' = 0);
    [t] (s_train=4) & ((snd_d1_recieve = true)) -> (s_train'=5) & (close_train'=false) & (open_train'=false) & (secure_train'=false) & (brake_train'=false);
    [t] (s_train=4) & (s_brake_fail=0) & ((snd_d1_recieve = false) & (closeCounter_train >= 5)) -> (s_train'=3) & (brake_train'=true) & (close_train'=false) & (open_train'=false) & (secure_train'=false);
    [t] (s_train=4) & ((snd_d1_recieve = false) & (closeCounter_train < 5)) -> (s_train'=4) & (close_train'=true) & (open_train'=false) & (secure_train'=false) & (brake_train'=false);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_train=0) & ((near_source = false)) -> (s_train'=0) & (close_train'=false) & (open_train'=false) & (secure_train'=false) & (brake_train'=false);
    [t] (s_train=1) & ((reached_source = false)) -> (s_train'=1) & (close_train'=false) & (open_train'=false) & (secure_train'=false) & (brake_train'=false);
    [t] (s_train=3) -> (s_train'=3) & (close_train'=false) & (open_train'=false) & (secure_train'=false) & (brake_train'=false);
    [t] (s_train=5) & ((exit_source = false)) -> (s_train'=5) & (close_train'=false) & (open_train'=false) & (secure_train'=false) & (brake_train'=false);
    [t] (s_train=2) & (s_brake_fail=1) & ((snd_d0_recieve = false) & (secureCounter_train >= 5)) -> (s_train'=3) & (brake_train'=false) & (close_train'=false) & (open_train'=false) & (secure_train'=false);
    [t] (s_train=4) & (s_brake_fail=1) & ((snd_d1_recieve = false) & (closeCounter_train >= 5)) -> (s_train'=3) & (brake_train'=false) & (close_train'=false) & (open_train'=false) & (secure_train'=false);
endmodule


module signal
    s_signal : [-1..1] init -1;
    //s_signal=0 - IDLE
    //s_signal=1 - SECURE

    //Generated from output events
    secured_signal : bool init false;

    [t] (s_signal=-1) -> (s_signal'=0) & (secured_signal'=false);
    [t] (s_signal=0) & (s_signal_fail=0) & ((snd_d0_transmit = true)) -> (s_signal'=1) & (secured_signal'=true);
    [t] (s_signal=1) & (s_signal_fail=0) & ((snd_d2_transmit = true)) -> (s_signal'=0) & (secured_signal'=false);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_signal=0) & (s_signal_fail=0) & ((snd_d0_transmit = false)) -> (s_signal'=0) & (secured_signal'=false);
    [t] (s_signal=1) & (s_signal_fail=0) & ((snd_d2_transmit = false)) -> (s_signal'=1) & (secured_signal'=false);
    [t] (s_signal_fail=1) -> (secured_signal'=false);
endmodule


module transmit
    s_transmit : [-1..3] init -1;
    //s_transmit=0 - IDLE
    //s_transmit=1 - D0
    //s_transmit=2 - D1
    //s_transmit=3 - D2

    //Generated from output events
    snd_d0_transmit : bool init false;
    snd_d1_transmit : bool init false;
    snd_d2_transmit : bool init false;

    [t] (s_transmit=-1) -> (s_transmit'=0) & (snd_d0_transmit'=false) & (snd_d1_transmit'=false) & (snd_d2_transmit'=false);
    [t] (s_transmit=0) & (s_radio_t_fail=0) & ((secure_train = true)) -> (s_transmit'=1) & (snd_d0_transmit'=true) & (snd_d1_transmit'=false) & (snd_d2_transmit'=false);
    [t] (s_transmit=0) & (s_radio_t_fail=0) & ((secure_train = false) & (close_train = true)) -> (s_transmit'=2) & (snd_d1_transmit'=true) & (snd_d0_transmit'=false) & (snd_d2_transmit'=false);
    [t] (s_transmit=0) & (s_radio_t_fail=0) & ((secure_train = false) & (close_train = false) & (open_train = true)) -> (s_transmit'=3) & (snd_d2_transmit'=true) & (snd_d0_transmit'=false) & (snd_d1_transmit'=false);
    [t] (s_transmit=1) & (s_radio_t_fail=0) & ((secure_train = false) & (close_train = true)) -> (s_transmit'=2) & (snd_d1_transmit'=true) & (snd_d0_transmit'=false) & (snd_d2_transmit'=false);
    [t] (s_transmit=2) & (s_radio_t_fail=0) & ((secure_train = false) & (close_train = false) & (open_train = true)) -> (s_transmit'=3) & (snd_d2_transmit'=true) & (snd_d0_transmit'=false) & (snd_d1_transmit'=false);
    [t] (s_transmit=1) & (s_radio_t_fail=0) & ((secure_train = false) & (close_train = false) & (open_train = true)) -> (s_transmit'=3) & (snd_d2_transmit'=true) & (snd_d0_transmit'=false) & (snd_d1_transmit'=false);
    [t] (s_transmit=1) & (s_radio_t_fail=0) & ((secure_train = true)) -> (s_transmit'=1) & (snd_d0_transmit'=true) & (snd_d1_transmit'=false) & (snd_d2_transmit'=false);
    [t] (s_transmit=3) & (s_radio_t_fail=0) & ((secure_train = false) & (close_train = false) & (open_train = true)) -> (s_transmit'=3) & (snd_d2_transmit'=true) & (snd_d0_transmit'=false) & (snd_d1_transmit'=false);
    [t] (s_transmit=2) & (s_radio_t_fail=0) & ((secure_train = false) & (close_train = true)) -> (s_transmit'=2) & (snd_d1_transmit'=true) & (snd_d0_transmit'=false) & (snd_d2_transmit'=false);
    [t] (s_transmit=2) & (s_radio_t_fail=0) & ((secure_train = true)) -> (s_transmit'=1) & (snd_d0_transmit'=true) & (snd_d1_transmit'=false) & (snd_d2_transmit'=false);
    [t] (s_transmit=3) & (s_radio_t_fail=0) & ((secure_train = false) & (close_train = true)) -> (s_transmit'=2) & (snd_d1_transmit'=true) & (snd_d0_transmit'=false) & (snd_d2_transmit'=false);
    [t] (s_transmit=3) & (s_radio_t_fail=0) & ((secure_train = true)) -> (s_transmit'=1) & (snd_d0_transmit'=true) & (snd_d1_transmit'=false) & (snd_d2_transmit'=false);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_transmit=0) & (s_radio_t_fail=0) & ((secure_train = false) & (close_train = false) & (open_train = false)) -> (s_transmit'=0) & (snd_d0_transmit'=false) & (snd_d1_transmit'=false) & (snd_d2_transmit'=false);
    [t] (s_transmit=1) & (s_radio_t_fail=0) & ((secure_train = false) & (close_train = false) & (open_train = false)) -> (s_transmit'=1) & (snd_d0_transmit'=false) & (snd_d1_transmit'=false) & (snd_d2_transmit'=false);
    [t] (s_transmit=2) & (s_radio_t_fail=0) & ((secure_train = false) & (close_train = false) & (open_train = false)) -> (s_transmit'=2) & (snd_d0_transmit'=false) & (snd_d1_transmit'=false) & (snd_d2_transmit'=false);
    [t] (s_transmit=3) & (s_radio_t_fail=0) & ((secure_train = false) & (close_train = false) & (open_train = false)) -> (s_transmit'=3) & (snd_d0_transmit'=false) & (snd_d1_transmit'=false) & (snd_d2_transmit'=false);
    [t] (s_radio_t_fail=1) -> (snd_d0_transmit'=false) & (snd_d1_transmit'=false) & (snd_d2_transmit'=false);
endmodule


module observer
    s_observer : [-1..5] init -1;
    //s_observer=0 - IDLE
    //s_observer=1 - Violation
    //s_observer=2 - ARRIVING
    //s_observer=3 - SECURED
    //s_observer=4 - CLOSED
    //s_observer=5 - BRAKE

    //Generated from internal and output variables
    secureCounter_observer : [0..5] init 0;
    closeCounter_observer : [0..5] init 0;

    [t] (s_observer=-1) -> (s_observer'=0) & (closeCounter_observer' = 0) & (secureCounter_observer' = 0);
    [t] (s_observer=0) & ((near_source = true)) -> (s_observer'=2) & (secureCounter_observer' = (secureCounter_observer < 5) ? (secureCounter_observer + 1) : secureCounter_observer);
    [t] (s_observer=3) & ((closed_crossing = true)) -> (s_observer'=4);
    [t] (s_observer=2) & ((secured_signal = true)) -> (s_observer'=3) & (closeCounter_observer' = (closeCounter_observer < 5) ? (closeCounter_observer + 1) : closeCounter_observer);
    [t] (s_observer=2) & ((secured_signal = false) & (brake_train = false) & (secureCounter_observer >= 5)) -> (s_observer'=1);
    [t] (s_observer=3) & ((closed_crossing = false) & (brake_train = false) & (closeCounter_observer >= 5)) -> (s_observer'=1);
    [t] (s_observer=2) & ((secured_signal = false) & (brake_train = true)) -> (s_observer'=5);
    [t] (s_observer=3) & ((closed_crossing = false) & (brake_train = true)) -> (s_observer'=5);
    [t] (s_observer=4) & ((exit_source = true)) -> (s_observer'=0) & (closeCounter_observer' = 0) & (secureCounter_observer' = 0);
    [t] (s_observer=2) & ((secured_signal = false) & (brake_train = false) & (secureCounter_observer < 5)) -> (s_observer'=2) & (secureCounter_observer' = (secureCounter_observer < 5) ? (secureCounter_observer + 1) : secureCounter_observer);
    [t] (s_observer=3) & ((closed_crossing = false) & (brake_train = false) & (closeCounter_observer < 5)) -> (s_observer'=3) & (closeCounter_observer' = (closeCounter_observer < 5) ? (closeCounter_observer + 1) : closeCounter_observer);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_observer=0) & ((near_source = false)) -> (s_observer'=0);
    [t] (s_observer=1) -> (s_observer'=1);
    [t] (s_observer=4) & ((exit_source = false)) -> (s_observer'=4);
    [t] (s_observer=5) -> (s_observer'=5);
endmodule


module recieve
    s_recieve : [-1..3] init -1;
    //s_recieve=0 - IDLE
    //s_recieve=1 - D0
    //s_recieve=2 - D1
    //s_recieve=3 - D2

    //Generated from output events
    snd_d0_recieve : bool init false;
    snd_d1_recieve : bool init false;
    snd_d2_recieve : bool init false;

    [t] (s_recieve=-1) -> (s_recieve'=0) & (snd_d0_recieve'=false) & (snd_d1_recieve'=false) & (snd_d2_recieve'=false);
    [t] (s_recieve=0) & (s_radio_r_fail=0) & ((secured_signal = true)) -> (s_recieve'=1) & (snd_d0_recieve'=true) & (snd_d1_recieve'=false) & (snd_d2_recieve'=false);
    [t] (s_recieve=0) & (s_radio_r_fail=0) & ((secured_signal = false) & (closed_crossing = true)) -> (s_recieve'=2) & (snd_d1_recieve'=true) & (snd_d0_recieve'=false) & (snd_d2_recieve'=false);
    [t] (s_recieve=0) & (s_radio_r_fail=0) & ((secured_signal = false) & (closed_crossing = false) & (boolOpenInput = true)) -> (s_recieve'=3) & (snd_d2_recieve'=true) & (snd_d0_recieve'=false) & (snd_d1_recieve'=false);
    [t] (s_recieve=1) & (s_radio_r_fail=0) & ((secured_signal = false) & (closed_crossing = true)) -> (s_recieve'=2) & (snd_d1_recieve'=true) & (snd_d0_recieve'=false) & (snd_d2_recieve'=false);
    [t] (s_recieve=2) & (s_radio_r_fail=0) & ((secured_signal = false) & (closed_crossing = false) & (boolOpenInput = true)) -> (s_recieve'=3) & (snd_d2_recieve'=true) & (snd_d0_recieve'=false) & (snd_d1_recieve'=false);
    [t] (s_recieve=1) & (s_radio_r_fail=0) & ((secured_signal = false) & (closed_crossing = false) & (boolOpenInput = true)) -> (s_recieve'=3) & (snd_d2_recieve'=true) & (snd_d0_recieve'=false) & (snd_d1_recieve'=false);
    [t] (s_recieve=1) & (s_radio_r_fail=0) & ((secured_signal = true)) -> (s_recieve'=1) & (snd_d0_recieve'=true) & (snd_d1_recieve'=false) & (snd_d2_recieve'=false);
    [t] (s_recieve=3) & (s_radio_r_fail=0) & ((secured_signal = false) & (closed_crossing = false) & (boolOpenInput = true)) -> (s_recieve'=3) & (snd_d2_recieve'=true) & (snd_d0_recieve'=false) & (snd_d1_recieve'=false);
    [t] (s_recieve=2) & (s_radio_r_fail=0) & ((secured_signal = false) & (closed_crossing = true)) -> (s_recieve'=2) & (snd_d1_recieve'=true) & (snd_d0_recieve'=false) & (snd_d2_recieve'=false);
    [t] (s_recieve=2) & (s_radio_r_fail=0) & ((secured_signal = true)) -> (s_recieve'=1) & (snd_d0_recieve'=true) & (snd_d1_recieve'=false) & (snd_d2_recieve'=false);
    [t] (s_recieve=3) & (s_radio_r_fail=0) & ((secured_signal = false) & (closed_crossing = true)) -> (s_recieve'=2) & (snd_d1_recieve'=true) & (snd_d0_recieve'=false) & (snd_d2_recieve'=false);
    [t] (s_recieve=3) & (s_radio_r_fail=0) & ((secured_signal = true)) -> (s_recieve'=1) & (snd_d0_recieve'=true) & (snd_d1_recieve'=false) & (snd_d2_recieve'=false);

    //Generated self-loops for emulating synchronous execution semantics
    [t] (s_recieve=0) & (s_radio_r_fail=0) & ((secured_signal = false) & (closed_crossing = false) & (boolOpenInput = false)) -> (s_recieve'=0) & (snd_d0_recieve'=false) & (snd_d1_recieve'=false) & (snd_d2_recieve'=false);
    [t] (s_recieve=1) & (s_radio_r_fail=0) & ((secured_signal = false) & (closed_crossing = false) & (boolOpenInput = false)) -> (s_recieve'=1) & (snd_d0_recieve'=false) & (snd_d1_recieve'=false) & (snd_d2_recieve'=false);
    [t] (s_recieve=2) & (s_radio_r_fail=0) & ((secured_signal = false) & (closed_crossing = false) & (boolOpenInput = false)) -> (s_recieve'=2) & (snd_d0_recieve'=false) & (snd_d1_recieve'=false) & (snd_d2_recieve'=false);
    [t] (s_recieve=3) & (s_radio_r_fail=0) & ((secured_signal = false) & (closed_crossing = false) & (boolOpenInput = false)) -> (s_recieve'=3) & (snd_d0_recieve'=false) & (snd_d1_recieve'=false) & (snd_d2_recieve'=false);
    [t] (s_radio_r_fail=1) -> (snd_d0_recieve'=false) & (snd_d1_recieve'=false) & (snd_d2_recieve'=false);
endmodule


module radio_t_fail
    s_radio_t_fail : [0..1] init 0;
    
    [t] (s_radio_t_fail=0) -> 1-2.78E-14 : (s_radio_t_fail'=0) + 2.78E-14 : (s_radio_t_fail'=1);
    [t] (s_radio_t_fail=1) -> (s_radio_t_fail'=0);
endmodule


module radio_r_fail
    s_radio_r_fail : [0..1] init 0;
    
    [t] (s_radio_r_fail=0) -> 1-2.78E-14 : (s_radio_r_fail'=0) + 2.78E-14 : (s_radio_r_fail'=1);
    [t] (s_radio_r_fail=1) -> (s_radio_r_fail'=0);
endmodule


module signal_fail
    s_signal_fail : [0..1] init 0;
    
    [t] (s_signal_fail=0) -> 1-2.861E-13 : (s_signal_fail'=0) + 2.861E-13 : (s_signal_fail'=1);
    [t] (s_signal_fail=1) -> (s_signal_fail'=1);
endmodule


module crossing_fail
    s_crossing_fail : [0..1] init 0;
    
    [t] (s_crossing_fail=0) -> 1-6.389E-11 : (s_crossing_fail'=0) + 6.389E-11 : (s_crossing_fail'=1);
    [t] (s_crossing_fail=1) -> (s_crossing_fail'=1);
endmodule


module brake_fail
    s_brake_fail : [0..1] init 0;
    
    [t] (s_brake_fail=0) -> 1-2.022E-10 : (s_brake_fail'=0) + 2.022E-10 : (s_brake_fail'=1);
    [t] (s_brake_fail=1) -> (s_brake_fail'=1);
endmodule