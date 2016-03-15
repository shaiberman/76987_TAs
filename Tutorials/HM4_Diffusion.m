%% Tutorial 4 - diffusion imaging
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% The purpose of this tutorial is to illustrate the nature of the data
% acquired in a diffusion weighted imaging scan. In 2 weeks we will use the
% same simulations but add some statistical analysis of the data. 


%% Self-diffusion of water
%
% The self-diffusion coefficient of water (in micrometers^2/millisecond) is
% dependent on the temperature and pressure. Several groups have derived
% quantitative descriptions of the relationship between temperature,
% pressure, and the diffusion coefficient of water. Here we use the formula
% presented in:
%   Krynicki, Green & Sawyer (1978) Pressure and temperature dependence of
%   self-diffusion in water. Faraday Discuss. Chem. Soc., 66, 199 - 208.
% Also see http://www.lsbu.ac.uk/water/explan5.html and Mills (1973)
% Self-Diffusion in Normal and Heavy Water. JPhysChem 77(5), pg. 685 - 688.

% Standard atmospheric pressure at sea level, in kilo Pascals (kPa):
P = 101.325;

% Let's define a function that implements the Krynicki formula. This will
% return the self-diffusion of water (in micrometers^2/millisec) given the
% temperature T (in Celcius) and the pressure P (in kPa).
selfDiffusionOfWater = @(T,P) 12.5 .* exp(P*-5.22*10^-6) .* sqrt(T+273.15) .* exp(-925.*exp(P.*-2.6.*10^-6)./(T+273.15-(95+P.*2.61.*10^-4)));

% The self-diffusion of water at body temperature and standard pressure is:
selfDiffusionOfWater(37,P)

% Let's plot D for a biologically meaningful range of temperatures
T = [25:40];
D = selfDiffusionOfWater(T,P);
figure(1);
plot(T, D, 'k');
xlabel('Temperature (Centigrade)');
ylabel('Self-diffusion of water (\mum^2/ms)')

line([37 37], [2 4], 'color', 'r');
text(37, 3.8, 'Body Temperature', 'HorizontalAlignment', 'center','color','r');

%% Question 1 - the effect of T and P on diffusion
% Say you are running an MRI experiment, scanning healthy subjects in the
% ENU in Jerusalem, and you're acquiring DWI (diffusion weighted imaging)

% 1.1. There is a technical problem in our magnet and you need to scan ONE
% of your subjects in Tel-aviv (at sea level). You know that the
% atmospheric pressure in the 2 cities is different. Should you take it in
% to account when analyzing your data? will it cause a substantial
% difference in the diffusion? (find the average atmospheric pressure in
% Jerusalem and calculate the difference (in percent) between the
% self-diffusion coefficient of water at body temperature in the 2 cities).

% 1.2. A few weeks later, back in Jerusalem, you arrive to a scan session
% to find your subject has arrived but is running a fever of 40 deg
% Celcius. He didn;t think to cancel because he didn't think it would
% affect your diffusion scan. Is he right? (Compared to someone without a
% fever, how much higher (in percent) is the water diffusion coefficient in
% your subject's body?

% Please show your calculations for both answers.
%% Brownian motion
% Here we simulate the brownian motion in a small chunk of tissue.

% parameters intializiation:
voxelSize = 50.0;% The size of the simulated voxel, in micrometers
timeStep = 0.02;% Define the time-step (in milliseconds)
nTimeSteps = 100;% The number of time-steps
ADC = 2.0;% The ADC (in micrometers^2/millisecond)
numParticles = 500;% The number of particles to simulate

% We'll start with a 'tissue' that has no barriers - the water may freely
% diffuse.Next week we see what happen when we add barriers. Of course, you
% are more than welcome to play with right now. 
barrierSpacing = 0;

% initialize figures
axLims = [-voxelSize/2 voxelSize/2];
figure(2); clf;
xlabel('X position (micrometers)');
ylabel('Y position (micrometers)');
axis square;
axis([axLims axLims]);
set(gca,'ALimMode','manual','XTick',[axLims(1):10:axLims(end)],'YTick',[axLims(1):10:axLims(end)]);

% Place some particles randomly distributed in the volume
r = sqrt(rand(numParticles,1))*voxelSize/2;
[x,y] = pol2cart(rand(numParticles,1)*2*pi, r);
startPos = [x,y];
curPos = startPos;
hold on;
for(p=1:numParticles)
    ph(p) = plot(curPos(p,1), curPos(p,2), '.','markerSize',12);
end
% if we have barriers, 
if(barrierSpacing>0)
    curCompartment = floor(curPos(:,2)/barrierSpacing);
    compartments = unique(curCompartment);
    for(ii=1:numel(compartments))
        line(axLims,[compartments(ii)*barrierSpacing compartments(ii)*barrierSpacing],'color',[.7 .7 .8]);
    end
    cmap = hsv(numel(compartments));
    for(p=1:numParticles)
        set(ph(p), 'color', cmap(curCompartment(p)==compartments,:));
    end
end
hold off;
grid on;
ah = gca;

%% Run the diffusion simulation
totalTime = 0;
for(ti=1:nTimeSteps)
    % Update all the particle positions given the ADC. The diffusion
    % equation tells us that the final position of a particle moving in
    % Brownian motion can be described by a Gaussian distribution
    % with a standard deviation of sqrt(ADC*timeStep). The following lines
    % will update the current particle position by drawing numbers from a
    % Gaussian with this standard deviation.
    d = randn(numParticles,2)*sqrt(2*ADC*timeStep);
    newPos = curPos+d;
    if(barrierSpacing>0)
        curCompartment = floor(curPos(:,2)/barrierSpacing);
        newCompartment = floor(newPos(:,2)/barrierSpacing);
        reflectTheseParticles = newCompartment~=curCompartment;
        % A simple hack to approximate particles reflecting off the impermeable barrier
        newPos(reflectTheseParticles,2) = curPos(reflectTheseParticles,2) - d(reflectTheseParticles,2);
    end
    curPos = newPos;
    % Draw the particles in their new positions:
    for(p=1:numParticles)
        set(ph(p), 'XData', curPos(p,1), 'YData', curPos(p,2));
    end
    % To avoid biasing our ADC estimates with edge effects, we allow
    % particles to move outside of our simulated voxel.
    set(get(ah,'Title'),'String',sprintf('elapsed time: %5.1f ms',timeStep*ti));
    % Pause is specified in seconds, so the following will play the movie
    % about 1000 times slower than reality.
    pause(timeStep-.01);
    totalTime = totalTime + timeStep;
end


%% Show where each particle came from:
hold on;
for(p=1:numParticles)
    sh(p) = plot([startPos(p,1) curPos(p,1)], [startPos(p,2) curPos(p,2)], '-', 'color', [.9 .9 .9]);
end
hold off;


%% Question 2: 
%  What is the average (euclidean) distance that each particle moved? 
% (Use startPos and curPos)

%% Question 3:
% Say we want a greater weighting of diffusion, we've learned in class that
% this can be achieved by increasing our b-value. We also learned that we
% can increase the b-value in 2 different Ways: (1) stronger gradients (2)
% longer diffusion time. Many times we prefer the former option. Try to
% think why that is and what disadvantages there might be to taking longer
% and longer diffusion times (remember the basic DWI protocol is spin-echo
% based).Explain your answer.

