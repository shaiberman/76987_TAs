%% Part 1 - DTI

% Today we will run the same basic diffusiom simulation, but add barriers
% and calculate the diffusion tensor. This will hopefullt lead to a better
% understanding of the relationship between the tissue microstructure and
% the final data set we get

%% parameters intializiation
% Here we simulated the brownian motion in a small chunk of tissue.
% First we should define our smulation paramteres.

voxelSize = 50.0;% The size of the simulated voxel, in micrometers
timeStep = 0.02;% Define the time-step (in milliseconds)
nTimeSteps = 100;% The number of time-steps
ADC = 2.0;% The ADC (in micrometers^2/millisecond)
numParticles = 500;% The number of particles to simulate

% We'll start with a 'tissue' that has no barriers - the water may freely diffuse.
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


    %%
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
    
    
    % Show where each particle came from:
    hold on;
    for(p=1:numParticles)
        sh(p) = plot([startPos(p,1) curPos(p,1)], [startPos(p,2) curPos(p,2)], '-', 'color', [.9 .9 .9]);
    end
    hold off;
    
    
    %% tensor fitting 
    % We can compute the diffusion tensor. This is essentially just a 2-d
    % Gaussian fit to the position differences, computed using Matlab's
    % covariance function (cov). We also need to normalize the positions by the
    % total time that we diffused.
    Dt = cov(startPos-curPos,1)./(2*totalTime)
    % The eigensystem of the diffusion tensor describes an isoprobability
    % ellipse through the data points.
    [vec,val] = eig(Dt);
    estimatedADC = diag(val)'
    principalDiffusionDirection = vec(2,:)
    
    

%% Question 1

% 1.1. Run the simulation with and without barriers by adjusting the
%    'barrierSpacing' variable. How does the diffusion tensor change?
%    explain

% 1.2. Adjust the barrier spaceing (try values 1:10). What effect does this
%     have on the princpal diffusion direction? On the estimatedADC values?
%     explain

% 1.3. With barriers in place, reduce the number of time steps (nTimeSteps).
%    How does this affect the estimatedADC values? Explore the interaction
%    between the barrier spacing and the number of time steps. Describe and
%    explain your findings .





