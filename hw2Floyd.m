clear all; close all;

figure(1)
[y, Fs] = audioread('Floyd.m4a');
tr_gnr = length(y)/Fs; % record time in seconds
plot((1:length(y))/Fs,y);
xlabel('Time [sec]'); ylabel('Amplitude');
title("Floyd");
p8 = audioplayer(y,Fs); playblocking(p8);

%% define variables
S = y'; %signal
t = (1:length(y))/Fs; %times
n = length(t);
L = t(end); %length of time domain
k = (2*pi/L)*[0:n/2 -n/2:-1]; %frequency domain
ks = fftshift(k);
fil = zeros(1,length(ks)); %band pass filter
for i = 1:length(fil)
    if (abs(ks(i))>1000) 
        fil(i) = 0;
    else 
        fil(i) = 1;
    end
end


%% Filtering out everything but bass
St = fft(S);
Stf = fftshift(St).*fil;
Sf = ifft(fftshift(Stf));
plot(ks,fftshift(St)/max(abs(St)))
xlim([-15000 15000])
hold on
plot(ks, fil, "LineWidth", 2)
xlabel("Angular Frequency")
ylabel("Amplitude")
title("Floyd Bass Filter")
legend("Signal", "Filter")


%% creating spectrogram for bass

a = 70;
tau = 0:1.5:L;
Sgtf_spec = zeros(length(S),length(tau));
for j = 1:length(tau)
   g = exp(-a*(t - tau(j)).^2); % Window function
   Sgf = g.*Sf;
   Sgtf = fft(Sgf);
   Sgtf_spec(:,j) = fftshift(abs(Sgtf));
end

figure(2)
pcolor(tau,ks/(2*pi),Sgtf_spec)
shading interp
set(gca,'ylim',[0 200],'Fontsize',16)
colorbar
colormap(hot)
title("Bass Spectrogram")
xlabel('time (t)'), ylabel('frequency (Hz)')
%% filtering out everything but guitar
fil = zeros(1,length(ks));
for i = 1:length(fil)
    if (abs(ks(i))<1000 | abs(ks(i))>4000)
        fil(i) = 0;
    else 
        fil(i) = 1;
    end
end
Stf = fftshift(St).*fil;
plot(ks,fftshift(St)/max(abs(St)))
xlim([-15000 15000])
hold on
plot(ks, fil, "LineWidth", 2)
xlabel("Angular Frequency")
ylabel("Amplitude")
title("Floyd Guitar Filter")
legend("Signal", "Filter")
Sf = ifft(fftshift(Stf));
%% creating spectrogram for guitar
a = 140;
tau = 0:1:L;
Sgtf_spec = zeros(length(S),length(tau));
for j = 1:length(tau)
   g = exp(-a*(t - tau(j)).^2); % Window function
   Sgf = g.*Sf;
   Sgtf = fft(Sgf);
   Sgtf_spec(:,j) = fftshift(abs(Sgtf)); % We don't want to scale it
end

figure(3)
pcolor(tau,ks/(2*pi),Sgtf_spec)
shading interp
colormap(hot)
set(gca,'ylim',[0 1000],'Fontsize',16)
title("Guitar Spectrogram")
colorbar
xlabel('time (t)'), ylabel('frequency (Hz)')