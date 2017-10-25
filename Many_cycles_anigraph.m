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
t_eff_span = tfill + teff + tw + treact + tset;

dt = 0.1;

conc_eff = [0.5 0.5] ; %set up for initial conditions X & V/VVF
conc_wit = [ 0 0.5 0] ;%set up for initial conditions S


no_of_cycles = 200;

%  t_fill_span =   0:dt:(tfill);
%  
%  t_reac_span = t_fill_span(end):dt:(treact + tfill);
%  
%  t_w_span = t_reac_span(end):dt:(treact + tfill+tw);
%  t_set_span = t_w_span(end):dt:(treact + tfill+tw + tset );
%  t_eff_span = t_set_span(end):dt:(treact + tfill+tw + tset+teff );
    
   
dvvf_final = 0.5;

t_eff_span(end) = 0 ;
    
for s = 1:no_of_cycles
   
 t_fill_span =   t_eff_span(end):dt:(tfill + t_eff_span(end) );
 t_reac_span = t_fill_span(end):dt:(treact + tfill+ t_fill_span(end));
 t_w_span = t_reac_span(end):dt:(tw +t_reac_span(end));
 t_set_span = t_w_span(end):dt:(tset + t_w_span(end));
 t_eff_span = t_set_span(end):dt:(teff +t_set_span(end));
 
 

 
 
 %time1 = [t_fill_span(end) t_reac_span(end) t_w_span(end) t_set_span(end) t_eff_span(end)];
 
[t_fill(:,s), conc_fill] = ode15s(@dfill, t_fill_span, [conc_eff(end,1) 0.5 dvvf_final(end) ]);
x_fill(:,s) = conc_fill(:,1);
s_fill(:,s) = conc_fill(:,2);
vvf_fill(:,s) = conc_fill(:,3);




reac_inital = [x_fill(end,s) s_fill(end,s)];

[t_reac(:,s), conc_reac] = ode15s(@dreac, [t_reac_span], reac_inital);
x_reac(:,s) = conc_reac(:,1);
s_reac(:,s) = conc_reac(:,2);
%vvf_reac(:,s) = conc_reac(:,3);


reac_inital = [x_reac(end,s) , s_reac(end,s) , vvf_fill(end,s)] ;
[t_wit(:,s), conc_wit] = ode15s(@dwith , [t_w_span] , reac_inital);

x_wit(:,s) = conc_wit(:,1);
s_wit(:,s) = conc_wit(:,2);
vvf_wit(:,s) = conc_wit(:,3);

%settle nothing happens


funchandle_eff = @(t,x) deff(t,x,s_wit(end,s));
eff_inital = [x_wit(end,s)  ,  vvf_wit(end,s)] ;

[t_eff(:,s) , conc_eff] = ode15s(@deff , [t_eff_span] , eff_inital);
x_eff(:,s) = conc_eff(:,1);
vvf_eff(:,s) = conc_eff(:,2);


t_vvf(:,s) = [t_fill(:,s) ; t_wit(:,s); t_eff(:,s)];
dvvf_final = [conc_fill(:,3) ; conc_wit(:,3) ; conc_eff(:,2)];
%dvvf_final(:,s) = [vvf_fill(:,s) ; vvf_wit(:,s) ; vvf_eff(:,s)]

x_final(:,s) = [x_fill(:,s) ; x_reac(:,s) ;x_wit(:,s) ;x_eff(:,s)];
s_final(:,s) = [s_fill(:,s) ; s_reac(:,s) ; s_wit(:,s)];
ts_final(:,s) = [t_fill(:,s); t_reac(:,s) ; t_wit(:,s) ];
tx_final(:,s) = [t_fill(:,s); t_reac(:,s) ; t_wit(:,s) ; t_eff(:,s)] ;


end

figure(1)
hold on 
plot(t_vvf,dvvf_final)
plot(ts_final , s_final)
plot(tx_final , x_final)