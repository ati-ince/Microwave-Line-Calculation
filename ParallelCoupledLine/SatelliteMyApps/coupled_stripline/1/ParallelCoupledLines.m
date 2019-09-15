function varargout = ParallelCoupledLines(varargin)
% PARALLELCOUPLEDLINES MATLAB code for ParallelCoupledLines.fig
%      PARALLELCOUPLEDLINES, by itself, creates a new PARALLELCOUPLEDLINES or raises the existing
%      singleton*.
%
%      H = PARALLELCOUPLEDLINES returns the handle to a new PARALLELCOUPLEDLINES or the handle to
%      the existing singleton*.
%
%      PARALLELCOUPLEDLINES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARALLELCOUPLEDLINES.M with the given input arguments.
%
%      PARALLELCOUPLEDLINES('Property','Value',...) creates a new PARALLELCOUPLEDLINES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ParallelCoupledLines_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ParallelCoupledLines_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ParallelCoupledLines

% Last Modified by GUIDE v2.5 29-Jan-2013 14:14:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ParallelCoupledLines_OpeningFcn, ...
                   'gui_OutputFcn',  @ParallelCoupledLines_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ParallelCoupledLines is made visible.
function ParallelCoupledLines_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ParallelCoupledLines (see VARARGIN)



axes(handles.axes1);
I = imread('coupled_microstrip3.bmp');
imagesc(I);
set(handles.axes1,'visible','off');

% Choose default command line output for ParallelCoupledLines
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ParallelCoupledLines wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ParallelCoupledLines_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;







% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
% --- Executes during object creation, after setting all properties.

function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Sabitler
pi=3.14159265359;
eps_0 = 8.854187817620e-12;
mu_0  = 4*pi*1.0e-7; 
c0 = 1/sqrt(eps_0*mu_0); % ýsýk hýzý
eta_0 = sqrt(mu_0/eps_0);% hava rad direnci

%% Dýþarýdan girilen veriler
L= (10^-3)*str2double (get(handles.edit0,'String')); % L_0
W_0 = (10^-3)*str2double (get(handles.edit1,'String')); % W_0
S = (10^-3)*str2double (get(handles.edit2,'String')); % 
h = (10^-3)*str2double (get(handles.edit3,'String')); % 
t = (10^-6)*str2double (get(handles.edit4,'String')); % 
R = (10^-8)*str2double (get(handles.edit5,'String')); % 
Er_0 = str2double (get(handles.edit6,'String')); % 
f= (10^9)*str2double (get(handles.edit7,'String')); % 
B= (10^9)*str2double (get(handles.edit15,'String')); % bant geniþliði
N= str2double (get(handles.edit16,'String')); % aralýktaki sample
%%
%Tanýmlar
fn=f*h*(10^-6);
u=W_0/h;
g=S/h;
[Z0_0,Z01_0]=quasi_stat_car_imp(pi,Er_0,u,eta_0);
[Eref_0] = quasi_stat_dielec_cons(Er_0,u);
[delta_W1,delta_Wr] = quasi_strip_thick_correct(W_0,t,h,pi,Er_0);



%% Yeni deðerlendirme ve düzeltmeler
W1=W_0+delta_W1;
Wr= W_0+delta_Wr;
%thickness etkisi ile fonksiyonu yeniden çaðýralým
[Z0tWr_0,Z01tWr_0]=quasi_stat_car_imp(pi,Er_0,(Wr/h),eta_0);
[Z0tW1_0,Z01tW1_0]=quasi_stat_car_imp(pi,Er_0,(W1/h),eta_0);
[Eref_0t_Wr] = quasi_stat_dielec_cons(Er_0,(Wr/h));
[Eref_0t_W1] = quasi_stat_dielec_cons(Er_0,(W1/h));

% Yeni deðerler (single strip tihickness) ile düzenleniyor.
Z0_0tt=Z01tWr_0/sqrt(Eref_0t_Wr);  %thickness e baðlý dc hat empedansý sngle microstrip
Eref_0tt = Eref_0t_Wr * ((Z01tW1_0/Z01tWr_0)^2);
%
% Frekansla deðiþimi ise
P1 = 0.27488 + (0.6315 + 0.525 ./ (1.0 + 0.157*fn).^20.0 )*u - 0.065683*exp(-8.7513*u);
P2 = 0.33622*(1.0 - exp(-0.03442*Er_0));
P3 = 0.0363*exp(-4.6*u)*(1.0 - exp(-(fn/3.87).^4.97));
P4 = 1.0 + 2.751*( 1.0 -  exp(-(Er_0/15.916)^8.0));
P_f = P1*P2.*((0.1844 + P3*P4)*10.0.*fn).^1.5763;
%% Eref_f ve Z0_f  single microstrip için frekans baðýmlý deðerler.
Eref_f=Er_0-((Er_0-Eref_0)/(1+P_f));
[R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,R13,R14,R15,R16,R17] = RR(Er_0,Eref_0,Eref_f,u,fn);
[P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15] = PP(Er_0,Eref_0,Eref_f,u,g,fn);
Z0_f = Z0_0*(R13/R14)^R17;
%
[Eref_e_0,Eref_o_0] = quasi_stat__evenodd_dielec_cons(Er_0,Eref_0,u,g);%frekans baðýmsýz
%Frekans baðýmlý önce katsayýlar
Fe_fn=P1*P2*(((P3*P4+.1844*P7)*fn)^1.5763);
Fo_fn=P1*P2*(((P3*P4+.1844)*fn*P15)^1.5763);
%% Even odd paralel coupled  microstrip frekans baðýmlý  Baðýl dielektrik sabitler
%Frekans baðýmlý sonuclar (even , odd )
Eref_e_f=Er_0-((Er_0-Eref_e_0)/(1+Fe_fn));
Eref_o_f=Er_0-((Er_0-Eref_o_0)/(1+Fo_fn));
%
[Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15,Q16,Q17,Q18,Q19,Q20,Q21,Q22,Q23,Q24,Q25,Q26,Q27,Q28,Q29] = QQ(Er_0,Eref_0,Eref_f,u,g,fn);
Q0=R17; % Kaynaklarda dedikleri kadarý ile boyle.
%
%% Even odd Karakteristik empedanslar 
%sabitleri
r_e= (fn/28.843)/12;
q_e= .016+ ((.0514*Er_0*Q21)^4.524);
p_e= 4.766*exp(-3.228*(u^.641));
d_e= 5.086*q_e*(r_e/(.3838+.386*q_e))*(exp(-22.2*(u^1.92))/(1+1.2992*r_e))*(((Er_0-1)^6)/(1+10*((Er_0-1)^6)));
c_e= 1+1.275*(1-exp(-.004625*p_e*(Er_0^1.674)*((fn/18.365)^2.745)))-Q12+Q16-Q17+Q18+Q20;

% Frekans Baðýmsýz
Z0_e_0=Z0_0* (sqrt(Eref_0/Eref_e_0)/(1-(Z0_0/eta_0)*sqrt(Eref_0)*Q4));
Z0_o_0=Z0_0* (sqrt(Eref_0/Eref_o_0)/(1-(Z0_0/eta_0)*sqrt(Eref_0)*Q10));
Z0_o_0=(Z0_0^2)/Z0_e_0; % Burasý sapýttýðý için bunu uyguluyorum, þimdilik....
%Frekans Baðýmlý
   Z0_e_f=Z0_e_0*((.9408*((Eref_e_f)^c_e))^Q0)- (((.9408-d_e)*((Eref_e_f)^c_e)-.9603)^Q0);
   Z0_o_f=Z0_f+    (  ((Eref_o_f)/(Eref_o_0))^Q22 -Z0_f*Q23  ) * ((1+Q24+((.46*g)^2.2)*Q25)^(-1));
   Z0_o_f=(Z0_f^2)/Z0_e_f; % gene düzeltmek zorunda kaldýk þu epsilonun odd modu formulunde sorun var.. Halledilmeli
   %% Even odd için coupling deðerleri
C_0 = -10*log10((Z0_e_0-Z0_o_0)/(Z0_e_0+Z0_o_0));
C_f = -10*log10((Z0_e_f-Z0_o_f)/(Z0_e_f+Z0_o_f));

Insert_0 = -10*log10(1-(Z0_e_0-Z0_o_0)/(Z0_e_0+Z0_o_0));
Insert_f = -10*log10(1-(Z0_e_f-Z0_o_f)/(Z0_e_f+Z0_o_f));
% Belki daha eli yüzü düzgün formul  bulunur... inserting için
%% Þimdi belli aralýkta çizdir  insert ve couplingi
 c_0=log10(10^(C_0/(-3)));
 c_f=log10(10^(C_f /(-3)));
%% Bazý hesaplar
Teta =  mod((360*(L/(c0/f))),360); % açýya dönüþtürdük
%% ÇIKIÞLAR
set(handles.edit8,'String',Z0_f); % Zo_f
set(handles.edit9,'String',Eref_f); % Eeff_f

set(handles.edit10,'String',Z0_e_f); % Z0_even
set(handles.edit11,'String',Z0_o_f); %  Z0_odd

set(handles.edit12,'String',C_f); % Coupling
set(handles.edit13,'String',Insert_f); % Ýnserting

set(handles.edit14,'String', Teta); % Teta
%% coupling ve inserting için grafik ve döngümüz

% B bant geniþliðinde N sample için

%C_f = -10*log10((Z0_e_f-Z0_o_f)/(Z0_e_f+Z0_o_f));
%Insert_f = -10*log10(1-(Z0_e_f-Z0_o_f)/(Z0_e_f+Z0_o_f));

%for i= (f - B/2):(B/N):(f + B/2 - B/N)

   %Coupl_loop(i)=
  % Insert_loop(i)=

%end


%%
% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called






function edit0_Callback(hObject, eventdata, handles)
% hObject    handle to edit0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit0 as text
%        str2double(get(hObject,'String')) returns contents of edit0 as a double


% --- Executes during object creation, after setting all properties.
function edit0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit1_Callback(hObject, eventdata, handles) % W (mm)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles) %S(mm)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles) %L(mm)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)%t(um)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)%R(ohm)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)%Er(epsilon)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)%Frekans(GHz)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
