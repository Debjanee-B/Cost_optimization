

N = numel(Pev);
%gams('practice');
C =81;
total_cost = 0;
%Cgrid = [2.8 ;2.4 ;2.4 ;2.4 ;2.5 ;3.2 ;3.9 ;3.7; 3.2 ;2.7 ;2.7 ;2.7 ;2.6 ;2.6 ;2.7 ;2.9 ;3.4 ;4.6 ;8.9 ;7.8 ;4.8;3.7 ;3.5 ;3.4]; 
socini = 0.9;
soc_t = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
%Pflex_n = zeros(24);
Pflex_1 = Pflex(1) + Pflex(2) +Pflex(3) + Pflex(4) + Pflex(5) +Pflex(6);
Pflex_2 =Pflex(7) + Pflex(8) +Pflex(9) + Pflex(10) + Pflex(11) +Pflex(12);
Pflex_3 = Pflex(13) + Pflex(14) +Pflex(15)+ Pflex(16) + Pflex(17) +Pflex(18);
Pflex_4 = Pflex(19) + Pflex(20) +Pflex(21) + Pflex(22) + Pflex(23) +Pflex(24);
Pflex_n = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; Pflex_1; Pflex_2; Pflex_3; Pflex_4; 0; 0; 0; 0; 0; 0; 0; 0];

Pshift = 0;
count = 0;
count1 = 0;
count2 = 0;
dt = 1;

for t = 1:1:N
    
    if t == 1 
        
        soc_t(1) = socini;
                if Pbatt(t) >= Pflex(t) + Pinflex(t) + P
        
     
        
                    [Pgrid(t), Pbatt(t), cost, Pload(t)]  = battery( Ppv(t), Pev(t), Pinflex(t), Pflex_n(t),  Cgrid(t));
                    count = count + 1;
                     if Pbatt(t) <= 0
                                soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)*0.8)/C);
                            else
                                soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C)); 
                     end
                    %soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)/C));
                    total_cost = total_cost + cost;
                    %Pshift = 0;


         
    elseif soc_t(t) <= 0.20
           
                        [Pgrid(t), Pbatt(t), cost, Pload(t)]  = batterycharge( Ppv(t), Pev(t), Pinflex(t), Pflex_n(t),  Cgrid(t));
                        count = count + 1;
                        soc_t(t+1) = soc_t(t) - dt.*((0.80*Pbatt(t)/C));
                        total_cost = total_cost + cost;
                        Pshift = 0;





            
              
        elseif soc_t(t) >= 1
                    
                                    [Pgrid(t), Pbatt(t), cost, Pload(t)]  = batterydischarge( Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) ,  Cgrid(t));
                                    count = count + 1;
                                    soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C));
                                    total_cost = total_cost + cost;
                                    %Pshift = 0;





                     

                            
    else
        
        [Pgrid(t), Pbatt(t),  cost, Pload(t)] = batterycharge(Ppv(t), Pev(t), Pinflex(t),  Pflex_n(t) , Cgrid(t));
         %Pshift = Pshift + Pflex_n(t);
         total_cost = cost + total_cost;
         if Pbatt(t) <= 0
                soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)*0.8)/C);
         else
                soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C)); 
         end
    end
                                       
                            
            
              
       
                
              
          
            
            
    
        
end
            
Pload = transpose(Pload);
x = linspace(1, 24, 1);
figure('Name', 'with algorithm')
plot(Pload);
grid on;
code2_totalcost = total_cost;
grid_alg = sum(Pgrid);

writematrix(Ppv,'outputalg.xls','Sheet',1,'Range','A2:A25');
writematrix(Pev,'outputalg.xls','Sheet',1,'Range','B2:B25');
writematrix(Pflex_n,'outputalg.xls','Sheet',1,'Range','C2:C25');

writematrix(Pinflex,'outputalg.xls','Sheet',1,'Range','D2:D25');
%writematrix(Pload,'outputalg.xls','Sheet',1,'Range','I2:I25');
writematrix(transpose(Pgrid),'outputalg.xls','Sheet',1,'Range','E2:E25');
writematrix(transpose(Pbatt),'outputalg.xls','Sheet',1,'Range','F2:F25');
writematrix(soc_t,'outputalg.xls','Sheet',1,'Range','G2:G25');
writematrix(Pload,'outputalg.xls','Sheet',1,'Range','I2:I25');
writematrix(Cgrid, 'outputalg.xls','Sheet',1,'Range','J2:J25');