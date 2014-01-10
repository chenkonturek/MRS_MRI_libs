%%% File: nmr_calT2star.m                                             %%%
%%%                                                                   %%%
%%% Description:                                                      %%%
%%%                                                                   %%%
%%% Author: Chen Chen                                                 %%%
%%% Last update: Oct 2012                                             %%%
%%% Organisation: SPMMPC, University of Nottingham                    %%%

function T2_star = nmr_calT2star( T2, delta_f )
%%% @T2: transverse relaxation time (ms)
%%% @delta_f: difference in local resonance frequency (kHz)

%%% @T2_star: real transverse relaxation time (ms)

    T2_star = 1/(1/T2 + delta_f); 

end

