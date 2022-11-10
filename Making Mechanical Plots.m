% Sam Coeyman
% Loading in compaction/modulus/linear stiffness values from excel and making plots 

%% Housekeeping
clear; clc; close all;

%% Compaction
% S
S_Abs_c = xlsread('mouse mech data_with linear stiff.xlsx', 3, 'E3:H75');
NS_Abs_c = xlsread('mouse mech data_with linear stiff.xlsx', 3, 'A3:D75');

A = xlsread('mouse mech data_with linear stiff.xlsx', 3, 'I3:I75'); % NS DO
B = xlsread('mouse mech data_with linear stiff.xlsx', 3, 'J3:J75'); % NS D3
C = xlsread('mouse mech data_with linear stiff.xlsx', 3, 'K3:K75'); % S D0
D = xlsread('mouse mech data_with linear stiff.xlsx', 3, 'L3:L75'); % S D3
T_c = nan(75,4); 
T_c(1:length(A),1)=A; 
T_c(1:length(B),2)=B;
T_c(1:length(C),3)=C;
T_c(1:length(D),4)=D;

Z_c(1,1) = mean(T_c(:,1),'omitnan');
Z_c(1,2) = mean(T_c(:,2),'omitnan');
Z_c(1,3) = mean(T_c(:,3),'omitnan');
Z_c(1,4) = mean(T_c(:,4),'omitnan');

%% Modulus
S_Abs = xlsread('mouse mech data_with linear stiff.xlsx', 2, 'E3:H75');
NS_Abs = xlsread('mouse mech data_with linear stiff.xlsx', 2, 'A3:D75');

E = xlsread('mouse mech data_with linear stiff.xlsx', 2, 'I3:I75'); % NS DO
F = xlsread('mouse mech data_with linear stiff.xlsx', 2, 'J3:J75'); % NS D3
G = xlsread('mouse mech data_with linear stiff.xlsx', 2, 'K3:K75'); % S D0
H = xlsread('mouse mech data_with linear stiff.xlsx', 2, 'L3:L75'); % S D3
T = nan(75,4); 
T(1:length(E),1)=E; 
T(1:length(F),2)=F;
T(1:length(G),3)=G;
T(1:length(H),4)=H;

Z(1,1) = mean(T(:,1),'omitnan');
Z(1,2) = mean(T(:,2),'omitnan');
Z(1,3) = mean(T(:,3),'omitnan');
Z(1,4) = mean(T(:,4),'omitnan');

%% Linear stiff
S_Abs_l = xlsread('mouse mech data_with linear stiff.xlsx', 1, 'E3:H75');
NS_Abs_l = xlsread('mouse mech data_with linear stiff.xlsx', 1, 'A3:D75');

I = xlsread('mouse mech data_with linear stiff.xlsx', 1, 'I3:I75'); % NS DO
J = xlsread('mouse mech data_with linear stiff.xlsx', 1, 'J3:J75'); % NS D3
K = xlsread('mouse mech data_with linear stiff.xlsx', 1, 'K3:K75'); % S D0
L = xlsread('mouse mech data_with linear stiff.xlsx', 1, 'L3:L75'); % S D3

T_l = nan(75,4); 
T_l(1:length(I),1)=I; 
T_l(1:length(J),2)=J;
T_l(1:length(K),3)=K;
T_l(1:length(L),4)=L;

Z_l(1,1) = mean(T_l(:,1),'omitnan');
Z_l(1,2) = mean(T_l(:,2),'omitnan');
Z_l(1,3) = mean(T_l(:,3),'omitnan');
Z_l(1,4) = mean(T_l(:,4),'omitnan');

%% Plotting 
figure();
subplot(3,2,1);
[NSlineOut, NSfillOut] = stdshade(NS_Abs_c,0.5,'b',0:3);
hold on;
[SlineOut, SfillOut] = stdshade(S_Abs_c,0.5,'r',0:3);
legend('No Stretch SEM','No Stretch Mean','Stretch SEM','Stretch Mean', 'Location','northwest','fontsize',5);
ax = gca;
ax.FontSize = 6; 
xlabel('Day of Stretch','fontsize',6.5); 
ylabel('Compaction','fontsize',6.5);
ylim([0 1]);
title(sprintf('Effect of Stretch on Gel Compaction'),'fontsize',7); 

subplot(3,2,2); 
S_c = boxplot(T_c,'symbol','','Labels',{'NS - D0','NS - D3','S - D0','S - D3'}); % 'symbol' removes outliers 
title(sprintf('Day 0 vs Day 3 Compaction'),'fontsize',7); 
ax = gca;
ax.FontSize = 6; 
ylabel('Compaction','fontsize',6.5);
ylim([0 1]);
% Change the boxplot color 
get(S_c,'tag'); 
set(S_c(6,:),'color','k','linewidth',1.5); 
color = {'r','r','b','b'};
e = findobj(gca,'Tag','Box');
for i = 1:length(e)
    patch(get(e(i),'XData'), get(e(i),'YData'), color{i}, 'FaceAlpha', 0.5);
end
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k');
hold on
plot(Z_c, 'k*', 'linewidth',0.5);

subplot(3,2,3);
[NSlineOut, NSfillOut] = stdshade(NS_Abs,0.5,'b',0:3);
hold on;
[SlineOut, SfillOut] = stdshade(S_Abs,0.5,'r',0:3);
legend('No Stretch SEM','No Stretch Mean','Stretch SEM','Stretch Mean', 'Location','northwest','fontsize',5);
ax = gca;
ax.FontSize = 6; 
xlabel('Day of Stretch','fontsize',6.5); 
ylabel('Stiffness [mN/mm^2]','fontsize',6.5);
title(sprintf('Effect of Stretch on Gel Stiffness'),'fontsize',7);
ylim([0 12]);

subplot(3,2,4); 
S = boxplot(T,'symbol','','Labels',{'NS - D0','NS - D3','S - D0','S - D3'}); % 'symbol' removes outliers 
title(sprintf('Day 0 vs Day 3 Stiffness'),'fontsize',7); 
ylim([0 35]);
ax = gca;
ax.FontSize = 6; 
ylabel('Stiffness [kPa]','fontsize',6.5);
% Change the boxplot color 
get(S,'tag'); 
set(S(6,:),'color','k','linewidth',1.5); 
color = {'r','r','b','b'};
e = findobj(gca,'Tag','Box');
for i = 1:length(e)
    patch(get(e(i),'XData'), get(e(i),'YData'), color{i}, 'FaceAlpha', 0.5);
end
hold on
plot(Z, 'k*', 'linewidth',0.5);

subplot(3,2,5);
[NSlineOut, NSfillOut] = stdshade(NS_Abs_l,0.5,'b',0:3);
hold on;
[SlineOut, SfillOut] = stdshade(S_Abs_l,0.5,'r',0:3);
legend('No Stretch SEM','No Stretch Mean','Stretch SEM','Stretch Mean', 'Location','northwest','fontsize',5);
ax = gca;
ax.FontSize = 6; 
xlabel('Day of Stretch','fontsize',6.5); 
ylabel('Linear Stiffness [mN/mm]','fontsize',6.5);
title(sprintf('Effect of Stretch on Gel Linear Stiffness'),'fontsize',7); 
ylim([0 12]);

subplot(3,2,6); 
S_l = boxplot(T_l,'symbol','','Labels',{'NS - D0','NS - D3','S - D0','S - D3'}); % 'symbol' removes outliers 
title(sprintf('Day 0 vs Day 3 Stiffness'),'fontsize',7); 
ax = gca;
ax.FontSize = 6; 
ylabel('Linear Stiffness [mN/mm]','fontsize',6.5);
% Change the boxplot color 
get(S_l,'tag'); 
set(S_l(6,:),'color','k','linewidth',1.5); 
color = {'r','r','b','b'};
e = findobj(gca,'Tag','Box');
for i = 1:length(e)
    patch(get(e(i),'XData'), get(e(i),'YData'), color{i}, 'FaceAlpha', 0.5);
end
hold on
plot(Z_l, 'k*', 'linewidth',0.5);


