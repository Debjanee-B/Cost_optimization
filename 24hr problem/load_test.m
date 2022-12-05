close all;
clear all;
Tstep = 0.0833;
T = 24/Tstep;
nsim = 0;
nmax = 50;
Pcharge = 4;
%chload = 0;
Cbat = 7;

 for nsim = 1:nmax
    
        k = 10;
        ev_startime = normrnd(17.6, 3.4);
        ev_dis = lognrnd(3.09, 0.16);
        for count = 1:1:10
                ev_soc(nsim, count) = (1-(ev_dis(nsim, count)/100));
                charging_duration(nsim, count) = ((1-ev_soc(nsim, count))*Cbat)/(Pcharge*0.9);
                
                
                %Pcharge(nsim, count) = ((1 - ev_soc(nsim, count))*Cbat)/0.9;
                %%%%%%%%%chload(N) = chload + Pcharge*charging_duration(1,count);
        end