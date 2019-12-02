function ECGAndres
	% Limpiamos la pantalla
	clc
	% Cerramos las ventanas que se encuentren abiertas
	close all
	% Leemos el ECG, solo la columna de los datos, no la del tiempo
	Signal=csvread('ECG.csv',0,1);
	% La frecuencia de sampleo a la que fue grabado
	% es de 500Hz
	fs = 500;
	% N es el numero de datos
	N  = length(Signal);
	% T es la fórmula del vector para
	% graficar la señal
	T=1/fs:1/fs:N/fs;
	% TF es la transformada rapida de Fourier
	TF=abs(fftshift(fft(Signal)));
	% Aqui definimos el vector para
	% graficar la FFT
	f=-fs/2:fs/(N-1):fs/2;

	% Aplicamos un filtro paso bajos
	% de orden 5, con una frecuencia
	% de corte en los 20Hz
	h  = fdesign.lowpass('N,F3dB', 5,20, fs);
	Hd = design(h, 'butter');
	% Filtramos la señal
	SignalFiltrada=filter(Hd,Signal);
	% Aplicamos la FFT a la señal filtrada
	TFF=abs(fftshift(fft(SignalFiltrada)));

	% Mandamos a la funcion graficar
	graficar(T,f,Signal,SignalFiltrada,TF,TFF,'ECG');
end

function graficar(x1,x2,y1,y2,y3,y4,titulo)
	% Definimos los datos y apariencia
	f1 = figure(1);
	f1.Name = titulo;
	subplot(2,1,1)
	title('Señal')
	hold('on')
	grid('on')
	axis('tight')
	xlabel('Segundos')
	ylabel('Amplitud')
	% Graficamos la señal contra T
	plot(x1,y1)
	subplot(2,1,2)
	% Definimos los datos y apariencia
	title('Transformada de Fourier')
	hold('on')
	grid('on')
	axis('tight')
	xlabel('Frecuencia')
	ylabel('Amplitud')
	% Graficamos la señal contra f
	plot(x2,y3)
	pos1 = get(gcf,'Position');
	set(gcf,'Position', pos1 - [pos1(3)/2,0,0,0])
 	% Definimos los datos y apariencia
	f2 = figure(2);
	f2.Name = titulo;
	subplot(2,1,1)
	title('Señal')
	hold('on')
	axis('tight')
	grid('on')
	xlabel('Segundos')
	ylabel('Amplitud')
	% Graficamos la señal contra T
	plot(x1,y2)
	subplot(2,1,2)
	% Definimos los datos y apariencia
	title('Transformada Fourier')
	hold('on')
	axis('tight')
	grid('on')
	xlabel('Frecuencia')
	ylabel('Amplitud')
	% Graficamos la señal contra f
	plot(x2,y4)
	pos2 = get(gcf,'Position');
	set(gcf,'Position', pos2 + [pos1(3)/2,0,0,0])
end


