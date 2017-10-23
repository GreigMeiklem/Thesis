function [ reac ] = dreac( t,x,dvvf )
%   Detailed explanation goes here
 %Maximum specific biomass growth rate, T
%General Parameters not dependent on biodegradable degrediation feed
mu = 3 / (24*60)  ; %Maximum specific biomass growth rate, T
b = 0.2 / (24*60); %Endogenous metabolism coefficient, T 1
y = 0.4; %Biomass yield coefficient, MM 1


%Readily Biodegradable feed
ks = 0.02; %Half Saturation constant
sf = 0.5 ; %Substrate Feed
sfeed = 0.5;

hrt = 0.5 * (24*60);
tfill = 5 ;
nocycle = 4/ (60*24) ;


hrt = 0.5 * (24*60);
srt = 10 * (24*60) ;
nocycle = 4  / (24 * 60);
tfill = 5 ;



%Readily Biodegradable feed
ks = 0.02; %Half Saturation constant





reac(2,1) = -mu * (x(2) .* x(1)) ./(ks + x(2)) * (1/y); %rate of substrate removal

reac(1,1) = ((mu.*x(2))./(ks  + x(2)) * x(1)) + (-b.*x(1));




end

