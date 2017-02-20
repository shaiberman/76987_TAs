function espai_k_out=half_fourier_fe(espai_k_in,HalfFourierHow,LiniesExtraHalfFourier);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODULE:     half_fourier_fe.m
%
%   CONTENTS:   Half Fourier in the frequency-encoding (horizontal) direction
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
%                                     frequency encoding direction
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
    k_space_HalfFourier(:,(129-LiniesExtraHalfFourier):256)=espai_k_in(:,(129-LiniesExtraHalfFourier):256);
    
    espai_k_out=k_space_HalfFourier;
    
else
    
    % Rellenando las zonas a cero utilizando la simetria del espacio-k
    k_space_HalfFourier=zeros(256,256);
    k_space_HalfFourier(:,(129-LiniesExtraHalfFourier):256)=espai_k_in(:,(129-LiniesExtraHalfFourier):256);
    
    % Aprovechando la simetria del espacio-k ...
    k_space_HalfFourier_2on_cuad=k_space_HalfFourier(2:128,(130+LiniesExtraHalfFourier):256);
    k_space_HalfFourier_4rt_cuad=k_space_HalfFourier(130:256,(130+LiniesExtraHalfFourier):256);
    
    row_1=espai_k_in(1,(130+LiniesExtraHalfFourier):256);
    row_129=espai_k_in(129,(130+LiniesExtraHalfFourier):256);
    
    k_space_HalfFourier_2on_cuad=flipud(fliplr(k_space_HalfFourier_2on_cuad));
    k_space_HalfFourier_2on_cuad=conj(k_space_HalfFourier_2on_cuad);
    
    k_space_HalfFourier_4rt_cuad=flipud(fliplr(k_space_HalfFourier_4rt_cuad));
    k_space_HalfFourier_4rt_cuad=conj(k_space_HalfFourier_4rt_cuad);
    
    row_1=fliplr(row_1);
    row_1=conj(row_1);
    
    row_129=fliplr(row_129);
    row_129=conj(row_129);
       
    k_space_HalfF_2on_i_4rt_cuad=cat(1,row_1,k_space_HalfFourier_4rt_cuad,row_129,k_space_HalfFourier_2on_cuad);
       
    k_space_HalfFourier=cat(2,k_space_HalfF_2on_i_4rt_cuad,k_space_HalfFourier(:,(129-LiniesExtraHalfFourier):256,:));
        
    espai_k_out=k_space_HalfFourier;
    
end
