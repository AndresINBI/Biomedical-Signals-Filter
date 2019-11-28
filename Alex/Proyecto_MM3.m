function Proyecto_MM3

clc;
closeall;
clearall;

%Operador de Selección
OpS = 0;

fprintf('Programa Diseñado Para la interpretacion de Señales Fisiologicas\n');
fprintf('Seleccione la señal que desea analizar:\n');
fprintf('\t1) Electrocardiograma (ECG)\t\n1) Electromiograma (EMG)\t\n1) Electroencefalograma (EEG)\n');
OpS=input('Opcion:');
S=3;

switch Ops
	case 1
		clc;
		disp('Bienvenido al Interpretador de Electrocardiograma');
		fprintf('Leyendo Electrocardiograma y Aplicando Filtros');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.\n');
		Electrocardiograma();
		disp('Presiona cualquier tecla para salir');
		c=input('');
		closeall;
		clc;
		fprintf('Reiniciando programa');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.\n');
		Proyecto_MM3;


	case 2
		clc;
		disp('Bienvenido al Interpretador de Electromiograma');
		fprintf('Leyendo Electromiograma y Aplicando Filtros');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.\n');
		Electromiograma();
		disp('Presiona cualquier tecla para salir');
		c=input('');
		closeall;
		clc;
		fprintf('Reiniciando programa');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.\n');
		Proyecto_MM3;

	case 3
		clc;
		disp('Bienvenido al Interpretador de Electroencefalograma');
		fprintf('Leyendo Electroencefalograma y Aplicando Filtros');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.\n');
		Electroencefalograma();
		disp('Presiona cualquier tecla para salir');
		c=input('');
		closeall;
		clc;
		fprintf('Reiniciando programa');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.\n');
		Proyecto_MM3;

	otherwise
		warning('Problem with Operador de Seleccion, please check it.')
		disp('Introduciste otro número o un caracter');
		pause (s);
		fprintf('Reiniciando programa');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.\n');
		Proyecto_MM3;
		return;
end


end

function Electrocardiograma
	%Lee los datos del Electrocardiograma en archivo .cvs
	ECG=csvread('ECG.csv',0,1);
	% Frecuencia de Sampleo
		fs = 500;
	% Numero de datos a Evaluar  
		ND=length(ECG);
	%Acomodando los datos en el vector para el plot
		T=1/fs : 1/fs : ND/fs;
	%Normalizando los valores para -1 & 1
		ECG = ECG/max(abs(ECG));
	%Aplicando la transormada rápida de Fourier
		TFourier=abs(fftshift(fft(ECG)));
	%Vector que acomoda la TFourier
		F=-fs/2 : fs/(ND-1) : fs/2;

	%Filtro para el Electrocrdiograma, Filtro RechazaBanda
		%h = fdesign.bandstop();
		Hd = design(h, 'butter');
	%Filtrado
		FilECG =  filter(Hd,ECG);
	%Filtro rechazaBanda
		%h = fdesign.bandstop();
		Hd = design(h, 'butter');
	%Filtrado
		FilECG =  filter(Hd,FilECG);
	%Filtro paso bajo
		%h = fdesign.lowpass();
		Hd = design(h, FilECG);
	%Filtrado
		FilECG =  filter(Hd,FilECG);

	TRF=abs(fftshift(fft(FilECG)));

	graphic(T,F,ECG,FilECG,TFourier,TRF,'ElectroCardiograma');


end


function Electromiograma
	EMG=csvread('ECG.csv',0,1);



end


function Electroencefalograma
	EEG=csvread('ECG.csv',0,1);



end

function graphic(x1,x2,y1,y2,y3,y4,titulo)

	%Gráfica de la señal sin filtrar
		G1 = figure(1)
		G1.Name = titulo;
		G1.NumberTitle = 'off';
		subplot(2,1,1);
			title('Señal');
			hold('on');
			grid('on');
			axis('tight');
			xlabel('Segundos');
			ylabel('Amplitud');
		plot(x1,y1,'Linewidth',1.5);

		ylim([-1 2]);

		subplot(2,1,2);
			title('Transformada de Fourier');
			hold('on');
			grid('on');
			axis('tight');
			xlabel('Segundos');
			ylabel('Amplitud');
		plot(x2,y3,'Linewidth',1.5);


	%Gráfica de la señal Filtrada
		G2 = figure(1)
		G2.Name = titulo;
		G2.NumberTitle = 'off';
		subplot(2,1,1);
			title('Señal');
			hold('on');
			grid('on');
			axis('tight');
			xlabel('Segundos');
			ylabel('Amplitud');
		plot(x1,y2,'Linewidth',1.5);

		ylim([-1 2]);

		subplot(2,1,2);
			title('Transformada de Fourier');
			hold('on');
			grid('on');
			axis('tight');
			xlabel('Segundos');
			ylabel('Amplitud');
		plot(x2,y4,'Linewidth',1.5);	

end