function espai_k_out=rectangular_matrix(espai_k_in,RectangularMatrix_compressed,Value_ScanPercentageSlider);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODULE:     rectangular_matrix.m
%
%   CONTENTS:   Simulates a motion artifact
%
%   COPYRIGHT:  David Moratal-Perez, 2003
%                Universitat Politècnica de València, Valencia, Spain
%
%   INPUT PARAMETERS:
%
%   espai_k_in                    : original k-space
%   RectangularMatrix_compressed  : =0, the matrix will not be compressed
%                                 : =1, the matrix will be compressed
%   Value_ScanPercentageSlider    : value for the scan percentage
%                                   (selected with the slider)
%
%   OUTPUT PARAMETERS:
%
%   espai_k_out                   : k-space that will provide a RFOV
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

% Rectangular Matrix Imaging

Value_ScanPercentageSlider=1-Value_ScanPercentageSlider/100;

% The lines (half of them at the top and the other half at the bottom of the k-space)
% that I will skip (ignore)
NbLinesTop_and_Bottom=round(Value_ScanPercentageSlider*256/2);

% Rectangular Matrix Imaging (k-space)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if RectangularMatrix_compressed==0
    
    k_space_Rectangular=zeros(256,256);
    k_space_Rectangular( (NbLinesTop_and_Bottom+1):(256-NbLinesTop_and_Bottom),: )=...
        espai_k_in( (NbLinesTop_and_Bottom+1):(256-NbLinesTop_and_Bottom),:);
    
    espai_k_out=k_space_Rectangular;
    
else
    
    % Rectangular Matrix Imaging (k-space) [ONLY NON ZEROS]
    k_space_Rectangular=espai_k_in( (NbLinesTop_and_Bottom+1):(256-NbLinesTop_and_Bottom),: );
    
    espai_k_out=k_space_Rectangular;
    
end
