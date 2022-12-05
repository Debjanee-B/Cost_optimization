function [Pgrid, Pbatt, soc, fval] = hr1(Ppv, Pinflex, Pflex, soc_t, Cgrid)
N = 24;

Ppv = double(Ppv);
Pflex = double(Pflex);
%Pev = double(Pev);
soc_t = double(soc_t);

%Pev =  transpose(randi([5, 15], [1,24]))
Cbatt = 5;
%Cgrid = 12;
C =81;
dt = 1;

prob = optimproblem;

%setting limits for variables
Pgrid1 = optimvar('Pgrid1', 'Type', 'continuous',  'Lowerbound', 0, 'Upperbound', Inf);
soc1 = optimvar('soc1','Type', 'continuous', 'Lowerbound', 0.20, 'Upperbound', 1);
Pbatt1 = optimvar('Pbatt1', 'Type', 'continuous', 'Lowerbound', -4,'Upperbound', 4);


%objective function
prob.Objective  = Cgrid*Pgrid1 + Cbatt*Pbatt1;

%constraints
prob.Constraints.Powerbalance = Ppv + Pgrid1 + Pbatt1 - (Pflex + Pinflex) == 0;


prob.Constraints.energyBalance = soc1 == soc_t + dt.*((0.98*Pbatt1/C)-(Pbatt1/(C*0.98)));

%prob.Constraints.Loadconserve = optimconstr(N);
%prob.Constraints.Loadconserve = sum(Pdsm(N)) == sum(Pflex(N));

%options = optimoptions(prob.optimoptions,'Display','off');
options = optimoptions('linprog');
[values, fval , exitflag] = solve(prob, 'Options', options);

if exitflag <= 0
        Pgrid = 0;
        
        Pbatt = 0;
        soc = 0;
        %Pchar = zero(N,1);
        
else
       Pgrid1 = values.Pgrid1;
       Pgrid = cast(Pgrid1, 'double');
        soc1 = values.soc1;
        soc = cast(soc1, 'double');
        
     
        Pbatt1 = values.Pbatt1;
        Pbatt = cast(Pbatt1, 'double');
        %Pdsm = values.Pdsm;
         
end
