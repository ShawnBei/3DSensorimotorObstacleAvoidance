clc
close all
clear
% load('rand_phase.mat')
load('reflector_atten2.mat')

a.time_std = std(iteration_valid * 0.1);
a.collision_std = std(collision_valid);
a.tortuosity_std = std(tortuosity_valid);