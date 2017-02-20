function espai_k=imatge_i_espai_k_originals(imatge_original);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODULE:     imatge_i_espai_k_originals.m
%
%   CONTENTS:   it computes the k-space of the original (loaded) image
%
%   COPYRIGHT:  David Moratal-Perez, 2003
%                Universitat Polit�cnica de Val�ncia, Valencia, Spain
%
%   INPUT PARAMETERS:
%
%   imatge_original               : original image
%
%   OUTPUT PARAMETERS:
%
%   espai_k                       : its k-space
%
%-------------------------------------------------
% David Moratal, Ph.D.
% Center for Biomaterials and Tissue Engineering
% Universitat Polit�cnica de Val�ncia
% Valencia, Spain
%
% web page:   http://dmoratal.webs.upv.es
% e-mail:     dmoratal@eln.upv.es
%-------------------------------------------------
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% IFFT2 de la imatge (k-space (+ shift))
image_ifft2=ifft2(imatge_original);
image_ifft2_ifftsh=fftshift(image_ifft2);

% Versio despla�ada de la imatge original
image_ifft2_2=ifft2(circshift(imatge_original,64));
image_ifft2_ifftsh_2=fftshift(image_ifft2_2);

espai_k=image_ifft2_ifftsh_2;
