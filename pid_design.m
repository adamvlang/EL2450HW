%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hybrid and Embedded control systems
% Homework 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all, clear all, clc  
init_tanks;
g = 9.82;
Tau = 1/alpha1*sqrt(2*tank_h10/g);
K = 60*beta*Tau;
Gamma = alpha1^2/alpha2^2;

%TOOOYOOTOTOTO
Ts = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Continuous Control design
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = tf('s');

upperNUM = {[K]};
upperDEN = {[Tau 1]};
lowerNUM = {[Gamma]};
lowerDEN = {[Gamma*Tau 1]};
uppertank=tf([upperNUM],[upperDEN]); % Transfer function for upper tank
lowertank=tf([lowerNUM],[lowerDEN]); % Transfer function for upper tank

uppertank=tf(upperNUM,upperDEN); % Transfer function for upper tank
lowertank=tf(lowerNUM,lowerDEN); % Transfer function for upper tank
G=uppertank*lowertank; % Transfer function from input to lower tank level

% CalculatePID paramaeters
chi = 0.5;
zeta = 0.8;
omega0 = 0.2;
[K, Ti, Td, N] = polePlacePID(chi, omega0, zeta,Tau,Gamma,K);
C = K + K/(Ti*s) + (K*Td*N*s)/(s+N);
F = C; % Transfer function for the controller
% sim('tanks')
% plot(lowerTank_result.Time,lowerTank_result.Data)
OpenLoop = F*G;
[Gm,Pm,Wgm,Wpm] = margin(OpenLoop) ;
disp(['Crossover Frequency : ' , num2str(Wpm)])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Digital Control design
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ts = 1; % Sampling time

samplingTimes = [1,2,4,8,16];
% for i = 1:length(samplingTimes)
%     Ts = samplingTimes(i);
% %     Fd = c2d(F,Ts,'zoh');    
%     sim('tanks')
%     figure
%     plot(lowerTank_result.Time,lowerTank_result.Data)
%     title(['Discrete Controller Sampling time: ',num2str(Ts)])
% %      print(['Discrete_ctrl_Sampling',num2str(Ts)],'-dpng')
% end

% Discretize the continous controller, save it in state space form
% [Aa,Ba,Ca,Da] = ; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Discrete Control design
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%To discretize the continous controller use c2d(Controller,Ts,'zoh')


Gd = G; % Sampled system model
Fd = c2d(F,Ts,'zoh'); % Transfer function for discrete designed controller