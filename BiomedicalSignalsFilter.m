function PLE1
	clc;
	close all;

	% Leemos los datos del ECG
	ECG=csvread('/Users/gomez/Documents/MATLAB/ECG.csv',0,1);
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
	sfilt=filter(Hd,ECG);
	% Filtro rechazaBanda
	h  = fdesign.bandstop('N,F3dB1,F3dB2', 10, 150, 152, fs);
	Hd = design(h, 'butter');
	% Aquí se filtra
	sfilt=filter(Hd,sfilt);
	% Filtro paso bajo
	h  = fdesign.lowpass('N,F3dB', 5,20, fs);
	Hd = design(h, 'butter');
	% Filtrar
	sfilt=filter(Hd,sfilt);

	TFF=abs(fftshift(fft(sfilt)));


	graficarECG(T,ECG,sfilt)

end

function graficarECG(x,y1,y2)
	% Graficar la señal sin filtro
	f1 = figure(1);
	f1.Name = 'Señal sin Filtro';
	f1.NumberTitle = 'off';
	title('Sin Filtro')
	hold('on')
	grid('on')
	axis('tight')
	xlabel('Segundos')
	ylabel('Amplitud')
	% spectrogram(ySF)
	plot(x,y1,'LineWidth',1.5)
	% periodogram(ySF)
	ylim([-1 2])
	% xlim([0 5])

	% Figura lado a lado
	pos1 = get(gcf,'Position');
	set(gcf,'Position', pos1 - [pos1(3)/2,0,0,0])

	% % Graficar la señal filtrada
	f2 = figure(2);
	f2.Name = 'Señal Filtrada';
	f2.NumberTitle = 'off';
	title('Con Filtro')
	hold('on')
	axis('tight')
	grid('on')
	xlabel('Segundos')
	ylabel('Amplitud')
	plot(x,y2,'LineWidth',1.5)
	% spectrogram(yCF)
	ylim([-1 2])
	% xlim([0 5])

	% Figura lado a lado
	pos2 = get(gcf,'Position');
	set(gcf,'Position', pos2 + [pos1(3)/2,0,0,0])
end
