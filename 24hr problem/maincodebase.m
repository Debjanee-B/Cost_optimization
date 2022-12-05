
N = numel(Pflex);
%gams('practice');
C =81;
total_cost = 0;
%Cgrid = [2.8 ;2.4 ;2.4 ;2.4 ;2.5 ;3.2 ;3.9 ;3.7; 3.2 ;2.7 ;2.7 ;2.7 ;2.6 ;2.6 ;2.7 ;2.9 ;3.4 ;4.6 ;8.9 ;7.8 ;4.8;3.7 ;3.5 ;3.4]; 
socini = 0.25;
%soc_t = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];

Pshift = 0;
count = 0;

count1 = 0;
count2 = 0;
dt = 1;


for t = 1:1:24
    
    if t == 1 
        
        soc_t(1) = socini;
        
     
        
                    if (Pinflex(t) + Pflex(t) + Pev(t)) <= Ppv(t)
         


            
                    %[Pgrid(t), Pbatt(t), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift, Cgrid(t));
                    [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = batterycharge( Ppv(t), Pev(t), Pinflex(t), Pflex(t) ,  Cgrid(t));
                    count = count + 1;
                     
                    soc_t(t+1) = soc_t(t) - dt.*(0.8*Pbatt(t)/(C)); 
                     
                    %soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)/C));
                    total_cost = total_cost + cost(t);
                 





            else

                    %[Pgrid(t), Pbatt(t), soc(t+1), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t),  0 , soc(t), Cgrid(t));
                     [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = battery( Ppv(t), Pev(t), Pinflex(t), Pflex(t), Cgrid(t));
                     total_cost = total_cost + cost(t);
                    
                   %soc_t(t+1) = soc_t(t) - dt.*((0.80*Pbatt(t)/C));
                    if Pbatt(t) <= 0
                                soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)*0.8)/C);
                    else
                                soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C)); 
                    end
                    
            end


         
    elseif soc_t(t) <= 0.25
           
                        [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = batterycharge( Ppv(t), Pev(t), Pinflex(t), Pflex(t),  Cgrid(t));
                        count = count + 1;
                        soc_t(t+1) = soc_t(t) - dt.*((0.80*Pbatt(t)/C));
                        total_cost = total_cost + cost(t);
                        





            
              
        elseif soc_t(t) >= 1
                    
                                    [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = batterydischarge( Ppv(t), Pev(t), Pinflex(t), Pflex(t),  Cgrid(t));
                                    count = count + 1;
                                    soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C));
                                    total_cost = total_cost + cost(t);
                                    %Pshift = 0;





                     

                            
    else
          [Pgrid(t),  cost(t), Pload(t)]  = batterystandby( Ppv(t), Pev(t), Pinflex(t), Pflex(t),  Cgrid(t));
                        count = count + 1;
                        soc_t(t+1) = soc_t(t) - dt.*((0.80*Pbatt(t)/C));
                        total_cost = total_cost + cost(t);
        
        
                            
            
              
       
                
              
          
    end          
            
    
        
end
            
Pload = transpose(Pload);
x = linspace(1, 24, 1);
figure('Name', 'without algorithm')
plot(Pload);
grid on;
base_totalcost = sum(cost);
figure('Name', 'cost per hour without algo')
plot(cost);


gridbase = sum(Pgrid);
writematrix(Ppv,'outputmain1.xls','Sheet','Summer EV coord no DSM','Range','A2:A721');
writematrix(Pev,'outputmain1.xls','Sheet','Summer EV coord no DSM','Range','B2:B721');
writematrix(Pflex,'outputmain1.xls','Sheet','Summer EV coord no DSM','Range','C2:C721');
writematrix(Pinflex,'outputmain1.xls','Sheet','Summer EV coord no DSM','Range','D2:D721');
%writematrix(Pload,'output1.xls','Sheet',1,'Range','I2:I25');
writematrix(transpose(Pgrid),'outputmain1.xls','Sheet', 'Summer EV coord no DSM','Range','E2:E721');
writematrix(transpose(Pbatt),'outputmain1.xls','Sheet','Summer EV coord no DSM','Range','F2:F721');
writematrix(soc_t,'outputmain1.xls','Sheet','Summer EV coord no DSM','Range','G2:G721');
writematrix(transpose(Pload),'outputmain1.xls','Sheet','Summer EV coord no DSM','Range','H2:H721');
writematrix(Cgrid, 'outputmain1.xls','Sheet','Summer EV coord no DSM','Range','I2:I721');