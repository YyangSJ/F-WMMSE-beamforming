
%% SNR 
S_MMSE =[ 0.3490    1.0811    3.2167    8.6605   19.3964   34.5302];
S_WMMSE =[ 2.6314    5.7699   11.3523   20.0071   31.8849   46.5176];
S_FWMMSE1 =[  4.3492    8.2589   14.6096   24.4930   38.3339   54.8931]; % movable region 8 4 K=4
S_FWMMSE2 =[5.0193    9.1527   15.7046   25.9876   39.8644   55.7560]; % movable region 12 6  K=4

% axis([2,16,6e-5,30])


S_MMSE =[  0.4686    1.4144    3.9434    9.4074   18.2430   29.2763];
S_WMMSE =[ 2.2183    4.6919    8.9084   15.2360   23.7267   34.0509];
S_FWMMSE1 =[ 3.5814    6.4287   11.2289   18.5013   28.3517   40.1531];% movable region 8 4  K=2
S_FWMMSE2 =[ 4.0864    6.9875   11.9164   19.4215   29.5436   41.4935];% movable region 12 6  K=2

co1= [0, 161, 241]/255;
co2=[29, 191, 151]/255
co3= [70, 158, 180]/255
co4=[253,185,106]/255
co5=[214,64,78]/255

%% iteration
S_MMSE =  19.4125*ones(25,1)

S_WMMSE =[24.5012   28.4322   29.9578   30.6602   31.0367   31.2638   31.4117   31.5136   31.5872   31.6425   31.6851   31.7186   31.7456 31.7680   31.7867   31.8024   31.8154   31.8264   31.8356   31.8435   31.8501   31.8559   31.8608   31.8652   31.8692]

S_FWMMSE1 =[30.1177   33.9468   35.4577   36.2147   36.6995   37.0326   37.2545   37.4370   37.5662   37.6827   37.7897   37.8693   37.9354 37.9914   38.0385   38.0795   38.1086   38.1405   38.1769   38.2055   38.2155   38.2506   38.2694   38.2879   38.3041] % 8 4
S_FWMMSE2 =[   31.7024   35.4393   36.7773   37.5262   37.9642   38.2971   38.5607   38.7303   38.8557   38.9860   39.0842   39.1816   39.2844 39.3721   39.4298   39.5020   39.5539   39.5731   39.6091   39.6664   39.7419   39.7912   39.8149   39.8612   39.8830] %  12 6


S_MMSE = 3.2160*ones(25,1)

S_WMMSE =[9.8810   10.8568   11.1336   11.2386   11.2866   11.3116   11.3261   11.3351   11.3411   11.3452   11.3482   11.3504   11.3520 11.3533   11.3544   11.3552   11.3559   11.3564   11.3569   11.3573   11.3577   11.3580   11.3583   11.3586   11.3588]

S_FWMMSE1 =[12.2197   13.3885   13.8314   14.0606   14.2100   14.3009   14.3692   14.4179   14.4534   14.4786   14.4984   14.5102   14.5224 14.5315   14.5402   14.5479   14.5532   14.5589   14.5633   14.5687   14.5728   14.5750   14.5783   14.5796   14.5828]

S_FWMMSE2 =[12.9801   14.2212   14.7235   15.0043   15.1880   15.3053   15.3967   15.4641   15.5170   15.5540   15.5847   15.6077   15.6289 15.6436   15.6574   15.6674   15.6751   15.6826   15.6864   15.6901   15.6938   15.6954   15.6974   15.7002   15.7015]
figure
plot(1:25, S_MMSE, 'dk-', 'linewidth', 1.1, 'markerfacecolor', co1,'markersize', 7)
hold on
plot(1:25, S_WMMSE, '^k-', 'linewidth', 1.1, 'markerfacecolor', co2,'markersize', 6.5)
hold on
plot(1:25, S_FWMMSE1, 'sk-', 'linewidth', 1.1, 'markerfacecolor', co5,'markersize', 7.2)
hold on
plot(1:25, S_FWMMSE2, 'ok-', 'linewidth', 1.1, 'markerfacecolor', co4,'markersize', 6.5)
hold on 
grid on
 lgh=legend('MMSE','WMMSE','F-WMMSE, $U_t=4\lambda, U_r=2\lambda$'...
     ,'F-WMMSE, $U_t=6\lambda, U_r=3\lambda$');
  %lgh=legend('WMMSE, $$L=5$$','WMMSE, $$L=10$$','F-WMMSE, $$L=5$$','F-WMMSE, $$L=10$$');
set(lgh,'interpreter','latex', 'fontsize', 13); 
xlabel('Iteration Number','interpreter','latex','fontsize',13)
ylabel('Sum Rate','interpreter','latex','fontsize',13)

axis([1,25,2,20])
%% RM

%S_MMSE =  17.5904*ones(1,7);
S_WMMSE1 = 31.0030*ones(1,7);   
S_WMMSE2 =31.8692*ones(1,7);

S_FWMMSE1 =[31.0030   32.5904   33.2634   33.6424   33.8575   34.0403   34.1702] % L=5

S_FWMMSE2 =[31.8692   33.6364   34.5635   35.1922   35.6671   35.9843   36.3131]  % L=10

figure
plot(2:8, S_WMMSE1, 'dk-', 'linewidth', 1.1, 'markerfacecolor', co1,'markersize', 7)
hold on
plot(2:8, S_WMMSE2, '^k-', 'linewidth', 1.1, 'markerfacecolor', co2,'markersize', 6.5)
hold on
plot(2:8, S_FWMMSE1, 'sk-', 'linewidth', 1.1, 'markerfacecolor', co5,'markersize', 7.2)
hold on
plot(2:8, S_FWMMSE2, 'ok-', 'linewidth', 1.1, 'markerfacecolor', co4,'markersize', 6.5)
hold on 
grid on
 % lgh=legend('MMSE','WMMSE','F-WMMSE, $U_t=4\lambda, U_r=2\lambda$'...
 %     ,'F-WMMSE, $U_t=6\lambda, U_r=3\lambda$');
  lgh=legend('WMMSE, $$L=5$$','WMMSE, $$L=10$$','F-WMMSE, $$L=5$$','F-WMMSE, $$L=10$$');
set(lgh,'interpreter','latex', 'fontsize', 13); 
xlabel('Receive movable region $$U_r$$','interpreter','latex','fontsize',13)
ylabel('Sum Rate','interpreter','latex','fontsize',13)

axis([2,8,30,38])

S_MMSE = 19.4125


%% TM
S_MMSE =17.5904
S_WMMSE1 =31.0030*ones(1,9);
S_FWMMSE1 =[31.0030   32.9220   33.9256   34.5742   35.0520   35.4286   35.6992   35.9436   36.1451] %L=5


S_MMSE =  19.4125
S_WMMSE2 =  31.8692*ones(1,9);
S_FWMMSE2 =[31.8692   34.1347   35.3253   36.1370   36.7628   37.2415   37.6166   37.9519   38.1932] %L=10

figure
plot(4:12, S_WMMSE1, 'dk-', 'linewidth', 1.1, 'markerfacecolor', co1,'markersize', 7)
hold on
plot(4:12, S_WMMSE2, '^k-', 'linewidth', 1.1, 'markerfacecolor', co2,'markersize', 6.5)
hold on
plot(4:12, S_FWMMSE1, 'sk-', 'linewidth', 1.1, 'markerfacecolor', co5,'markersize', 7.2)
hold on
plot(4:12, S_FWMMSE2, 'ok-', 'linewidth', 1.1, 'markerfacecolor', co4,'markersize', 6.5)
hold on 
grid on
 % lgh=legend('MMSE','WMMSE','F-WMMSE, $U_t=4\lambda, U_r=2\lambda$'...
 %     ,'F-WMMSE, $U_t=6\lambda, U_r=3\lambda$');
  lgh=legend('WMMSE, $$L=5$$','WMMSE, $$L=10$$','F-WMMSE, $$L=5$$','F-WMMSE, $$L=10$$');
set(lgh,'interpreter','latex', 'fontsize', 13); 
xlabel('Transmit movable region $$U_t$$','interpreter','latex','fontsize',13)
ylabel('Sum Rate','interpreter','latex','fontsize',13)

axis([4,12,30,40])

%% PATH

S_MMSE =[19.2412    17.5904  19.1297  20.0780  20.8034 21.1838]
S_WMMSE =[ 22.0009    31.0030  31.8592  32.0651  32.3315 32.4698]
S_FWMMSE2 =[ 23.3316    37.2940  39.7084  40.4628  40.8674  40.9944] % 12 6
S_FWMMSE1 =[   23.2359   36.5230  38.2026  38.5906 38.9276   39.0479] % 8 4


figure
plot(1:4:21, S_MMSE, 'dk-', 'linewidth', 1.1, 'markerfacecolor', co1,'markersize', 7)
hold on
plot(1:4:21, S_WMMSE, '^k-', 'linewidth', 1.1, 'markerfacecolor', co2,'markersize', 6.5)
hold on
plot(1:4:21, S_FWMMSE1, 'sk-', 'linewidth', 1.1, 'markerfacecolor', co5,'markersize', 7.2)
hold on
plot(1:4:21, S_FWMMSE2, 'ok-', 'linewidth', 1.1, 'markerfacecolor', co4,'markersize', 6.5)
hold on 
grid on
 lgh=legend('MMSE','WMMSE','F-WMMSE, $U_t=4\lambda, U_r=2\lambda$'...
     ,'F-WMMSE, $U_t=6\lambda, U_r=3\lambda$');
 %lgh=legend('WMMSE, $$L=5$$','WMMSE, $$L=10$$','F-WMMSE, $$L=5$$','F-WMMSE, $$L=10$$');
set(lgh,'interpreter','latex', 'fontsize', 13); 
xlabel('Number of Channel Paths $$L$$','interpreter','latex','fontsize',13)
ylabel('Sum Rate','interpreter','latex','fontsize',13)

axis([1,21,16,42])
