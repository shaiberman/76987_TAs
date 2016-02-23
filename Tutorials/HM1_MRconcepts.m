%% Tutorial:  Basic MR concepts

%% 
% In this tutorial, principles are illustrated for signals derived from a
% bulk substance, such as a beaker of water. Various terms used to describe
% the MR principles, including spins, parallel and anti-parallel, Boltzman
% distribution are introduced.

%% Spin velocity - Question 1
% When a substance with net spin is placed in a steady magnetic field, it
% precesses at a frequency that is characteristic of that substance. We saw
% in class the simple formula for the computation of the precession
% frequency (see chapter 3 and ca. p. 51i, 60ii for a discussion of
% precession).

%1.1.
% Compute the Larmor frequency of Hydrogen in a 1.5T magnetic field, given
% that the gyromagnetic ratio of hydrogen is the following: 
B0 = 1.5;     % Magnetic field strength (Tesla)
gH = 42.58e+6; % Gyromagnetic constant for hydrogen (Hz / Tesla)
vH=[];
fprintf('The resonant frequency of spins in hydrogen is %0.4f (MHz) at %.2f Tesla \n',vH/(10^6),B0);

%1.2.
% Compute the Larmor frequency of Sodium in a 3T magnetic field, given
% that the gyromagnetic ratio of Sodium is the following: 
B0=3; 
gNa=11.27e+6;
vNa=[];
fprintf('The resonant frequency of spins in sodium is %0.4f (MHz) at %.2f Tesla \n',vNa/(10^6),B0);

%% Spin Energy 
%
% At steady state, say when the subject enters the magnet and prior to any
% measurements, the dipoles align parallel or anti-parallel to the magnetic
% field. The physical separation of spin-up (parallel) and spin-down
% (anti-parallel) particles, reflects an energy difference between the
% two states (Zeeman effect, http://mri-q.com/energy-splitting.html)
%
% The energy difference between these two states of a precesing spin is
% proportional to its resonant frequency (and therfore to the magnetic
% field). The constant of proportionality between energy and frequency is
% called Planck's constant. The energy differnce is called the transition
% energy, as it is the energy required for causing hte spin to transition
% from parallel to anti-parallel (and the energy that is emitted when the
% spin transitions from anti-parallel to parallel). This also teaches us
% that the parallel state is the low-energy state and the anti-parallel is
% the high-energy state. 

h = 6.626e-34; % Planck's constant (J s)
dE = h * vH; %   Transition energy
% and also: dE = h * gH * B0;
fprintf('The transition energy of a hydrogen spin in a 3T magnetic field is %d \n' ,dE);

B0vec=[0:0.5:30];
vHvec=gH * B0vec;
dEvec = h * vHvec; 
Evec=linspace(2e-25,1e-25,length(B0vec));% arbitrary numbers
mrvNewGraphWin;
subplot(2,1,1), plot(B0vec,Evec ,B0vec, Evec+dEvec), title('Energy Level')
xlabel('B0'), ylabel('E'), legend('Spin = -1/2','Spin = +1/2')
set(gca,'YTick',[])
subplot(2,1,2), plot(B0vec,dEvec), title('Energy Gap ### TANSITION ENERGY')
xlabel('B0'), ylabel(['\Delta', 'E'])

%% Question 2
% Describe what we see in the graph

%% Bulk magnetization  

% we measure the sum magnetization of many dipoles. Therefore, it is
% important to have an unequal number of dipoles in each state, otherwise,
% the net magnetiztion would be zero. The proportion of dipoles aligned
% parallel (low energy) (high energy) to the main field is described by the
% Boltzmann distribution.

k = 1.3805e-23;      % Boltzmann's constant, J/Kelvin
T = 300;             % Degrees Kelvin at room temperature
ratioHigh2Low = exp(-dE/(k*T));  % Boltzmann's formula, Hornak, Chapter 3; Huettel, p. 76ii

% Under typical conditions the number of dipoles in the low and high energy
% states are very similar:
fprintf('Ratio of the probabilities of the dipoles to be in the high vs. low energy state:  %e \n',ratioHigh2Low)

%% Question 3
% 3.1
% At low temperatures (near absolute zero), very few of the dipoles enter
% the high (anti-parallel) energy state. How would that affect the signal?
% 3.2
% How would the transition energy affect the signal.

%%  affecting the bulk magnetization
T = logspace(-3,2.5,50);
r = exp( -dE ./ (k*T));  
mrvNewGraphWin;
semilogx(T,r);
xlabel('Temperature (K)'); ylabel(' P (parallel) / P(anti-parallel) ')
set(gca,'ylim',[-0 1.1]); grid on
%% Question 4 

%4.1
% Where is human body temperature on the graph?  Given human body
% temperature, what is the ratio of p(high)/p(low energy)? what would happen if
% we kept the room cooler?
% 4.2
% is there anything else we can control to try and affect the ratio ? plot
% the ratio with respect to this parameter to determine whether it's an
% effective solution. EXPLAIN YOUR ANSWER
