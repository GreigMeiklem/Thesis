%Attept 4 
clear;clc
%General Parameters not dependent on biodegradable degrediation feed
mu = 3 / (24*60)  ; %Maximum specific biomass growth rate, T
b = 0.2 / (24*60); %Endogenous metabolism coefficient, T 1
y = 0.4; %Biomass yield coefficient, MM 1

%Readily Biodegradable feed
ks = 0.02; %Half Saturation constant
sf = 0.5 ; %Substrate Feed

%Slowly Biodegradable feed
xsf =  0.5; %Slowly biodegradable substrate concentration, ML 3
kx = 0.03; %Half saturation constant for slowly biodegradable substrate, MM 1
kh = 2; %Hydrolysis rate constant, MM 1T 1

%Time dependent Parameters
tfill = 5 ; %Filling time days
teff = 15 ; %effluent time
nocycle = 4 / (60*24) ; %full sycles per day (dt for integtal solve) End cycle per hour
hrt = 0.5 * 60 * 24 ; %Hydraulic retention time days
srt = 10 * 60 * 24; %Solids Retention Time 
tw = 5; %Waste time unfill
treact = 290 ;
tset = 45 ; 
dt = 0.1;
vvfin = 0.5;

dt = 0.001;





t_fill_span = 0:dt:tfill;
t_reac_span = tfill:dt:(treact + tfill);
t_w_span = t_reac_span(end):dt:(treact + tfill+tw);
t_set_span = t_w_span(end):dt:(treact + tfill+tw + tset);
t_eff_span = t_set_span(end):dt:(treact + tfill+tw + tset+teff);


for z = 1:ss


fill_in = [0.5 0.5 0.5] ;
conc_eff = [0.5 0.5 0.5]


[t_fill, conc_fill(:,i)] = ode15s(@dfill, t_fill_span, fill_in);

reac_inital = [conc_fill(end,1) conc_fill(end,2)];

[t_reac, conc_reac(:,i)] = ode15s(@dreac, [t_reac_span], reac_inital);

reac_inital = [conc_reac(end,1) , conc_reac(end,2) , conc_fill(end,3)] ;
[t_wit, coc_wit(:,i)] = ode15s(@dwith , [t_w_span] , reac_inital);

%settle nothing happens

funchandle_eff = @(t,x) deff(t,x,coc_wit(2,end));
eff_inital = [coc_wit(end,1)  ,  coc_wit(end,3)] ;

[t_eff , conc_eff(ss] = ode15s(@deff , [t_eff_span] , eff_inital);


t_vvf = [t_fill;t_wit;t_eff];
dvvf_final = [conc_fill(:,3) ; coc_wit(:,3) ; conc_eff(:,2)];

x_final(ss) = [conc_fill(:,(1 + 3*(ss-1))) ; conc_reac(:,(1 + 3*(ss-1)) ;coc_wit(:,(1 + 3*(ss-1))) ; conc_eff(:,(1 + 3*(ss-1))];
t_final(ss) = [t_fill; t_reac ; t_wit ; t_eff] ;
figure(1)
hold on 
plot(t_vvf,dvvf_final)

figure(3)
hold on
plot(t_final , x_final)

end


