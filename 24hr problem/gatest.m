N = 24;

Ppv = double(Ppv);
Pflex = double(Pflex);
Pev = double(Pev);
%soc_t1 = double(soc_t);
Socini = 0.9;

%Pev =  transpose(randi([5, 15], [1,24]))
Cbatt = 0.0140;
%%Cgrid = 12;
C =81;
dt = 1;

prob = optimproblem;
Cpv = 4.56;


%setting limits for variables
Pgrid1 = optimvar('Pgrid1', N ,'Type', 'continuous',  'Lowerbound', -Inf, 'Upperbound', Inf);
soc1 = optimvar('soc1', N, 'Type',  'continuous', 'Lowerbound', 0.20, 'Upperbound', 1);
Pbatt1 = optimvar('Pbatt1', N ,'Type', 'continuous', 'Lowerbound', -Inf ,'Upperbound', Inf);




%objective function
prob.Objective  = Cgrid(N).*Pgrid1(N) + Cbatt.*Pbatt1(N) + Cpv;

xval  = 20*rand(1,100);
yval = -4 + 3*rand(1,100);
zval = zeros([100, 1]);

vals.x = xval;
vals.y  = yval;
vals.z = zval;
%constraints
prob.Constraints.Powerbalance = Ppv + Pgrid1 + Pbatt1 - (Pflex + Pinflex +Pev) == 0;

prob.Constraints.energyBalance = optimconstr(N);
prob.Constraints.energyBalance(1) = soc1(1) == Socini;
prob.Constraints.energyBalance(2:N) = soc1(2:N) == soc1(1:N-1) + dt.*((0.98*Pbatt1(2:N)/C)-(Pbatt1(2:N)/(C*0.98)));


%%options = convertForSolver(prob, "ga");
%%%options = optimoptions("ga","PlotFcn","gaplotbestf");
%options = optimoptions(@ga,... 'PlotFcn',{@gaplotbestf,@gaplotmaxconstr},...'Display','iter');
%%%[values,fval] = solve(prob,"Options",options);
opts = optimoptions("ga",PopulationSize=100);
[values,cost] = solve(prob, vals, Solver="ga",Options=opts);
%[values, cost , exitflag] = solve(prob, "Solver", "ga");

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
disp(Pload );


