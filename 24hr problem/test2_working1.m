Ppv = [0; 0 ;0 ;0 ;0 ;0 ;0 ;2.2727 ;11.5227 ;22.2175 ;28.6378 ;37.3115 ;36.1772 ;30.175 ;19.6511 ;6.1675 ;1.1277 ;0 ;0 ;0 ;0 ;0;0 ;0];
%Pev =  transpose(randi([5, 15], [1,24])); %kW 
Pev = [12; 10 ;8 ;12 ;6 ;6 ;5 ;15 ;15 ;6 ;10 ;12 ;8 ;13 ;11 ;9 ; 7 ;13 ;14; 13 ;9 ;15 ;7 ;10];

Pinflex = [0.856; 0.754 ;1.3298 ;2.142 ;2.345 ;1.75 ;1.456 ;3.2727 ;8.5227 ;15.2175 ;20.6378 ;19.3115 ;17.1772 ;4.175 ;5.6511 ;9.1675 ;14.1277 ;13.523 ;12.25 ;4.058 ;1.86 ;0.854 ;1.39 ;1.75]; %kW
Pflex = 0.5.*Pinflex;
N = numel(Pev);
%Pgrid = zeros([24,1]);
%Pbatt = zeros([24,1]);
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
         
        
        if (t >= 10) && (t <=1)
                [Pgrid(t), Pbatt(t), soc(t+1), cost] = hr1_working(Ppv(t), Pev(t), Pinflex(t), Pflex(t) + Pshift, soc(t), Cgrid(t));
                count = count + 1;
                total_cost = total_cost + cost;
                Pshift = 0;
        else 
                
                
            
                [Pgrid(t), Pbatt(t), soc(t+1), cost] = hr1_working(Ppv(t), Pev(t), Pinflex(t),  0 , soc(t), Cgrid(t));
                total_cost = total_cost + cost;
                
                
        end
        
     else
         
         [Pgrid(t), Pbatt(t), soc(t+1), cost] = hr1_working(Ppv(t), Pev(t), Pinflex(t),  Pflex(t) + Pshift , soc(t), Cgrid(t));
         Pshift = Pshift + Pflex(t);
         total_cost = cost + total_cost;
         count1 = count1 + 1;
         
             
          
     end
     
end
%filename = 'test.xlxs';
%writematrix(Pgrid, test.xlxs);
disp( count);
disp( count1);
disp(count2);
