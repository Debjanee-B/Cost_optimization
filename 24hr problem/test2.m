close all;
clear all;
%Ppv = [0; 0; 0; 0; 0; 0; 0; 2.5; 5; 20; 29; 35; 32; 25; 18; 5; 0; 0; 0; 0; 0; 0; 0; 0];
Ppv = [0; 0; 0 ;0 ;0 ;0;0 ;2.27 ;11.52;22.21 ;28.63 ;37.31 ;36.17 ;30.17 ;19.65 ;6.16 ;1.12 ;0;0;0;0 ;0 ;0 ;0];
%Pev =  transpose(randi([5, 15], [1,24])); %kW 
Pinflex = [0.856; 0.754 ;1.3298 ;2.142 ;2.345 ;1.75 ;1.456 ;3.2727 ;8.5227 ;15.2175 ;20.6378 ;19.3115 ;17.1772 ;4.175 ;5.6511 ;9.1675; 14.1277 ;13.523 ;12.25 ;4.058; 1.86 ;0.854 ;1.39 ;1.75];
%Pinflex = [0; 2; 3; 1.5; 2.5; 2.5; 1.5; 1.5; 2.5 ;10 ;24 ;28 ;25 ;26 ;5 ;2.5 ;20 ;12.5 ;21 ;20 ;7.5 ;1 ;0.5 ;0.5]; %kW
Pflex = 0.5.*Pinflex;
Cgrid = [2.8 ;2.4 ;2.4 ;2.4 ;2.5 ;3.2 ;3.9 ;3.7; 3.2 ;2.7 ;2.7 ;2.7 ;2.6 ;2.6 ;2.7 ;2.9 ;3.4 ;4.6 ;8.9 ;7.8 ;4.8;3.7 ;3.5 ;3.4]; 
N = numel(Ppv);
totalCost = 0;
%Pgrid = zeros([24,1]);
%Pbatt = zeros([24,1]);

soc = [0.25; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
Pshift = 0;
count = 0;
count1 = 0;
count2 = 0;

for t = 1:1:N
     if (Pinflex(t) + Pflex(t)+ Pshift - Ppv(t)) > 0
         count2 = count2 + 1;
         
        
        if (t >= 10) && (t <=14)
                [Pgrid(t), Pbatt(t), soc(t+1), fval] = hr1(Ppv(t), Pinflex(t), Pflex(t) + Pshift, soc(t), Cgrid(t));
                count = count + 1;
                Pshift = 0;
                totalCost = totalCost + fval;
        else
            
                [Pgrid(t), Pbatt(t), soc(t+1), fval] = hr1(Ppv(t), Pinflex(t),  0 , soc(t), Cgrid(t));
                totalCost = totalCost +fval;
                
                
        end
        
     else
         
         [Pgrid(t), Pbatt(t), soc(t+1), fval] = hr1(Ppv(t),  Pinflex(t),  Pflex(t) + Pshift , soc(t), Cgrid(t));
         Pshift = Pshift + Pflex(t);
         totalCost = totalCost +fval;
         
         count1 = count1 + 1;
         
             
          
     end
     
end
disp( count);
disp( count1);
disp(count2);
