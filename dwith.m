function [ with ] = dwith( t,x )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
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
tw = 5; %Waste time unfill
tfill = 5 ;


%Readily Biodegradable feed
ks = 0.02; %Half Saturation constant


%[X    S     V/VF ] matrix order

with(3,1) = -1/(nocycle*tw*srt);
with(2,1) = -mu * x(2) * x(1) /(ks + x(2)) * 1/y ;

with(1,1) =  mu*x(2) * x(1) / (ks + x(2))  ;





end

