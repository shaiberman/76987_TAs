function [espai_k_out,SNR_SignalNoiseIndependent]=add_awgnoise(espai_k_in,Value_NoiseSlider);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODULE:     add_awgnoise.m
%
%   CONTENTS:   add an additive white gaussian noise to the complex data
%
%   COPYRIGHT:  David Moratal-Perez, 2004
%                Universitat Politècnica de València, Valencia, Spain
%
%   INPUT PARAMETERS:
%
%   espai_k_in                    : original k-space
%   Value_NoiseSlider             : value of the noise (in dB) to add
%
%   OUTPUT PARAMETERS:
%
%   espai_k_out                   : k-space with the added noise
%   SNR_SignalNoiseIndependent    : resulting signal-to-noise ratio
%
%-------------------------------------------------
% David Moratal, Ph.D.
% Center for Biomaterials and Tissue Engineering
% Universitat Politècnica de València
% Valencia, Spain
%
% web page:   http://dmoratal.webs.upv.es
% e-mail:     dmoratal@eln.upv.es
%-------------------------------------------------
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% From 0..40 dB (the range value of Value_NoiseSlider)
SignalToNoiseRatio=Value_NoiseSlider;

% Signal
NumberComponents=prod(size(espai_k_in));
AverageSignal=(1/NumberComponents)*sum(sum((abs(espai_k_in))));

% Unbiased estimate of the Standard Deviation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%              /-----------------------------------------------\
%             /                      /----|
%            /        1              \                      2
%   s  = -  /  --------------------  /       ( a(m,n) - m  )
%    a    \/    NumberComponents-1   \----|              a
%                                      m,n
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

UnbiasedEstStDeviationSignal=sqrt( (1/(NumberComponents-1)) * sum(sum( abs(espai_k_in-AverageSignal).^2 ))  );

% Using the SNR given by the user, we build the standard deviation of the noise
StdDeviationNoise=UnbiasedEstStDeviationSignal/(10^(SignalToNoiseRatio/20));

% Additive White Gaussian Noise
%
Noise=StdDeviationNoise*randn(size(espai_k_in(:,:)));
%
AverageNoise=(1/NumberComponents)*sum(sum((Noise)));
UnbiasedEstStDeviationNoise=sqrt( (1/(NumberComponents-1)) * sum(sum( abs(Noise-AverageNoise).^2 ))  );

% I add the noise to the frame (in k-space domain)
espai_k_out(:,:)=espai_k_in(:,:)+Noise;

SNR_SignalNoiseIndependent=20*log10( UnbiasedEstStDeviationSignal/UnbiasedEstStDeviationNoise );


