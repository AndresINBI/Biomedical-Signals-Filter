import sympy as sym
from scipy.fftpack import fft
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import butter, lfilter, freqz

def lpFilter(datos, fc, fs, order=5):
    b, a = butter_lowpass(fc, fs, order=order)
    y = lfilter(b, a, datos)
    return y

def butter_lowpass(cutoff, fs, order=5):
    nyq = 0.5 * fs
    normal_cutoff = cutoff / nyq
    b, a = butter(order, normal_cutoff, btype='low', analog=False)
    return b, a

# Leer ECG
ECG = np.genfromtxt('ECG.csv',delimiter=',',usecols=(1))
# Frecuencia de sampleo

fs = 500
# Numero de Samples
N = ECG.size
# Vector de tiempo
T = np.linspace(1/fs,N/fs,N)

f = np.linspace(0.0, 1.0/(2.0*(1/fs)), N/2)
TF = fft(ECG)

yf = lpFilter(ECG,10,500)
TFF = fft(yf)

fig, axs = plt.subplots(2, 1, tight_layout=False)
fig.suptitle('ECG Sin Filtro', fontsize=14)
fig.subplots_adjust(left=0.125,bottom = 0.1,top = 0.86,wspace = 0.2,hspace = 0.50)
axs[0].plot(T,ECG,color='r',linewidth=1)
axs[0].set_title('ECG')
axs[0].set_xlabel('Tiempo')
axs[0].set_ylabel('Amplitud')

axs[1].plot(f,2/N * np.abs(TF[:N//2]),color='b',linewidth=0.7)
axs[1].set_title('FFT')
axs[1].set_ylabel("Amplitud")
axs[1].set_xlabel("Frecuencia")

fig, axs = plt.subplots(2, 1, tight_layout=False)
fig.suptitle('ECG Filtrado', fontsize=14)
fig.subplots_adjust(left=0.125,bottom = 0.1,top = 0.86,wspace = 0.2,hspace = 0.50)
axs[0].plot(T,yf,color='r',linewidth=1)
axs[0].set_title('ECG')
axs[0].set_xlabel('Tiempo')
axs[0].set_ylabel('Amplitud')

axs[1].plot(f,2/N * np.abs(TFF[:N//2]),color='b',linewidth=0.7)
axs[1].set_title('FFT')
axs[1].set_ylabel("Amplitud")
axs[1].set_xlabel("Frecuencia")
plt.show()





