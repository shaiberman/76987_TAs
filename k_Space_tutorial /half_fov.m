function espai_k_out=half_fov(espai_k_in,HalfFOV_compressed);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODULE:     half_fov.m
%
%   CONTENTS:   50% rectangular field-of-view technique (skip even lines)
%
%   COPYRIGHT:  David Moratal-Perez, 2004
%                Universitat Politècnica de València, Valencia, Spain
%
%   INPUT PARAMETERS:
%
%   espai_k_in                    : original k-space
%   HalfFOV_compressed            : =0 --> considers the non-zero lines of k-space,
%                                    so its size is 256x256 (also in the image domain)
%                                 : any other value --> does not consider the non-zero
%                                    lines of k-space, so its size is 128x256 (also in
%                                    the image domain)
%
%   OUTPUT PARAMETERS:
%
%   espai_k_out                   : k-space with the 50% rectangular FOV
%                                    technique
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

% Half FOV Imaging (k-space)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if HalfFOV_compressed==0
    
    [nb_rows,nb_cols]=size(espai_k_in);
    k_space_Half_FOV=zeros(nb_rows,nb_cols);
    k_space_Half_FOV(1:2:nb_rows,:)=espai_k_in(1:2:nb_rows,:);
    
    espai_k_out=k_space_Half_FOV;

else
    
    % Half FOV Imaging (k-space) [ONLY NON ZEROS]
    %Aci utilitzem la IFFT de la versio desplaçada de la imatge original
    [nb_rows,nb_cols]=size(espai_k_in);
    k_space_Half_FOV=espai_k_in(1:2:nb_rows,:);
    
    espai_k_out=k_space_Half_FOV;
    
end

