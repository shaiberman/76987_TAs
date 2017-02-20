function varargout = k_space_tutorial(varargin)
% K_SPACE_TUTORIAL Application M-file for k_space_tutorial.fig
%    FIG = K_SPACE_TUTORIAL launch k_space_tutorial GUI.
%    K_SPACE_TUTORIAL('callback_name', ...) invoke the named callback.
%
% Last Modified by GUIDE v2.0 29-Apr-2003 14:35:35
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

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end

end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.

%global imatge_original
%global espai_k

% Load a new Image Button
%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = LoadImageButton_Callback(h, eventdata, handles, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global imatge_original
%global espai_k

[filename, pathname] = uigetfile( ...
    {'*.bmp', 'Bitmap files (*.bmp)';
    '*.m;*.fig;*.mat;*.mdl', 'All MATLAB Files (*.m, *.fig, *.mat, *.mdl)';
    '*.*',  'All Files (*.*)'}, ...
    'Load a new image');

imatge_original=imread([pathname filename],'bmp');

espai_k=imatge_i_espai_k_originals(imatge_original);

ToShowImageAndKSpace(h, eventdata, handles, varargin, espai_k);


% Once I have loaded the image, I can activate all the options
set(handles.LowPassFilterCheckbox,'Enable','on');
set(handles.HighPassFilterCheckbox,'Enable','on');
set(handles.MotionArtifactsSlider,'Enable','on');
set(handles.NoiseSlider,'Enable','on');
set(handles.HalfFOV_Checkbox,'Enable','on');
set(handles.HalfFourierCheckbox,'Enable','on');
set(handles.RectangularMatrixCheckbox,'Enable','on');
set(handles.InsertSpikePushButton,'Enable','on');
set(handles.boton_2dft,'Enable','on');
set(handles.SaveButton,'Enable','on');
set(handles.MotionArtifactsText,'Enable','on');
set(handles.SNRText,'Enable','on');
set(handles.SNRValueIndicator,'Enable','on');
set(handles.MotionMin,'Enable','on');
set(handles.MotionMax,'Enable','on');
set(handles.HalfScanText,'Enable','on');
set(handles.RectangularFOVText,'Enable','on');
set(handles.HalfFOVText,'Enable','on');
set(handles.ReducedAcquisitionText,'Enable','on');
set(handles.RectangularMatrixText,'Enable','on');

% LOW & HIGH PASS FILTERS
%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function varargout = LowPassFilterCheckbox_Callback(h, eventdata, handles, varargin)

% I activate the slider if I have chosen this option
Value_LowPassFilterCheckbox=get(handles.LowPassFilterCheckbox,'Value');
Value_HighPassFilterCheckbox=get(handles.HighPassFilterCheckbox,'Value');

if Value_LowPassFilterCheckbox==1
    set(handles.LowPassFilterSlider,'Enable','on');
    set(handles.LowPassValueIndicator,'Enable','on');
    set(handles.PassFilterMin,'Enable','on');
    set(handles.PassFilterMax,'Enable','on');
    
else
    set(handles.LowPassFilterSlider,'Enable','off');
    set(handles.LowPassValueIndicator,'Enable','off');
    if Value_HighPassFilterCheckbox==0
        set(handles.PassFilterMin,'Enable','off');
        set(handles.PassFilterMax,'Enable','off');
    end
        
end

% Mutual exclusion of the other checkboxes
%off = [handles.HighPassFilterCheckbox,handles.HalfFOV_Checkbox,handles.HalfFourierCheckbox,handles.RectangularMatrixCheckbox];
%MutualExclude(off)

% --------------------------------------------------------------------
function varargout = LowPassFilterSlider_Callback(h, eventdata, handles, varargin)

% For the numerical indicator
LowPassValue=get(handles.LowPassFilterSlider,'Value');
LowPassValue=round(LowPassValue);
LowPassValue=num2str(LowPassValue);

set(handles.LowPassValueIndicator,'String',LowPassValue);

% --------------------------------------------------------------------
function varargout = HighPassFilterCheckbox_Callback(h, eventdata, handles, varargin)

% I activate the slider if I have chosen this option

Value_LowPassFilterCheckbox=get(handles.LowPassFilterCheckbox,'Value');
Value_HighPassFilterCheckbox=get(handles.HighPassFilterCheckbox,'Value');

if Value_HighPassFilterCheckbox==1
    set(handles.HighPassFilterSlider,'Enable','on');
    set(handles.HighPassValueIndicator,'Enable','on');
    set(handles.PassFilterMin,'Enable','on');
    set(handles.PassFilterMax,'Enable','on');
else
    set(handles.HighPassFilterSlider,'Enable','off');
    set(handles.HighPassValueIndicator,'Enable','off');
    if Value_LowPassFilterCheckbox==0
        set(handles.PassFilterMin,'Enable','off');
        set(handles.PassFilterMax,'Enable','off');
    end
end

% Mutual exclusion of the other checkboxes

%off = [handles.LowPassFilterCheckbox,handles.HalfFOV_Checkbox,handles.HalfFourierCheckbox,handles.RectangularMatrixCheckbox];
%MutualExclude(off)

% --------------------------------------------------------------------
function varargout = HighPassFilterSlider_Callback(h, eventdata, handles, varargin)

HighPassValue=get(handles.HighPassFilterSlider,'Value');
HighPassValue=round(HighPassValue);
HighPassValue=num2str(HighPassValue);

set(handles.HighPassValueIndicator,'String',HighPassValue);


% MOTION ARTIFACTS & NOISE
%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function varargout = MotionArtifactsSlider_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = NoiseSlider_Callback(h, eventdata, handles, varargin)

% For the numerical indicator
NoiseValue=get(handles.NoiseSlider,'Value');
%NoiseValue=round(NoiseValue);
NoiseValue=num2str(NoiseValue);

set(handles.SNRValueIndicator,'String',NoiseValue);

% Half FOV (skip even lines)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function varargout = HalfFOV_Checkbox_Callback(h, eventdata, handles, varargin)

Value_HalfFOV_Checkbox=get(handles.HalfFOV_Checkbox,'Value');

if Value_HalfFOV_Checkbox==1
    set(handles.HalfFOV_NonC_Radiobutton,'Enable','on');
    set(handles.HalfFOV_Compr_Radiobutton,'Enable','on');
else
    set(handles.HalfFOV_NonC_Radiobutton,'Enable','off');
    set(handles.HalfFOV_Compr_Radiobutton,'Enable','off');
end

%off = [handles.LowPassFilterCheckbox,handles.HighPassFilterCheckbox,handles.HalfFourierCheckbox,handles.RectangularMatrixCheckbox];
%MutualExclude(off)

% --------------------------------------------------------------------
function varargout = HalfFOV_NonC_Radiobutton_Callback(h, eventdata, handles, varargin)
off = [handles.HalfFOV_Compr_Radiobutton];
MutualExclude(off)

% --------------------------------------------------------------------
function varargout = HalfFOV_Compr_Radiobutton_Callback(h, eventdata, handles, varargin)


off = [handles.HalfFOV_NonC_Radiobutton];
MutualExclude(off)


% RECTANGULAR MATRIX IMAGING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function varargout = RectangularMatrixCheckbox_Callback(h, eventdata, handles, varargin)

Value_RectangularMatrixCheckbox=get(handles.RectangularMatrixCheckbox,'Value');

%set(handles.HighPassFilterSlider,'Enable','off');
%set(handles.HighPassValueIndicator,'Enable','off');
%set(handles.LowPassFilterSlider,'Enable','off');
%set(handles.LowPassValueIndicator,'Enable','off');

%set(handles.HalfFOV_NonC_Radiobutton,'Enable','off');
set(handles.HalfFOV_Compr_Radiobutton,'Value',0);

if Value_RectangularMatrixCheckbox==1
    set(handles.Rectangular_NonC_Radiobutton,'Enable','on');
    set(handles.Rectangular_Compr_Radiobutton,'Enable','on');
    set(handles.ScanPercentageSlider,'Enable','on');
    set(handles.ScanPercentageMin,'Enable','on');
    set(handles.ScanPercentageMax,'Enable','on');
    set(handles.ScanValueIndicator,'Enable','on');
    
else
    set(handles.Rectangular_NonC_Radiobutton,'Enable','off');
    set(handles.Rectangular_Compr_Radiobutton,'Enable','off');
    set(handles.ScanPercentageSlider,'Enable','off');
    set(handles.ScanPercentageMin,'Enable','off');
    set(handles.ScanPercentageMax,'Enable','off');
    set(handles.ScanValueIndicator,'Enable','off');
end


%off = [handles.LowPassFilterCheckbox,handles.HighPassFilterCheckbox,handles.HalfFourierCheckbox,handles.HalfFOV_Checkbox];
%MutualExclude(off)

% --------------------------------------------------------------------
function varargout = ScanPercentageSlider_Callback(h, eventdata, handles, varargin)

ScanPercentageValue=get(handles.ScanPercentageSlider,'Value');
ScanPercentageValue=round(ScanPercentageValue);
ScanPercentageValue=num2str(ScanPercentageValue);

set(handles.ScanValueIndicator,'String',ScanPercentageValue);

% --------------------------------------------------------------------
function varargout = Rectangular_NonC_Radiobutton_Callback(h, eventdata, handles, varargin)
off = [handles.Rectangular_Compr_Radiobutton];
MutualExclude(off)

% --------------------------------------------------------------------
function varargout = Rectangular_Compr_Radiobutton_Callback(h, eventdata, handles, varargin)
off = [handles.Rectangular_NonC_Radiobutton];
MutualExclude(off)

% HALF FOURIER
%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function varargout = HalfFourierCheckbox_Callback(h, eventdata, handles, varargin)

Value_HalfFourierCheckbox=get(handles.HalfFourierCheckbox,'Value');

%set(handles.HighPassFilterSlider,'Enable','off');
%set(handles.HighPassValueIndicator,'Enable','off');
%set(handles.LowPassFilterSlider,'Enable','off');
%set(handles.LowPassValueIndicator,'Enable','off');

%set(handles.HalfFOV_NonC_Radiobutton,'Enable','off');
%set(handles.HalfFOV_Compr_Radiobutton,'Enable','off');

%set(handles.Rectangular_NonC_Radiobutton,'Enable','off');
%set(handles.Rectangular_Compr_Radiobutton,'Enable','off');

if Value_HalfFourierCheckbox==1
    set(handles.HalfNEX_Radiobutton,'Enable','on');
    set(handles.MinTE_Radiobutton,'Enable','on');
    set(handles.FillingWithZerosRadiobutton,'Enable','on');
    set(handles.UsingSymmetryRadiobutton,'Enable','on');
    set(handles.NumberExtraLinesSlider,'Enable','on');
    set(handles.NumberExtraLinesText,'Enable','on');
    set(handles.ExtraLinesValueIndicator,'Enable','on');
    set(handles.ExtraLinesMin,'Enable','on');
    set(handles.ExtraLinesMax,'Enable','on');
else
    set(handles.HalfNEX_Radiobutton,'Enable','off');
    set(handles.MinTE_Radiobutton,'Enable','off');
    set(handles.FillingWithZerosRadiobutton,'Enable','off');
    set(handles.UsingSymmetryRadiobutton,'Enable','off');
    set(handles.NumberExtraLinesSlider,'Enable','off');
    set(handles.NumberExtraLinesText,'Enable','off');
    set(handles.ExtraLinesValueIndicator,'Enable','off');
    set(handles.ExtraLinesMin,'Enable','off');
    set(handles.ExtraLinesMax,'Enable','off');
end

%off = [handles.LowPassFilterCheckbox,handles.HighPassFilterCheckbox,handles.HalfFOV_Checkbox,handles.RectangularMatrixCheckbox];
%MutualExclude(off)

% --------------------------------------------------------------------
function varargout = HalfNEX_Radiobutton_Callback(h, eventdata, handles, varargin)
off = [handles.MinTE_Radiobutton];
MutualExclude(off)

% --------------------------------------------------------------------
function varargout = MinTE_Radiobutton_Callback(h, eventdata, handles, varargin)
off = [handles.HalfNEX_Radiobutton];
MutualExclude(off)


% --------------------------------------------------------------------
function varargout = FillingWithZerosRadiobutton_Callback(h, eventdata, handles, varargin)
off = [handles.UsingSymmetryRadiobutton];
MutualExclude(off)

% --------------------------------------------------------------------
function varargout = UsingSymmetryRadiobutton_Callback(h, eventdata, handles, varargin)
off = [handles.FillingWithZerosRadiobutton];
MutualExclude(off)

% --------------------------------------------------------------------
function varargout = NumberExtraLinesSlider_Callback(h, eventdata, handles, varargin)

ExtraLinesValue=get(handles.NumberExtraLinesSlider,'Value');
ExtraLinesValue=round(ExtraLinesValue);
ExtraLinesValue=num2str(ExtraLinesValue);

set(handles.ExtraLinesValueIndicator,'String',ExtraLinesValue);


% INSERT A SPIKE
%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function varargout = InsertSpikePushButton_Callback(h, eventdata, handles, varargin)

set(handles.LowPassFilterCheckbox,'Enable','off');
set(handles.HighPassFilterCheckbox,'Enable','off');
set(handles.HalfFourierCheckbox,'Enable','off');
set(handles.RectangularMatrixCheckbox,'Enable','off');
set(handles.HalfFOV_Checkbox,'Enable','off');

set(handles.LowPassFilterSlider,'Enable','off');
set(handles.LowPassValueIndicator,'Enable','off');
set(handles.HighPassFilterSlider,'Enable','off');
set(handles.HighPassValueIndicator,'Enable','off');

set(handles.HalfFOV_NonC_Radiobutton,'Enable','off');
set(handles.HalfFOV_Compr_Radiobutton,'Enable','off');

set(handles.Rectangular_NonC_Radiobutton,'Enable','off');
set(handles.Rectangular_Compr_Radiobutton,'Enable','off');

set(handles.HalfNEX_Radiobutton,'Enable','off');
set(handles.MinTE_Radiobutton,'Enable','off');
set(handles.FillingWithZerosRadiobutton,'Enable','off');
set(handles.UsingSymmetryRadiobutton,'Enable','off');
set(handles.NumberExtraLinesSlider,'Enable','off');
set(handles.NumberExtraLinesText,'Enable','off');
set(handles.ExtraLinesValueIndicator,'Enable','off');
set(handles.ExtraLinesMin,'Enable','off');
set(handles.ExtraLinesMax,'Enable','off');

set(handles.SaveButton,'Enable','off');

set(handles.MotionArtifactsText,'Enable','off');
set(handles.MotionMin,'Enable','off');
set(handles.MotionMax,'Enable','off');

set(handles.SNRText,'Enable','off');
set(handles.SNRValueIndicator,'Enable','off');

set(handles.HalfScanText,'Enable','off');
set(handles.HalfFOVText,'Enable','off');

set(handles.RectangularFOVText,'Enable','off');

set(handles.ReducedAcquisitionText,'Enable','off');
set(handles.RectangularMatrixText,'Enable','off');


set(handles.ScanPercentageSlider,'Enable','off');
set(handles.ScanPercentageMin,'Enable','off');
set(handles.ScanPercentageMax,'Enable','off');
set(handles.ScanValueIndicator,'Enable','off');

% I call the function that will put the spike into the k-space
ShowImageKSpaceAndSpike(h, eventdata, handles, varargin);

set(handles.LowPassFilterCheckbox,'Enable','on');
set(handles.HighPassFilterCheckbox,'Enable','on');
set(handles.HalfFourierCheckbox,'Enable','on');
set(handles.RectangularMatrixCheckbox,'Enable','on');
set(handles.HalfFOV_Checkbox,'Enable','on');

set(handles.SaveButton,'Enable','on');

set(handles.MotionArtifactsText,'Enable','on');
set(handles.MotionMin,'Enable','on');
set(handles.MotionMax,'Enable','on');

set(handles.SNRText,'Enable','on');
set(handles.SNRValueIndicator,'Enable','on');

set(handles.HalfScanText,'Enable','on');
set(handles.HalfFOVText,'Enable','on');

set(handles.RectangularFOVText,'Enable','on');

set(handles.ReducedAcquisitionText,'Enable','on');
set(handles.RectangularMatrixText,'Enable','on');


off = [handles.LowPassFilterCheckbox,handles.HighPassFilterCheckbox,handles.HalfFOV_Checkbox,...
        handles.RectangularMatrixCheckbox,handles.HalfFourierCheckbox];
MutualExclude(off)

% MUTUAL EXCLUSION
% ----------------
function MutualExclude(off)
set(off,'Value',0)

% --------------------------------------------------------------------------
function varargout = BotoPerTancar_Callback(h, eventdata, handles, varargin)
pos_size = get(handles.figure1,'Position');
user_response = modaldlg;
switch user_response
case {'no','cancel'}
	% take no action
case 'yes'
	% Prepare to close GUI application window
	%                  .
	%                  .
	%                  .
	delete(handles.figure1)
end


function varargout = boton_2dft_Callback(h, eventdata, handles, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global imatge_original
%global espai_k

% I take all the values that I will need later...

Value_LowPassFilterCheckbox=get(handles.LowPassFilterCheckbox,'Value');
Value_LowPassFilterSlider=get(handles.LowPassFilterSlider,'Value');
Value_HighPassFilterCheckbox=get(handles.HighPassFilterCheckbox,'Value');
Value_HighPassFilterSlider=get(handles.HighPassFilterSlider,'Value');

Value_LowPassFilterSlider=round(Value_LowPassFilterSlider);
Value_HighPassFilterSlider=round(Value_HighPassFilterSlider);

% The value of the Low Pass Filter must be greater than that of the
%  High Pass Filter (if High and Low Pass Filter are activated)
if (Value_LowPassFilterCheckbox==1 & Value_HighPassFilterCheckbox==1)
    if Value_LowPassFilterSlider<=Value_HighPassFilterSlider
        Value_LowPassFilterSlider=127;
        set(handles.LowPassFilterSlider,'Value',127);
        set(handles.LowPassValueIndicator,'String','127');
        Value_HighPassFilterSlider=1;
        set(handles.HighPassFilterSlider,'Value',1);
        set(handles.HighPassValueIndicator,'String','1');
    end
end

Value_HalfFOV_Checkbox=get(handles.HalfFOV_Checkbox,'Value');
Value_HalfFOV_NonC_Radiobutton=get(handles.HalfFOV_NonC_Radiobutton,'Value');
Value_HalfFOV_Compr_Radiobutton=get(handles.HalfFOV_Compr_Radiobutton,'Value');

% Or one or the other (avoid nothing selected)
if Value_HalfFOV_Checkbox==1
    if (Value_HalfFOV_NonC_Radiobutton==0 & Value_HalfFOV_Compr_Radiobutton==0)
        set(handles.HalfFOV_NonC_Radiobutton,'Value',1);
    end
end

Value_HalfFourierCheckbox=get(handles.HalfFourierCheckbox,'Value');
Value_HalfNEX_Radiobutton=get(handles.HalfNEX_Radiobutton,'Value');
Value_MinTE_Radiobutton=get(handles.MinTE_Radiobutton,'Value');
Value_FillingWithZerosRadiobutton=get(handles.FillingWithZerosRadiobutton,'Value');
Value_UsingSymmetryRadiobutton=get(handles.UsingSymmetryRadiobutton,'Value');
Value_NumberExtraLinesSlider=get(handles.NumberExtraLinesSlider,'Value');
Value_NumberExtraLinesSlider=round(Value_NumberExtraLinesSlider);

Value_RectangularMatrixCheckbox=get(handles.RectangularMatrixCheckbox,'Value');
Value_ScanPercentageSlider=get(handles.ScanPercentageSlider,'Value');
Value_ScanPercentageSlider=round(Value_ScanPercentageSlider);
Value_Rectangular_NonC_Radiobutton=get(handles.Rectangular_NonC_Radiobutton,'Value');
Value_Rectangular_Compr_Radiobutton=get(handles.Rectangular_Compr_Radiobutton,'Value');

% Or one or the other (avoid nothing selected)
if Value_RectangularMatrixCheckbox==1
    if (Value_Rectangular_NonC_Radiobutton==0 & Value_Rectangular_Compr_Radiobutton==0)
        set(handles.Rectangular_NonC_Radiobutton,'Value',1);
    end
end

Value_MotionArtifactsSlider=get(handles.MotionArtifactsSlider,'Value');
Value_MotionArtifactsSlider=round(Value_MotionArtifactsSlider);

Value_NoiseSlider=get(handles.NoiseSlider,'Value');
Value_NoiseSlider=round(Value_NoiseSlider);

% Now, I "create" the k-space from the image loaded previously
espai_k=imatge_i_espai_k_originals(imatge_original);

% Noise (Additive White Gaussian Noise)
if Value_NoiseSlider~=40
    [espai_k,SNR_SignalNoiseIndependent]=add_awgnoise(espai_k,Value_NoiseSlider);
    
    SNR_SignalNoiseIndependent=num2str(SNR_SignalNoiseIndependent);
    set(handles.SNRValueIndicator,'String',SNR_SignalNoiseIndependent);
    
end

% Half Fourier Imaging
if Value_HalfFourierCheckbox==1
    
    if Value_MinTE_Radiobutton==1
        if Value_UsingSymmetryRadiobutton==1
            espai_k=half_fourier_fe(espai_k,1,Value_NumberExtraLinesSlider);
        else
            espai_k=half_fourier_fe(espai_k,0,Value_NumberExtraLinesSlider);
        end
    else
        if Value_UsingSymmetryRadiobutton==1
            espai_k=half_fourier_pe(espai_k,1,Value_NumberExtraLinesSlider);
        else
            espai_k=half_fourier_pe(espai_k,0,Value_NumberExtraLinesSlider);
        end        
    end
    
end

% Rectangular Matrix Imaging
if Value_RectangularMatrixCheckbox==1
    
    if Value_Rectangular_Compr_Radiobutton==1
        espai_k=rectangular_matrix(espai_k,1,Value_ScanPercentageSlider);
    else
        espai_k=rectangular_matrix(espai_k,0,Value_ScanPercentageSlider);
    end
    
end

% Half Field-Of-View Imaging
if Value_HalfFOV_Checkbox==1
    
    if Value_HalfFOV_Compr_Radiobutton==1
        espai_k=half_fov(espai_k,1);
    else
        espai_k=half_fov(espai_k,0);
    end
    
end

% Motion Artifacts
if Value_MotionArtifactsSlider~=0
    espai_k=motion_artifacts(espai_k,Value_MotionArtifactsSlider);
end

% Low Pass Filter
if Value_LowPassFilterCheckbox==1
    
    espai_k=filtre_pas_baix(espai_k,round(Value_LowPassFilterSlider));
    
end

% High Pass Filter
if Value_HighPassFilterCheckbox==1
    
    espai_k=filtre_pas_alt(espai_k,round(Value_HighPassFilterSlider));
   
end

% Default
%%%%%%%%%
if (Value_LowPassFilterCheckbox==0 & Value_HighPassFilterCheckbox==0 & Value_HalfFOV_Checkbox==0 &...
        Value_HalfFourierCheckbox==0 & Value_RectangularMatrixCheckbox==0 & Value_MotionArtifactsSlider==0 & Value_NoiseSlider==40)
    
    espai_k=imatge_i_espai_k_originals(imatge_original);
end

ToShowImageAndKSpace(h, eventdata, handles, varargin, espai_k);

% To Display the k-space and its image
% ------------------------------------

function ToShowImageAndKSpace(h, eventdata, handles, varargin, espai_k);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Let's show the k-space

global image_to_be_saved
%global espai_k
global k_space_to_be_saved

espai_k_abs=abs(espai_k);
k_space_to_be_saved=espai_k_abs;


axes(handles.ejes_espaciok)
imshow(k_space_to_be_saved)

espai_k_ifftsh=fftshift(espai_k); %<---------------------

% I calculate the image from the k-space
imagen_espai_k=fft2(espai_k_ifftsh);

Value_HalfFOV_Checkbox=get(handles.HalfFOV_Checkbox,'Value');
Value_HalfFOV_Compr_Radiobutton=get(handles.HalfFOV_Compr_Radiobutton,'Value');


Value_RectangularMatrixCheckbox=get(handles.RectangularMatrixCheckbox,'Value');
Value_Rectangular_Compr_Radiobutton=get(handles.Rectangular_Compr_Radiobutton,'Value');
Value_ScanPercentageSlider=get(handles.ScanPercentageSlider,'Value');
Value_ScanPercentageSlider=round(Value_ScanPercentageSlider);


if (Value_HalfFOV_Checkbox==1 & Value_HalfFOV_Compr_Radiobutton==1)
    %imagen_espai_k=circshift(imagen_espai_k,-32); %<---------------------
    imagen_espai_k=imagen_espai_k; %<---------------------
else
    if (Value_RectangularMatrixCheckbox==1 & Value_Rectangular_Compr_Radiobutton==1)
        % The number of lines to shift depends on the scan percentage (50% scan percentage --> 32 lines)
        NbLinesToShift=(Value_ScanPercentageSlider/100)*64;
        NbLinesToShift=round(NbLinesToShift);
        %imagen_espai_k=circshift(imagen_espai_k,-32); %<---------------------
        imagen_espai_k=circshift(imagen_espai_k,-NbLinesToShift); %<---------------------
        %imagen_espai_k=imagen_espai_k; %<---------------------
    else
        imagen_espai_k=circshift(imagen_espai_k,-64); %<---------------------
    end
end

imagen_espai_k_abs=abs(imagen_espai_k);
imagen_espai_k_abs_norm=imagen_espai_k_abs/(max(max(imagen_espai_k_abs)))*255;

image_to_be_saved=uint8(imagen_espai_k_abs_norm);

% Let's show the image
axes(handles.ejes_imagen)
imshow(image_to_be_saved)

% To put an spike into the k-space...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ShowImageKSpaceAndSpike(h, eventdata, handles, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
global image_to_be_saved
global imatge_original
global k_space_to_be_saved

espai_k=imatge_i_espai_k_originals(imatge_original);

espai_k_abs=abs(espai_k);
k_space_to_be_saved=espai_k_abs;

% Let's show the k-space
axes(handles.ejes_espaciok)
imshow(k_space_to_be_saved);

espai_k_ifftsh=fftshift(espai_k); %<---------------------

% I calculate the image from the k-space
imagen_espai_k=fft2(espai_k_ifftsh);
imagen_espai_k=circshift(imagen_espai_k,-64); %<---------------------
imagen_espai_k_abs=abs(imagen_espai_k);
imagen_espai_k_abs=uint8(imagen_espai_k_abs);

% Let's show the image
axes(handles.ejes_imagen)
imshow(imagen_espai_k_abs)

[x,y]=ginput(1);
x=round(x);
y=round(y);

espai_k(y,x)=255;
espai_k_abs=abs(espai_k);
k_space_to_be_saved=espai_k_abs;
%image_ifft2_ifftsh_abs = imadjust(image_ifft2_ifftsh_abs,[0 0.6],[]);

% Let's show the k-space with the spike
axes(handles.ejes_espaciok)
imshow(k_space_to_be_saved);

espai_k_fft2=fft2(espai_k);
espai_k_fft2_abs=abs(espai_k_fft2);

max_espai_k_fft2_abs=max(max(espai_k_fft2_abs));
espai_k_fft2_abs=espai_k_fft2_abs/max_espai_k_fft2_abs*255;
espai_k_fft2_abs=circshift(espai_k_fft2_abs,-64); %<---------------------

image_to_be_saved=uint8(espai_k_fft2_abs);

% Let's show the image
axes(handles.ejes_imagen)
imshow(image_to_be_saved)


% --------------------------------------------------------------------
function varargout = SaveButton_Callback(h, eventdata, handles, varargin)

global image_to_be_saved
global k_space_to_be_saved

[filename, pathname] = uiputfile( ...
    {'*.bmp', 'Bitmap files (*.bmp)';
    '*.m;*.fig;*.mat;*.mdl', 'All MATLAB Files (*.m, *.fig, *.mat, *.mdl)';
    '*.*',  'All Files (*.*)'}, ...
    'Save as');

ImageName=[filename '_imagedomain.bmp'];
ImageChaineName=[pathname ImageName];
imwrite(image_to_be_saved,ImageChaineName,'bmp');

kSpaceName=[filename '_k_spacedomain.bmp'];
kSpaceChaineName=[pathname kSpaceName];
k_space_to_be_saved = imadjust(k_space_to_be_saved,[0 0.6],[]);
imwrite(k_space_to_be_saved,kSpaceChaineName,'bmp');





