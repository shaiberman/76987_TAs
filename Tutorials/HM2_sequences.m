%% T1 signals (Used for anatomical images) 
%% Inversion-Recovery (IR)
%
% Inversion-Recovery pulse sequences are a method for measuring  T1
% relaxation (spin-lattice). As the sequence name suggests, the pulse
% sequence first inverts the net magnetization (180 deg pulse). Then, the
% sequences simply pauses for a time, TI (Inversion Time), to let the longitudinal
% magnetization recover towards steady state across the tissue. Then, a
% 90deg pulse is delivered that places the net magnetization in the
% transverse plane.  The transverse magnetization is measured right away,
% before significant dephasing, in order to estimate the T1 properties.

% To help you visualize the events, run this code a few times.  The first
% plot shows the 180-TI-90 sequence for a relatively slow T1 value.
figure(1); clf
subplot(1,2,1);
title('Slow T1 relaxation');
T1 = 2.8;       % 2.8 sec T1
inversionRecovery(T1);

%%
% Now, suppose the tissue has a faster T1 relaxation
subplot(1,2,2); cla
title('Fast T1 relaxation')
T1 =0.6;
inversionRecovery(T1);


%% Question 1: 

%1.1 
% If we apply a 90-degree pulse at the time when exactly half the signal was
% recovered, what do you expect the transverse magnetization to be?

% 1.2
% Is this the same as applying a 90-degree pulse at T1? (Why or why not?)


% 1.3 
% Comparing the two panels, what aspect of the signal might help us
% differentiate different T1 values? 

% 1.4
% Try to explain in your own words why this is a T1-weighted sequence
% (How do we avoid T2 effects). 
 

%% T2 images (Used for BOLD imaging)
%% Spin Echo (Hahn)
%
% In principle, to make a T2-weighted measurement we need only to flip the net
% magnetization 90 deg and then measure the signal decay as the spins
% dephase. Because the T2 reduction is very fast compared to the T1
% reduction, the decay will be nearly all due to T2 effects.
%
% The spin-spin dephasing occurs so quickly that it is almost impossible to
% obtain a T2 measurement soon enough after the 90 deg flip. The Hahn Spin
% Echo, and its partner the Gradient Echo, make it possible to separate the
% time between the pulse and the measurement.
%
% The next visualizataion shows two spins within a single voxel.  These
% spins are experiencing slightly different local magnetic fields.
% Consequently, one precesses around the origin slightly faster than the
% other.  After a little time the signals are well out of phase. Then, a
% 180 deg inverting pulse is introduced. This pulse rotates the spins
% around the horizontal axis (x-axis). Seen within the plane, this causes
% the two spins to reverse positions so that the leader becomes the
% follower. The leader is still in a higher local field, and so after a
% while it catches up.  At this moment the spin phases come together to
% create an echo of the signal after the first 90 deg pulse. This echo
% happens at a point in time that is well separated from the inverting
% pulse.
%

% The time until the inverse pulse determines when the echo will occur
TE = 16;        
figure(1); clf; title('Transverse plane'); spinEcho(TE);

%% Question 2: 

%2.1 
% Schematically plot the approximate shape of the signal (as a function of time)
% based on the simulation? 

% 2.2 
% How would the signal look differently for different T2 relaxation times?

 

