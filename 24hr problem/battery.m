function [Pgrid, Pbatt, cost, Pload] = battery(Ppv, Pev, Pinflex, Pflex, Cgrid)
N = 24;

Ppv = double(Ppv);
Pflex = double(Pflex);
Pev = double(Pev);
%soc_t1 = double(soc_t);

%Pev =  transpose(randi([5, 15], [1,24]))

%%Cgrid = 12;
C =81;
dt = 1;

prob = optimproblem;
Cbatt = 0.0016 ;
Cpv = 0.01095;

%setting limits for variables
Pgrid1 = optimvar('Pgrid1', 'Type', 'continuous',  'Lowerbound', -Inf, 'Upperbound', Inf);
%soc1 = optimvar('soc1','Type', 'continuous', 'Lowerbound', 0.20, 'Upperbound', 1);
Pbatt1 = optimvar('Pbatt1', 'Type', 'continuous', 'Lowerbound', -4,'Upperbound', 4);


%objective function
prob.Objective  = Cgrid*Pgrid1 + Cbatt*Pbatt1 + Cpv;

%constraints
prob.Constraints.Powerbalance = Ppv + Pgrid1 + Pbatt1 - (Pflex + Pinflex +Pev) == 0;




%prob.Constraints.energyBalance = soc1 == soc_t1 - dt.*((0.80*Pbatt1/C));

%prob.Constraints.Loadconserve = optimconstr(N);
%prob.Constraints.Loadconserve = sum(Pdsm(N)) == sum(Pflex(N));

%options = optimoptions(prob.optimoptions,'Display','off');
options = optimoptions('linprog' );
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

Pload = Pflex + Pinflex + Pev - Pbatt;
disp(Pload)
end
