clear all; close all;

figure(1)
[y, Fs] = audioread('GNR.m4a');
tr_gnr = length(y)/Fs; % record time in seconds
plot((1:length(y))/Fs,y);
xlabel('Time [sec]'); ylabel('Amplitude');
title("GNR");
p8 = audioplayer(y,Fs); %playblocking(p8);
%% define variables
S = y';
t = (1:length(y))/Fs;
n = length(t);
L = t(end);
k = (2*pi/L)*[0:n/2-1 -n/2:-1];
ks = fftshift(k);
fil = zeros(1,length(ks));
for i = 1:length(fil)
    if (abs(ks(i))>4000) 
        fil(i) = 0;
    else 
        fil(i) = 1;
    end
end


%% Filtering
St = fft(S);
Stf = fftshift(St).*fil;
Sf = ifft(fftshift(Stf));
figure(2)
plot(ks,fftshift(St)/max(abs(St)))
xlim([-40000 40000])
hold on
plot(ks, fil, "LineWidth", 2)
xlabel("Angular Frequency")
ylabel("Amplitude")
title("Frequency Filtering")
legend("Signal", "Filter")


%% creating spectrogram

a = 70;
tau = 0:0.2:L;  
Sgtf_spec = zeros(length(S),length(tau));
for j = 1:length(tau)
   g = exp(-a*(t - tau(j)).^2); % Window function
   Sgf = g.*Sf;
   Sgtf = fft(Sgf);
   Sgtf_spec(:,j) = fftshift(abs(Sgtf));
end

figure(3)
pcolor(tau,ks/(2*pi),Sgtf_spec)
shading interp
set(gca,'ylim',[0 600],'Fontsize',16)
colormap(hot)
colorbar
xlabel('Time (t)'), ylabel('Frequency (Hz)')
title("GNR Spectrogram")

