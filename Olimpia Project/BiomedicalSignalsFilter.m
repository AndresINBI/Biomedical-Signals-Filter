function BiomedicalSignalsFilter
	clc;
	close all;
	op=0;

	while (op ~= 4)

		display('Selecciona la señal que quieres analizar:');
		fprintf('1.-ECG\n2.-EMG\n3.-EEG\n4.-Salir\n');
		op = input('');   
		switch op
			case 1
				FilterECG();
				disp('Presiona Enter para cerrar');
				x=input('');
				close all;
				clc;
				
			case 2
				FilterEMG();
				disp('Presiona Enter para cerrar');
				x=input('');
				close all;
				clc;
			case 3
				FilterEEG();
				disp('Presiona Enter para cerrar');
				x=input('');
				close all;
				clc;
			case 4
			otherwise
				op=0;
				clc;
				disp('Hola');
				
		end
	end
end

function FilterECG
	% Leemos los datos del ECG
	ECG=csvread('ECG.csv',0,1);
	% fs es frecuencia de sampleo, el documento nos indica que fue capurado a 500s/s
	fs = 500;
	% N es el numero de datos
	N  = length(ECG);
	% T es el vector que acomoda los datos en el plot
	T=1/fs:1/fs:N/fs;
	% Normalizar paras valores de -1 a 1
	ECG = ECG/max(abs(ECG));
	% Tranformada rápida de Fourier
	TF=abs(fftshift(fft(ECG)));
	% Vector para acomodar la FFT
	f=-fs/2:fs/(N-1):fs/2;

	% Filtro rechazaBanda
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

	graficar(T,f,ECG,ECGFilt,TF,TFF,'ECG');
end

function FilterEMG
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

	h  = fdesign.highpass('N,F3dB', 10, 100, Fs);
	Hd = design(h, 'butter');
	EMGFilt = filter(Hd,EMG);
	h  = fdesign.lowpass('N,F3dB', 10, 5000, Fs);
	Hd = design(h, 'butter');
	EMGFilt = filter(Hd,EMGFilt);

	TFF=abs(fftshift(fft(EMGFilt)));

	graficar(T,f,EMG,EMGFilt,TF,TFF,'EMG')
end

function FilterEEG
end

function graficar(x1,x2,y1,y2,y3,y4,titulo)
	% Graficar la señal sin filtro
	f1 = figure(1);
	f1.Name = titulo;
	f1.NumberTitle = 'off';
	subplot(2,1,1)
	title('Señal')
	hold('on')
	grid('on')
	axis('tight')
	xlabel('Segundos')
	ylabel('Amplitud')
	plot(x1,y1,'LineWidth',1.5)

	ylim([-1 2])

	subplot(2,1,2)
	title('Transformada de Fourier')
	hold('on')
	grid('on')
	axis('tight')
	xlabel('Frecuencia')
	ylabel('Amplitud')
	plot(x2,y3,'LineWidth',1.5)


	% Figura lado a lado
	pos1 = get(gcf,'Position');
	set(gcf,'Position', pos1 - [pos1(3)/2,0,0,0])

	% % Graficar la señal filtrada
	f2 = figure(2);
	f2.Name = titulo;
	f2.NumberTitle = 'off';
	subplot(2,1,1)
	title('Señal')
	hold('on')
	axis('tight')
	grid('on')
	xlabel('Segundos')
	ylabel('Amplitud')
	plot(x1,y2,'LineWidth',1.5)
	ylim([-1 2])

	subplot(2,1,2)
	title('Transformada Fourier')
	hold('on')
	axis('tight')
	grid('on')
	xlabel('Frecuencia')
	ylabel('Amplitud')
	plot(x2,y4,'LineWidth',1.5)

	% Figura lado a lado
	pos2 = get(gcf,'Position');
	set(gcf,'Position', pos2 + [pos1(3)/2,0,0,0])
end


