function espai_k_out=motion_artifacts(espai_k_in,Value_MotionArtifactsSlider);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODULE:     motion_artifacts.m
%
%   CONTENTS:   Simulates a motion artifact
%
%   COPYRIGHT:  David Moratal-Perez, 2003
%                Universitat Politècnica de València, Valencia, Spain
%
%   INPUT PARAMETERS:
%
%   espai_k_in                    : original k-space
%   Value_MotionArtifactsSlider   : magnitude of the motion artifact
%                                   (selected with the slider)
%
%   OUTPUT PARAMETERS:
%
%   espai_k_out                   : k-space with the simulated motion
%                                    artifact
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

[nb_rows,nb_cols]=size(espai_k_in);

% I create the vector with the random lines that will be zeros
RandomVector=rand(1,Value_MotionArtifactsSlider);

RandomVector=ceil(abs(RandomVector*nb_rows))';

espai_k_in(RandomVector,:)=0;

espai_k_out=espai_k_in;
