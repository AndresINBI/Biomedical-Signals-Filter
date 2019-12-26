function Proyecto_SeguraMartinezAlejandro

%Limpia la pantalla.
clc;
%Cierra todas las graficas y figuras.
close all
%Limpia todas las variables.
clear all
%Operador de Selección.
OpS = 0;
%La presentación del programa.
fprintf('Programa Diseñado Para la interpretacion de Señales Fisiologicas\n');
%Inicia el interfaz de selección de la señal a interpretar.
fprintf('Seleccione la señal que desea analizar:\n');
%Muestra las opciones de las señales a interpretar
fprintf('\t1) Electrocardiograma (ECG)\t\n\t2) Electromiograma (EMG)\n\t3) Salir\n');
%Lee la variable OpS = Operador de Selección el que permite selecionar señal a interpretar
OpS=input('Opcion:');
%La variable S = Segundos, 3 segundos.
S=3;

%Switch del Operador de Selección, depende cual sea sera el caso a utilizar
switch OpS
	%Caso 1 es el caso del Electrocardiograma
	case 1
		%Limpia la pantalla de Matlab
		clc;
		%Muestra el mensaje para comenzar el proceso.
		disp('Bienvenido al Interpretador de Electrocardiograma');
		%Muestra el mensaje y simula una lectura
		fprintf('Leyendo Electrocardiograma y Aplicando Filtros');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.\n');
		%Llama a la función Electrocardiograma
		Electrocardiograma();
		%Muestra el mensaje para salir del proceso
		disp('Presiona cualquier enter para salir');
		%Esta a la espera de enter para cerrar todo.
		c=input('');
		%Cierra todas las graficas y figuras.
		close all;
		%Limpia la pantalla
		clc;
		%Comienza con el proceso simulado de reinicio del sistema
		fprintf('Reiniciando programa');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.\n');
		%Llama a la función principal, reiniciando el programa
		Proyecto_SeguraMartinezAlejandro;


	case 2
		%Limpia la pantalla de Matlab
		clc;
		%Muestra el mensaje para comenzar el proceso.
		disp('Bienvenido al Interpretador de Electromiograma');
		%Muestra el mensaje y simula una lectura
		fprintf('Leyendo Electromiograma y Aplicando Filtros');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.\n');
		%Llama a la función Electromiograma
		Electromiograma();
		%Muestra el mensaje para salir del proceso
		disp('Presiona cualquier enter para salir');
		%Esta a la espera de enter para cerrar todo.
		c=input('');
		%Cierra todas las graficas y figuras.
		close all;
		%Limpia la pantalla
		clc;
		%Comienza con el proceso simulado de reinicio del sistema
		fprintf('Reiniciando programa');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.\n');
		%Llama a la función principal, reiniciando el programa
		Proyecto_SeguraMartinezAlejandro;
       
    case 3
        fprintf('Saliendo del programa');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.\n');
        pause (1);
        clc;
        return;
        
	otherwise
		%Simula un error por haber introducido un valor que no esta en el menu
		warning('Problem with Operador de Seleccion, please check it.')
		disp('Introduciste otro número o un caracter');
		%Utiliza la variable S y pausa el sistema 3 segundos
		pause (S);
		%Muestra el mensaje y simula el reinicio del programa
		fprintf('Reiniciando programa');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.');
		pause (1);
		fprintf('.\n');
		%Llama a la función principal, reiniciando el programa
		Proyecto_SeguraMartinezAlejandro;
end


end

function Electrocardiograma

	%Lee los datos del Electrocardiograma en archivo .cvs
	ECG=csvread('ECG.csv',0,1);
	% Frecuencia de Sampleo
		fs = 500;
	% Numero de datos a Evaluar  
		N=length(ECG);
	%Acomodando los datos en el vector para el plot
		T=1/fs : 1/fs : N/fs;
	%Normalizando los valores para -1 & 1
		ECG = ECG/max(abs(ECG));
	%Aplicando la transormada rápida de Fourier
		TF=abs(fftshift(fft(ECG)));
	%Vector que acomoda la TFourier
		f=-fs/2 : fs/(N-1) : fs/2;

	%Filtro para el Electrocardiograma, Filtro RechazaBanda
		h  = fdesign.bandstop('N,F3dB1,F3dB2', 10, 49, 52, fs);
		Hd = design(h, 'butter');
	% Aquí se filtra
		ECGFilt=filter(Hd,ECG);
	% Filtro rechazaBanda
		h  = fdesign.bandstop('N,F3dB1,F3dB2', 10, 150, 152, fs);
		Hd = design(h, 'butter');
	% Aquí se filtra
		ECGFilt=filter(Hd,ECGFilt);
	% Filtro paso bajo
		h  = fdesign.lowpass('N,F3dB', 5,20, fs);
		Hd = design(h, 'butter');
	% Filtrar
		ECGFilt=filter(Hd,ECGFilt);

		TFF=abs(fftshift(fft(ECGFilt)));

	graphic(T,f,ECG,ECGFilt,TF,TFF,'Electrocardiograma');

end


function Electromiograma
	% Leemos los datos del EMG
	EMG=csvread('EMG.csv',0,1);
	% fs es frecuencia de sampleo, el documento nos indica que fue capurado a 500s/s
		Fs = 40000;
	% N es el numero de datos
		N  = length(EMG);
	% T es el vector que acomoda los datos en el plot
		T=1/Fs:1/Fs:N/Fs;
	% Normalizar paras valores de -1 a 1
		EMG = EMG/max(abs(EMG));
	% Tranformada rápida de Fourier
		TF=abs(fftshift(fft(EMG)));
	% Vector para acomodar la FFT
		f=-Fs/2:Fs/(N-1):Fs/2;

	%Filtro para el Electrocardiograma, Filtro RechazaBanda
		h  = fdesign.highpass('N,F3dB', 10, 100, Fs);
		Hd = design(h, 'butter');
	% Aquí se filtra
		EMGFilt = filter(Hd,EMG);
	% Filtro rechazaBanda
		h  = fdesign.lowpass('N,F3dB', 10, 5000, Fs);
		Hd = design(h, 'butter');
	% Aquí se filtra
		EMGFilt = filter(Hd,EMGFilt);

		TFF=abs(fftshift(fft(EMGFilt)));

	graphic(T,f,EMG,EMGFilt,TF,TFF,'Electromiograma')



end


function graphic(x1,x2,y1,y2,y3,y4,titulo)

	%Gráfica de la señal sin filtrar
		%Gráfica 1
		G1 = figure(1);
		%Lee el titulo establecido en G1
		G1.Name = titulo;
		G1.NumberTitle = 'off';
		%Establece los parametros de las gráficas
		subplot(2,1,1);
			title('Señal');
			hold('on');
			grid('on');
			axis('tight');
			xlabel('Segundos');
			ylabel('Amplitud');
		plot(x1,y1,'Linewidth',1.5,'color','r');

		ylim([-1 2]);
		
		subplot(2,1,2);
		%Muestra la transformada de Fourier
			title('Transformada de Fourier');
			hold('on');
			grid('on');
			axis('tight');
			xlabel('Segundos');
			ylabel('Amplitud');
		plot(x2,y3,'Linewidth',1.5,'color','r');

		%Selecciona la posicion en la que se presentara la gráfica.
	position_1 = get(gcf,'Position');
	set(gcf,'Position', position_1 - [position_1(3)/2,0,0,0])


	%Gráfica de la señal Filtrada
		%Gráfica 2
		G2 = figure(2);
		%Lee el titulo establecido en G2
		G2.Name = titulo;
		G2.NumberTitle = 'off';
		%Establece los parametros de las gráficas
		subplot(2,1,1);
			title('Señal');
			hold('on');
			grid('on');
			axis('tight');
			xlabel('Segundos');
			ylabel('Amplitud');
		plot(x1,y2,'Linewidth',1.5,'color','g');

		ylim([-1 2]);

		subplot(2,1,2);
		%Muestra la transformada de Fourier
			title('Transformada de Fourier');
			hold('on');
			grid('on');
			axis('tight');
			xlabel('Segundos');
			ylabel('Amplitud');
		plot(x2,y4,'Linewidth',1.5,'color','g');	

		%Selecciona la posicion en la que se presentara la gráfica.
	position_2 = get(gcf,'Position');
	set(gcf,'Position', position_2 + [position_1(3)/2,0,0,0])

	%Gráfica de la señal sin filtrar
		%Gráfica 3
		G1 = figure(3);
		%Lee el titulo establecido en G1
		G1.Name = titulo;
		G1.NumberTitle = 'off';
		%Establece los parametros de las gráficas
		subplot(2,1,1);
			title('Comparación de señal');
			hold('on');
			grid('on');
			axis('tight');
			xlabel('Segundos');
			ylabel('Amplitud');
		plot(x1,y1,'Linewidth',1.5,'color','r');

		ylim([-1 2]);
		
		subplot(2,1,2);
		%Muestra la transformada de Fourier
			title('Transformada de Fourier');
			hold('on');
			grid('on');
			axis('tight');
			xlabel('Segundos');
			ylabel('Amplitud');
		plot(x2,y3,'Linewidth',1.5,'color','r');

		%Selecciona la posicion en la que se presentara la gráfica.
	position_1 = get(gcf,'Position');
	set(gcf,'Position', position_1 - [position_1(3)/2,0,0,0])


	%Gráfica de la señal Filtrada
		%Gráfica 3
		G2 = figure(3);
		%Lee el titulo establecido en G2
		G2.Name = titulo;
		G2.NumberTitle = 'off';
		%Establece los parametros de las gráficas
		subplot(2,1,1);
			title('Comparación de señal');
			hold('on');
			grid('on');
			axis('tight');
			xlabel('Segundos');
			ylabel('Amplitud');
		plot(x1,y2,'Linewidth',1.5,'color','g');

		ylim([-1 2]);

		subplot(2,1,2);
		%Muestra la transformada de Fourier
			title('Comparación de la Transformada de Fourier');
			hold('on');
			grid('on');
			axis('tight');
			xlabel('Segundos');
			ylabel('Amplitud');
		plot(x2,y4,'Linewidth',1.5,'color','g');	

		%Selecciona la posicion en la que se presentara la gráfica.
	position_2 = get(gcf,'Position');
	set(gcf,'Position', position_2 + [position_1(3)/2,0,0,0])



end