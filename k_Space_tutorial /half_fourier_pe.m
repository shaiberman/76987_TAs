function espai_k_out=half_fourier_pe(espai_k_in,HalfFourierHow,LiniesExtraHalfFourier);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODULE:     half_fourier_pe.m
%
%   CONTENTS:   Half Fourier in the phase-encoding (vertical) direction
%
%   COPYRIGHT:  David Moratal-Perez, 2003
%                Universitat Politècnica de València, Valencia, Spain
%
%   INPUT PARAMETERS:
%
%   espai_k_in                    : original k-space
%   HalfFourierHow                : =0 --> filling with zeros
%                                 : any other value --> using k-space
%                                    symmetry
%   LiniesExtraHalfFourier        : number of extra lines for the Half
%                                    Fourier technique
%
%   OUTPUT PARAMETERS:
%
%   espai_k_out                   : "Half-Fouriered" k-space in the
%                                     phase-encoding direction
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

if HalfFourierHow==0
    
    k_space_HalfFourier=zeros(256,256);
    k_space_HalfFourier(1:(129+LiniesExtraHalfFourier),:)=espai_k_in(1:(129+LiniesExtraHalfFourier),:);
    
    espai_k_out=k_space_HalfFourier;
    
else
    
    % Rellenando las zonas a cero utilizando la simetria del espacio-k
    k_space_HalfFourier=zeros(256,256);
    k_space_HalfFourier(1:(129+LiniesExtraHalfFourier),:)=espai_k_in(1:(129+LiniesExtraHalfFourier),:);
    
    % Aprovechando la simetria del espacio-k ...
    k_space_HalfFourier_1er_cuad=k_space_HalfFourier(2:(128-LiniesExtraHalfFourier),2:128);
    k_space_HalfFourier_2on_cuad=k_space_HalfFourier(2:(128-LiniesExtraHalfFourier),130:256);
    
    column_1=espai_k_in(2:(128-LiniesExtraHalfFourier),1);
    column_129=espai_k_in(2:(128-LiniesExtraHalfFourier),129);
    
    k_space_HalfFourier_1er_cuad=flipud(fliplr(k_space_HalfFourier_1er_cuad));
    k_space_HalfFourier_1er_cuad=conj(k_space_HalfFourier_1er_cuad);
    
    column_1=flipud(column_1);
    column_1=conj(column_1);
    
    column_129=flipud(column_129);
    column_129=conj(column_129);
    
    k_space_HalfFourier_2on_cuad=flipud(fliplr(k_space_HalfFourier_2on_cuad));
    k_space_HalfFourier_2on_cuad=conj(k_space_HalfFourier_2on_cuad);
        
    k_space_HalfF_1er_i_2on_cuad=cat(2,column_1,k_space_HalfFourier_2on_cuad,column_129,k_space_HalfFourier_1er_cuad);
    
    k_space_HalfFourier=[ k_space_HalfFourier(1:(129+LiniesExtraHalfFourier),:); k_space_HalfF_1er_i_2on_cuad ];
     
    espai_k_out=k_space_HalfFourier;
    
end
