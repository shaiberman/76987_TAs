%% Tutorial:  MR Imaging

%%  MR Image Formation 
%
% How can we distinguish signals from different locations?  
%  Consider a simple situation in which we have two beakers of water
%  sitting next to one another on a table. To start, suppose the magnetic
%  field is uniform, and suppose that we measure T1.

% Our beakers' properties are the following:
larmorFreq(1) = 12;     % Larmor frequency in MHz/10
larmorFreq(2) = 18;     % Larmor frequency in MHz/10
T1(1) = 1.5;
T1(2) = 3;
t = (0:.005:1)*(3*max(T1)); % Time samples in secs
Mo = 1;                 % Net magnetization at equilibrium (at time 0)

% The function rfSignal produces the RF signal that we will measure given a
% particular time constant and Larmor frequency.
signal = rfSignal(T1(1),Mo,t,larmorFreq(1));
figure(1); clf
subplot(1,2,1), plot(t,signal); grid on
xlabel('Time (s)'); ylabel('RF signal'); title('Beaker signal');

% The RF signal is periodic. We can summarize the amplitude and frequency
% of this signal by plotting the Fourier Transform amplitude spectrum. This
% plots the amplitude of each harmonic (temporal frequency) in the signal.
subplot(1,2,2), cla
[s,f] = powerSpecDens(signal);
plot(f,s); grid on;
xlabel('Normalized frequency'); ylabel('Normalized power');  
%% Question 1
% What (tissue characteristic) determines the frequency around which the power
% spectrum is centered?

%% Changing T1: constant Larmor frequency
% Next, consider the signal as the relaxation constant (T1) increases. Note
% that over the same period of time, there Signal has a larger amplitude
% (there is less decay).
clf;
tConstant = [1,2,4]; 
for ii=1:3
    subplot(3,1,ii); set(gca,'ylim',[-1,1]);
    signal = rfSignal(tConstant(ii),Mo,t,larmorFreq(1));
    plot(t,signal); hold on;
    xlabel('time (s)'), ylabel('RFsignal'), 
    title(['T1: ', num2str(tConstant(ii))])
end
hold off


%%  Question 2:
% Plot the Fourier Transform for each of the three subplots. [Use the for
% loop above and the code in lines 31:35. Explain the difference between
% the 3 graphs and what they mean.
%% Changing the field strength; constant  T1. 
%
% Now, suppose that we change the magnetic field strength. Remember that the
% Larmor frequency is proportional to the magnetic field. Consequently,
% the frequency of the RF signal will increase.  We can compare the signals
% at two different frequencies as follows;
larmorFreq = [6, 124];
nFreqs = length(larmorFreq);
B0={'low','high'};
clf
for ii=1:nFreqs
    subplot(2,nFreqs,ii); set(gca,'ylim',[-1,1]);
    signal = rfSignal(T1(1),Mo,t,larmorFreq(ii));
    plot(t,signal)
    xlabel('time'), ylabel('signal'), title([B0{ii},' B0: \omega = ',num2str(larmorFreq(ii))])
end
%% the FT

% It is easiest to see the change in frequency if we compute the Fourier
% Transform of the two signals.
for ii=1:nFreqs
    subplot(2,nFreqs,ii+nFreqs); set(gca,'ylim',[0,25]);
    signal = rfSignal(T1(1),Mo,t,larmorFreq(ii));
    [s,f] = powerSpecDens(signal);
    plot(f,s,'b-'); grid on; set(gca,'ylim',[0,1],'xlim',[0 1]); grid on;
    title(sprintf('Fourier Spectrum of Signal %.0f',ii))
    xlabel('Normalized freq')
end
%%
% This figure is important.  It shows that the frequency of the response
% from each beaker depends on the local magnetic field.  We have already
% seen that the amplitude at the response frequency depends on the time
% constant.  We can take advantage of these two observations by introducing
% a gradient into the magnetic field. 
%
% By inserting a gradient, the two beakers experience slightly different
% magnetic fields and thus the signals have two different Larmor
% frequencies. The combined RF signal from the two beakers will be the
% sum of the signals from the two beakers.
%
%% combined signal: same T1 

signal =  rfSignal(T1(1),Mo,t,larmorFreq(1)) + rfSignal(T1(1),Mo,t,larmorFreq(2));

clf, subplot(1,2,1), plot(t,signal); grid on
xlabel('Time (s)'); ylabel('RF signal'); title('Two beakers in gradient');

% We can see the amplitude of the signals from each of the beakers by
% plotting the Fourier Transform spectrum
subplot(1,2,2); cla
[s,f] = powerSpecDens(signal);
plot(f,s,'k'); grid on;
set(gca,'ylim',[0,1],'xlim',[0 0.5]); grid on;
xlabel('Normalized freq')
ylabel('Amplitude')

 %% combined signal: different T1 
% Finally, if the two beakers represent substances with different time
% constants, we will be able to measure this by estimating the amplitudes
% of the two peaks in the spectrum.  Next, we create a signal in which the
% two beakers are in a gradient and the substances have slightly different
% time constants.
% 
signal =  rfSignal(T1(1),Mo,t,larmorFreq(1)) + rfSignal(T1(2),Mo,t,larmorFreq(2));
clf, subplot(1,2,1), plot(t,signal,'k'); grid on
xlabel('Time (s)'); ylabel('RF signal'); title('Two beakers in gradient');

% You can see that the amplitude of peaks in the signal change, reflecting
% the different time constants.  We can distinguish which amplitude is
% associated with which beaker because their responses are at different
% frequencies.
subplot(1,2,2); cla
[s,f] = powerSpecDens(signal);
plot(f,s,'k'); grid on;

set(gca,'ylim',[0,2]); grid on;
xlabel('Normalized Frequency'); ylabel('Normalized Power'); title('Fourier Space');

%%  Question 3:

% The figures above helps us understand how RF signal frequencies are
% associated with different spatial locations. When computing the RF signal
% in the last example, which variable(s) represented the magnetic field
% gradient? explain

%% Intro to k-space
%
% This simple example provides you with the basic principles of an
% important MR imaging term: k-space. Specifically, in this example the
% frequency axis of the Fourier Transform is analogous to k-space.
%
% There are important limitations to the method we have developed up this point.
% % Mainly, this method works if we only need to make images of an array of
% % beakers along a line. To make estimates of beakers spread across a table
% % top (2D) or filling up a box (3D) we need to do more.  These methods will
% % be explained below. 
% % The main difference between this example and general imaging is
% % dimensionality. In MR imaging the stimuli don't fall along one dimension,
% % so we can't simply use a one-dimensional frequency axis to assign
% % position.  In general the position in k-space corresponds to a position
% % in a two-dimensional plane that represents various spatial frequencies.
%
 

%% Slice selection pulse 
%
% The data are (usually) acquired using a series of measurements from
% different planar sections (slices) of the tissue. The measurements are
% made by selectively exciting the spins, one planar section at a time.  If
% only one plane is excited, then we can be confident that the signal we
% measure must arise from a voxel in that plane.
% 
% The principles used to understand slice selection are the same as the
% principles used to distinguish signals from beakers at two positions.
% The main difference is that in the previous example we used gradients to
% distinguish received signals. In slice selection we use gradients to
% selectively deliver an excitation.
%
% The idea is this:  We introduce a magnetic field gradient across the 
% sample changing the Larmor frequency across the sample.  
% When we deliver an RF pulse at a particular frequency, then,
% only the spins in one portion of the gradient field will be excited.
%
% What would such a pulse look like? Let's create some examples.
%

% Let's perform some example calculations. We initialize the rfPulse to
% zero, and then we initialize some parameters.
nTime = 256;  t = (1:nTime)/nTime - 0.5;
rfPulse = zeros(1,nTime); 
pulseDuration = round(nTime/2);
pulseStart = nTime/2 - pulseDuration/2;
pulseStop = pulseStart + pulseDuration-1;
pulseT = t((pulseStart:pulseStop));

% We choose a pulse frequency.  This frequency will excite the planar
% section of the tissue that is at the Larmor frequency we wish to excite.
% 
pulseFreq = 25;

% Now, create a sinusoid RF pulse at that frequency.
rfPulse(pulseStart:pulseStop) = sin(2*pi*pulseFreq*pulseT);
figure(1); clf;
subplot(1,2,1), plot(t,rfPulse); xlabel('Time'); ylabel('RF signal'); 
title('RF pulse'); grid on

% Here is the Fourier Transform spectrum of the RF pulse.
% The frequency content of the pulse determines which plane we excite.
subplot(1,2,2), 
[s,f] = powerSpecDens(rfPulse);
plot(f,s); grid on;
xlabel('Normalized frequency'); ylabel('Normalized power'); title('Slice selection')

%% Question 4
% What is the difference between the fourier transform in the current
% figure, and the one performed in previous section? what is different
% regarding what they represent?
%% pulse frequency: 
% We can control the position that is excited by adjusting the frequency.
pulseFreq = 50;
rfPulse(pulseStart:pulseStop) = sin(2*pi*pulseFreq*pulseT);
subplot(1,2,1), hold on, plot(t,rfPulse, 'r'); 
xlabel('Time'); ylabel('RF signal'); title('RF pulse')
subplot(1,2,2), hold on
[s,f] = powerSpecDens(rfPulse);
plot(f,s, 'r'); grid on;
xlabel('Normalized frequency'); ylabel('Normalized power'); title('Slice selection')


%% slice width : pulse shape
% A second parameter we would like to control is the slice width.   There
% are two ways we can adjust the slice width.  One way, is to change the
% gradient.  A second way, illustrated here, is to change the timing of the
% RF pulse.In this example, we create an RF pulse that is the product of
% the sinusoid and a sinc function.  

for sincFreq  = [10,20,40];      % Try 10, 20 and 40.
    for pulseFreq = [25,50,75];      % Try 25, 50 and 75.
        
        rfPulse(pulseStart:pulseStop) = sin(2*pi*pulseFreq*pulseT);
        rfPulse(pulseStart:pulseStop) = rfPulse(pulseStart:pulseStop).*sincFunction(sincFreq*pulseT);
        figure;
        
        hold off;
        subplot(1,2,1), plot(t,rfPulse,'r-');
        xlabel('Time'); ylabel('RF signal'); title(['RF pulse  sincFreq: ' num2str(sincFreq) ' pulseFreq: ' num2str(pulseFreq)])
        
        hold off;
        subplot(1,2,2), [s,f] = powerSpecDens(rfPulse); plot(f,s,'r--'); grid on;
        xlabel('Normalized frequency'); ylabel('Normalized power'); title('Slice selection')
    end
end

%% Question 5:

% Feel free to play with the frequencies of the sinc pulse functions.
% What effect does each parameter have on slice position and slice width?

%% Image Formation using frequency encoding and phase encoding together
% 
% Earlier, we reviewed how to use a gradient field to associate different
% positions along a line with different RF signal frequencies. That method
% is often called frequency encoding. In this  section, we describe how to
% measure along the second spatial dimension. This measurement is sometimes
% called the phase-encoding dimension. Taken together, the methods
% described in this section are sometimes called Fourier Transform imaging.
% 
% Consider the problem of identifying signals from 4 beakers placed at the
% corners of a square. These beakers are in the planar section and the
% spins were set in motion using the methods described in previous section.
%
% First, we set up the basic parameters for the four beakers.
clear T1; clear larmorFreq; clear ph; clear signal;
T1 = [1,2;3,4]/2; larmorFreq = [15, 50]; ph = [0, pi]; t = (0:.02:5); Mo = 1;
rate = [0,0,0,0];
spinDir = [10,0; 10,0; 10,0; 10,0];
figure(1), clf
phaseEncode(rate,spinDir,1,'Time=0');
%% x-axis gradient 
% Suppose we apply a gradient across the x-axis.  In the presence of this
% gradient, the signals from the two beakers on the left will differ from
% the RF signals emitted by the two beakers on the right. When we measure
% with only the x-gradient (Gx), we obtain the sum of the two beakers on
% the left in one frequency band and the sum of the two beakers on the
% right in a second frequency band.
%
f = [larmorFreq(1),larmorFreq(1),larmorFreq(2), larmorFreq(2)];
p = [ph(1),ph(1),ph(1),ph(1)];
figure(2), clf; 
signal = plotRF(f,p,t,T1,Mo,'Gradient-X');

% Total signal
subplot(1,2,1)
s = sum(squeeze(sum(signal,1)),1);
plot(t,s);xlabel('Time'); ylabel('RF'); title('Total RF'); grid on
set(gca,'ylim',[-3 3]);
subplot(1,2,2)
[p,f] = powerSpecDens(s); 
plot(f,p,'o-'); grid on; set(gca,'ylim',[0,10]);
xlabel('Normalized frequency'); ylabel('Normalized power'); title('Total RF Signal')

%% Question 6
% explain this figure and what it means regarding the beakers? (are they
% all the same? how do you know?)

%% y-axis gradient
% Now, suppose that we turn off the Gx gradient and introduce a gradient in
% the y-dimension (Gy).  This changes the Larmor frequency of the beakers
% at the top and bottom of the square.  Suppose the frequency for the
% bottom beakers is a little lower. Then the spins in the bottom beakers
% rotate more slowly and they end up pointing in a different direction from
% the spins at the top.  After applying Gy for a certain amount of time,
% the spins at the top and bottom will point in opposite directions.

rate = [pi/8 pi/8 pi/16 pi/16];
spinDir = [10,0; 10,0; 10,0; 10,0];
figure(1), clf
phaseEncode(rate,spinDir,15,'Gradient-Y');

%% x-axis gradient after the y-axis gradient was applied
% Next, we switch off  Gy and turn on Gx.  As before we will measure the
% combination of the spins on the left at one frequency and the combination
% of the spins at the right at a different frequency. 


f = [larmorFreq(1),larmorFreq(1),larmorFreq(2), larmorFreq(2)];
p = [ph(1),ph(2),ph(1),ph(2)];
figure(3), clf; signal = plotRF(f,p,t,T1,Mo,'Gradient-X');

%% Question 7
%  Explain the signal in terms of all the paramaters that have an effect on
%  it: the beaker T1, frequency, and phase. Describe which of these
%  parameters was determined by our manipulations: (B0 gradients,RF pulse)
%  and which is determined by the tissue characteristic . 
%% overall signal
% Because the spins of the top and bottom beaker oppose one another, however, the total RF
% signal we obtain now is the difference between the top and bottom.  
%
% Total signal
figure(2), clf; subplot(1,2,1)
s = sum(squeeze(sum(signal,1)),1);
plot(t,s); xlabel('Time'); ylabel('RF'); title('Total RF'); grid on
set(gca,'ylim',[-2 2]);
subplot(1,2,2)
[p,f] = powerSpecDens(s); 
plot(f,p,'o-'); grid on; set(gca,'ylim',[0,10]);
xlabel('Normalized frequency'); ylabel('Normalized power'); title('Total RF Signal')

% The two measurements at the main frequencies provide an estimate of the
% sum and the difference of the time constants in the upper and lower
% beakers.

%% Question 8
% Now, run kspaceDemo.m, change at least 2 parameters, more than once,
% describe and show what you did and explain the results
%% additional information:
% The Hornak MRI book, http://www.cis.rit.edu/htbooks/mri/,  has a very
% good discussion of imaging, including frequency and phase encoding.
% Read Chapters 6 and 7 for a useful discussion of the principles
% further described here.  