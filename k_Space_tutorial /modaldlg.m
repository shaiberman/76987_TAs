function answer = modaldlg(varargin)
% modaldlg Application M-file for modaldlg.fig
%    answer = modaldlg return the answer.
%    modaldlg('callback_name') invoke the named callback.
%    modaldlg([left bottom]) locates the dialog.
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
% Last Modified by GUIDE v2.0 20-Jul-2000 13:59:31

error(nargchk(0,4,nargin)) % function takes only 0 or 4 argument
if nargin == 0 | isnumeric(varargin{1}) % LAUNCH GUI

  fig = openfig(mfilename,'reuse');

  % Use system color scheme for figure:
  set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

  % Generate a structure of handles to pass to callbacks, and store it. 
  handles = guihandles(fig);
  guidata(fig, handles);
  
  % Position figure
    if nargin == 1
	   pos_size = get(fig,'Position');
	   pos = varargin{1};
	   if length(pos) ~= 2
		   error('Input argument must be a 2-element vector')
	   end
	   new_pos = [pos(1) pos(2) pos_size(3) pos_size(4)];
	   set(fig,'Position',new_pos,'Visible','on')
	   figure(fig)
    end

  % Wait for callbacks to run and window to be dismissed:
  uiwait(fig);

  % UIWAIT might have returned because the window was deleted using
  % the close box - in that case, return 'cancel' as the answer, and
  % don't bother deleting the window!
  if ~ishandle(fig)
	  answer = 'cancel';
  else
  	  % otherwise, we got here because the user pushed one of the two buttons.
	  % retrieve the latest copy of the 'handles' struct, and return the answer.
	  % Also, we need to delete the window.
	  handles = guidata(fig);
      answer = handles.answer;
	  delete(fig);
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

% ------------------------------------------------------------
% No button callback stores 'no' in the handles struct, and 
% stores the modified handles struct
% (so the main function can see the change).  
% ------------------------------------------------------------
function varargout = noButton_Callback(h, eventdata, handles, varargin)
handles.answer = 'no';
guidata(h, handles);
uiresume(handles.figure1);

% ------------------------------------------------------------
% Yes button callback uses uiresume to 
% continue the blocked code in the main function.
% ------------------------------------------------------------
function varargout = yesButton_Callback(h, eventdata, handles, varargin)
handles.answer = 'yes';
guidata(h,handles);
uiresume(handles.figure1);
