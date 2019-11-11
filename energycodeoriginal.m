filename = '1219.xlsx'; % sample file
A = xlsread(filename); %sample signal
input=A(1000:48000,6);
inputside=A(1000:48000,6);
filterorder=6;
[b,a]=butter(filterorder,[0.014,0.2]); % butterworth filter of 6th order selected with passband 0.7 to 10 Hz
pulserate_input=filter(b,a,input);
input4=A(1000:48000,4);
filtered_input4=filter(b,a,input4);
windowsize=30; 
slide=10;  %66.3 % overlap considered. Can be changed according to requirements.
k=1;
% Calculation of the energy (amplitude^2) by sliding window 

for i =1:slide:length(filtered_input4)-windowsize+1
    energy(k)=sum(filtered_input4(i:i+windowsize-1).^2);
    k=k+1;
end
outputsmooth=smooth(energy);
[pks loc]=findpeaks(outputsmooth);% pks gives peak amplitude. Loc gives the location of the peak.
xaxis=1/100:1/100:length(filtered_input4)/100;
xaxisenergy=1/10:1/10:length(energy)/10;
figure;
ax(1)=subplot(3,1,1)
plot(xaxis,pulserate_input,'k-');grid on;box on;  %plot the pulse_rate (ground truth) signal
set(gca,'fontsize',14);
ylabel('pulse transducer')
xlim([30 60])
ax(2)=subplot(3,1,2)
plot(xaxis,filtered_input4,'k-');grid on;hold on; %plot the of the accelerometer signal
set(gca,'fontsize',14);
ylabel('Acclerometer under')
xlim([30 60])
% plot the energy of the signal with peaks
ax(3)=subplot(3,1,3)
plot(xaxisenergy,outputsmooth,'k-');grid on;box on;hold on; %plot of the energy of the accelerometer signal
plot(loc/10,pks,'ro');hold off;
set(gca,'fontsize',14);
ylabel('Accelerometer-Energy');
xlim([30 60])
xlabel('Seconds');
linkaxes(ax,'x');

