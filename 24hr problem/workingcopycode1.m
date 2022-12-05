

N = numel(Pev);

C =81;
total_cost = 0;
%Cgrid = [2.8 ;2.4 ;2.4 ;2.4 ;2.5 ;3.2 ;3.9 ;3.7; 3.2 ;2.7 ;2.7 ;2.7 ;2.6 ;2.6 ;2.7 ;2.9 ;3.4 ;4.6 ;8.9 ;7.8 ;4.8;3.7 ;3.5 ;3.4]; 
socini = 0.9;
soc_t = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
count = 0;
for t = 1:1:24
    if t <= 12
        Pflex_n(t) = 0;
        
    elseif t>=13 && t<=16
        Pflex_n(t) = Pflex(count+1,1) + Pflex(count+2,1) + Pflex(count+3,1) + Pflex(count+4,1)+ Pflex(count+5,1)+Pflex(count+6,1);  
        count = count + 6;
    else
        Pflex_n(t) = 0;
    end
end
        
        
Pshift = 0;
count = 0;
count1 = 0;
count2 = 0;
dt = 1;

for t = 1:1:N
    
    if t == 1 
        
        soc_t(1) = socini;
        
     
         if (Pinflex(t) + Pflex_n(t)+ Pshift - Ppv(t)) > 0
             count2 = count2 + 1;


            if (t >= 10 && t <=17 )|| (t >= 21 && t<=24) || (Cgrid(t)<3)
                    %[Pgrid(t), Pbatt(t), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift, Cgrid(t));
                    [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = battery( Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift,  Cgrid(t));
                    count = count + 1;
                     if Pbatt(t) <= 0
                                soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)*0.8)/C);
                            else
                                soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C)); 
                     end
                    %soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)/C));
                    total_cost = total_cost + cost(t);
                    Pshift = 0;





            else

                    %[Pgrid(t), Pbatt(t), soc(t+1), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t),  0 , soc(t), Cgrid(t));
                     [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = battery( Ppv(t), Pev(t), Pinflex(t), 0, Cgrid(t));
                     total_cost = total_cost + cost(t);
                    Pshift = Pshift + Pflex_n(t);
                   %soc_t(t+1) = soc_t(t) - dt.*((0.80*Pbatt(t)/C));
                    if Pbatt(t) <= 0
                                soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)*0.8)/C);
                    else
                                soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C)); 
                    end
                    
            end
         else
            [Pgrid(t), Pbatt(t),  cost(t), Pload(t)] = battery(Ppv(t), Pev(t), Pinflex(t),  Pflex_n(t) + Pshift , Cgrid(t));
            Pshift = 0;
            total_cost = cost(t) + total_cost;
            %soc_t(t+1) = soc_t(t) - dt.*((0.80*Pbatt(t)/C));
             if Pbatt(t) <= 0
                                soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)*0.8)/C);
             else
                                soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C)); 
             end
            count1 = count1 + 1;
         end
    elseif soc_t(t) <= 0.25
            if (Pinflex(t) + Pflex_n(t)+ Pshift - Ppv(t)) > 0
                    count2 = count2 + 1;


                if (t >= 10 && t <=17) || (t >= 21 && t<=24) || (Cgrid(t)<3) 
                        %[Pgrid(t), Pbatt(t), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift, Cgrid(t));
                        [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = batterycharge( Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift,  Cgrid(t));
                        count = count + 1;
                        soc_t(t+1) = soc_t(t) - dt.*((0.80*Pbatt(t)/C));
                        total_cost = total_cost + cost(t);
                        Pshift = 0;





                else

                    %[Pgrid(t), Pbatt(t), soc(t+1), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t),  0 , soc(t), Cgrid(t));
                     [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = batterycharge( Ppv(t), Pev(t), Pinflex(t), 0, Cgrid(t));
                     total_cost= total_cost + cost(t);
                    Pshift = Pshift + Pflex_n(t);
                   soc_t(t+1) = soc_t(t) - dt.*((0.80*Pbatt(t)/C));
                    
            end
         else
            [Pgrid(t), Pbatt(t),  cost(t), Pload(t)] = batterycharge(Ppv(t), Pev(t), Pinflex(t),  Pflex_n(t) + Pshift , Cgrid(t));
            Pshift = 0;
            total_cost = cost(t) + total_cost;
            soc_t(t+1) = soc_t(t) - dt.*((0.80*Pbatt(t)/C));
              end
              
        elseif soc_t(t) >= 1
                    if (Pinflex(t) + Pflex_n(t)+ Pshift - Ppv(t)) > 0
                         count2 = count2 + 1;


                            if (t >= 10 && t <=17) || (t >= 21 && t<=24) || (Cgrid(t)<3)
                                    %[Pgrid(t), Pbatt(t), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift, Cgrid(t));
                                    [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = batterydischarge( Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift,  Cgrid(t));
                                    count = count + 1;
                                    soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C));
                                    total_cost = total_cost + cost(t);
                                    Pshift = 0;





                                    else

                    %[Pgrid(t), Pbatt(t), soc(t+1), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t),  0 , soc(t), Cgrid(t));
                                         [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = batterydischarge( Ppv(t), Pev(t), Pinflex(t), 0, Cgrid(t));
                                         total_cost = total_cost+cost(t);
                                        Pshift = Pshift + Pflex_n(t);
                                       soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C));

                            end
                             else
                                        [Pgrid(t), Pbatt(t),  cost(t), Pload(t)] = batterycharge(Ppv(t), Pev(t), Pinflex(t),  Pflex_n(t) + Pshift , Cgrid(t));
                                        Pshift = 0;
                                        total_cost = cost(t) + total_cost;
                                        soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C));
                                        count1 = count1 + 1;
                             end
            
              
        else
            if (Pinflex(t) + Pflex_n(t)+ Pshift - Ppv(t)) > 0
             count2 = count2 + 1;


                if (t >= 10 && t <=17) || (t >= 21 && t<=24) || (Cgrid(t)<3) 
                        %[Pgrid(t), Pbatt(t), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift, Cgrid(t));
                        [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = battery( Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift,  Cgrid(t));
                        count = count + 1;
                        if Pbatt(t) <= 0
                            soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)*0.8)/C);
                        else
                            soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C)); 
                        end
                        total_cost = total_cost + cost(t);
                          Pshift = 0;





                    else

                            %[Pgrid(t), Pbatt(t), soc(t+1), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t),  0 , soc(t), Cgrid(t));
                             [Pgrid(t), Pbatt(t),  cost(t), Pload(t)]  = battery( Ppv(t), Pev(t), Pinflex(t), 0,  Cgrid(t));
                             total_cost = total_cost + cost(t);
                            Pshift = Pshift + Pflex_n(t);
                            if Pbatt(t) <= 0
                                soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)*0.8)/C);
                            else
                                soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C)); 
                            end
                          % soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C));
                          
                    
                    end
         else
            [Pgrid(t), Pbatt(t),  cost(t), Pload(t)] = battery(Ppv(t), Pev(t), Pinflex(t),  Pflex_n(t) + Pshift , Cgrid(t));
            Pshift = 0;
            total_cost = cost(t) + total_cost;
            if Pbatt(t) <= 0
                                soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)*0.8)/C);
            else
                            soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C)); 
            end
             %soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/0.8*C));
            count1 = count1 + 1;
         end
                
              
          
            
            
    
        end
end
 algo_cost = sum(cost);
            
Pload = transpose(Pload);
x = linspace(1, 24, 1);
figure('Name', 'with algorithm')
plot(Pload);
figure('Name', 'cost per hour with algo')
plot(cost);

gridf_alg = sum(Pgrid);
writematrix(Ppv,'output1.xls','Sheet',1,'Range','A2:A25');
writematrix(Pev,'output1.xls','Sheet',1,'Range','B2:B25');
writematrix(Pflex,'output1.xls','Sheet',1,'Range','C2:C25');
writematrix(Pinflex,'output1.xls','Sheet',1,'Range','D2:D25');
%writematrix(Pload,'output1.xls','Sheet',1,'Range','I2:I25');
writematrix(transpose(Pgrid),'output1.xls','Sheet',1,'Range','E2:E25');
writematrix(transpose(Pbatt),'output1.xls','Sheet',1,'Range','F2:F25');
writematrix(soc_t,'output1.xls','Sheet',1,'Range','G2:G25');
writematrix(Pload,'output1.xls','Sheet',1,'Range','I2:I25');
writematrix(Cgrid, 'output1.xls','Sheet',1,'Range','J2:J25');





