function espai_k_out=filtre_pas_alt(espai_k_in,AmplitutFiltrat);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODULE:     filtre_pas_alt.m
%
%   CONTENTS:   high-pass filtering of the k-space
%
%   COPYRIGHT:  David Moratal-Perez, 2003
%                Universitat Polit�cnica de Val�ncia, Valencia, Spain
%
%   INPUT PARAMETERS:
%
%   espai_k_in                    : original k-space
%   AmplitutFiltrat               : amplitude of the filtering
%
%   OUTPUT PARAMETERS:
%
%   espai_k_out                   : high-pass filtered k-space
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

[nb_rows,nb_cols]=size(espai_k_in);

% Mascara original
mascara=zeros(nb_rows,nb_cols);

half_nb_rows=round(nb_rows/2);
half_nb_cols=round(nb_cols/2);

% Mascara FPBaix
mascara_FPB=mascara;
mascara_FPB( (half_nb_rows-AmplitutFiltrat):(half_nb_rows+AmplitutFiltrat),: )=1;

% Mascara FPAlt
mascara_FPA=not(mascara_FPB);

% Filtrat pas alt (k-space (+ shift) + FPA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K_space_FPA=espai_k_in.*mascara_FPA;

espai_k_out=K_space_FPA;
