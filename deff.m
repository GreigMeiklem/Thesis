function [ eff ] = deff( t,x )

hrt = 0.5 * (24*60);
srt = 10 * (24*60) ;
nocycle = 4/ (60*24) ;
teff = 15 ;
%General Parameters not dependent on biodegradable degrediation feed
mu = 3/(24*60) ; %Maximum specific biomass growth rate, T
b = 0.2/(24*60); %Endogenous metabolism coefficient, T 1

%Readily Biodegradable feed
ks = 0.02; %Half Saturation constant




eff(2,1) =  - 1/(nocycle * teff)*( (1/hrt) - (1/srt) );
 eff(1,1) =   (x(1)/x(2) * 1/(nocycle * teff) * (1/ hrt - 1/srt)) ; %X
 


end

