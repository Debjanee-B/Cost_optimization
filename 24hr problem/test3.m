
N = numel(Pev);
%gams('practice');

total_cost = 0;
Cgrid = [2.8 ;2.4 ;2.4 ;2.4 ;2.5 ;3.2 ;3.9 ;3.7; 3.2 ;2.7 ;2.7 ;2.7 ;2.6 ;2.6 ;2.7 ;2.9 ;3.4 ;4.6 ;8.9 ;7.8 ;4.8;3.7 ;3.5 ;3.4]; 
soc = [0.25; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
Pshift = 0;
count = 0;
count1 = 0;
count2 = 0;

for t = 1:1:N
     
         if (Pinflex(t) + Pflex(t)+ Pshift - Ppv(t)) > 0
             count2 = count2 + 1;


            if (t >= 10) && (t <=16) || ((t >= 21 && t<=24) || (Cgrid(t)<3)) && (soc(t) >= 0.25)
                    %[Pgrid(t), Pbatt(t), cost, Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t), Pflex(t) + Pshift, Cgrid(t));
                    [Pgrid(t), Pbatt(t), soc(t+1), cost, Pload(t)]  = hr1_working( Ppv(t), Pev(t), Pinflex(t), Pflex(t) + Pshift, soc(t), Cgrid(t));
                    count = count + 1;
                    %soc_t(t+1) = soc_t(t) + dt.*((0.80*Pbatt/C));
                    total_cost = total_cost + cost;
                    Pshift = 0;





            else

                    %[Pgrid(t), Pbatt(t), soc(t+1), cost, Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t),  0 , soc(t), Cgrid(t));
                     [Pgrid(t), Pbatt(t), soc(t+1), cost, Pload(t)]  = hr1_working( Ppv(t), Pev(t), Pinflex(t), 0, soc(t), Cgrid(t));
                     total_cost = total_cost + cost;
                    Pshift = Pshift + Pflex(t);
                   % soc_t(t+1) = soc_t(t) + dt.*((0.80*Pbatt/C));
                    
            end
         else
            [Pgrid(t), Pbatt(t), soc(t+1), cost, Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t),  0 , soc(t), Cgrid(t));
            Pshift = Pshift + Pflex(t);
            total_cost = cost + total_cost;
            count1 = count1 + 1;
         end
    
end
Pload = transpose(Pload);
x = linspace(1, 24, 1);
figure('Name', 'with algorithm')
plot(Pload);

grid_alg = sum(Pgrid);

