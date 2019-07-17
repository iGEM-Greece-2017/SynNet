% Get Kd for mRNA/miRNA interactions
Consts.Rgas= 1.987203611e-3;  % kcal/mol/K
Consts.Temp= 37+273.2;        % K

% ΔG [kcal/mol]h
Consts.dg= zeros(7,6);
% 1: OR: mir21
Consts.dg(1,1)= -19.6;
% 2: OR: mir372-mir373
Consts.dg(2,2:3)= [-26.38, -27.98];
% 3: mid: mir21
Consts.dg(3,1)= -14.59;
% 4: mid: mir372-mir373
Consts.dg(4,2:3)= [-25.31, -20.69];
% 5: NOT: DsRed-145-143-FF4
Consts.dg(5,4:6)= [-23.19, -26.26, -14.38];
% 6: NOT: DsRed-145-FF4
Consts.dg(6,[4,6])= [-26.25, -14.11];
% 7: NOT: Apoptin-145-143-FF4
Consts.dg(7,4:6)= [-23.21, -28.22, -16.73];

Consts.Kd= exp(Consts.dg./(Consts.Rgas*Consts.Temp));
