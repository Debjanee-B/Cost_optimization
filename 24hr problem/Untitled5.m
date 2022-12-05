figure(1)
plot(Pflex);
hold on;
%plot(Pdsm);
hold on;
plot(Cgrid);
hold on;
plot(Ppv);
figure(2)
plot(Pgrid, 'DisplayName', 'Pgrid');
xlabel('time');
ylabel('Pload in kWh');