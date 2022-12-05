function [Pgrid, Pbatt, cost, Pload] = batterycharge(Ppv, Pev, Pinflex, Pflex, Cgrid, Pgrid_llim, Pgrid_ulim)
N = 24;

Ppv = double(Ppv);
Pflex = double(Pflex);
Pev = double(Pev);
%soc_t1 = double(soc_t);

%Pev =  transpose(randi([5, 15], [1,24]))
Cbatt = 0.0005125 ;
Cbattf = 0.01427;
Cpv = 0.057;
%%Cgrid = 12;
C =81;
dt = 1;

prob = optimproblem;


%setting limits for variables
Pgrid1 = optimvar('Pgrid1', 'Type', 'continuous',  'Lowerbound', Pgrid_llim,  'Upperbound', Pgrid_ulim);
%soc1 = optimvar('soc1','Type', 'continuous', 'Lowerbound', 0.20, 'Upperbound', 1);
Pbatt1 = optimvar('Pbatt1', 'Type', 'continuous', 'Lowerbound', -15,'Upperbound', -1);


%objective function
prob.Objective  = Cgrid*Pgrid1 - Cbatt*Pbatt1 + Cpv + Cbattf;

%constraints

prob.Constraints.Powerbalance = Ppv + Pgrid1 + Pbatt1 - (Pflex + Pinflex +Pev) == 0;

%prob.Constraints.Powerbalance = Pbatt1 <= Pgrid1;








%prob.Constraints.energyBalance = soc1 == soc_t1 - dt.*((0.80*Pbatt1/C));

%prob.Constraints.Loadconserve = optimconstr(N);
%prob.Constraints.Loadconserve = sum(Pdsm(N)) == sum(Pflex(N));

%options = optimoptions(prob.optimoptions,'Display','off');
options = optimoptions('linprog', 'Algorithm', 'dual-simplex',);
[values, cost , exitflag] = solve(prob, 'Options', options);

if exitflag <= 0
        Pgrid = 0;
        
        Pbatt = 0;
        %soc = 0;
        %Pchar = zero(N,1);
        
else
       Pgrid1 = values.Pgrid1;
       Pgrid = cast(Pgrid1, 'double');
       % soc1 = values.soc1;
        %soc = cast(soc1, 'double');
        
     
        Pbatt1 = values.Pbatt1;
        Pbatt = cast(Pbatt1, 'double');
        %Pdsm = values.Pdsm;
end 

Pload = Pflex + Pinflex + Pev;
%disp(Pload)
show(prob);
end
