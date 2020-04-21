% example for multi point eqalisation routine
clear; clc; close all;
rng(1);

%% create some impulse responses from all pole models
n = 2^13;
numPoles = 50;
numOfIR = 10;

% create poles
poleAngles = rand(numPoles/2 , 1) * pi ;
poleMag = rand(numPoles/2 , 1) * 0.09 + 0.9;
polePos = poleMag .* exp(1i * poleAngles);
polePos = [polePos; conj(polePos)];

% simulated denominator
a = poly(polePos);

IR = [];
for it = 1:numOfIR
    % create randomised nominator
    zeroLengthFactor = 4; % scale length of nominator
    b = randn(numPoles * zeroLengthFactor, 1) ; b = b / norm(b);
    % compute simulated impulse response
    [h,t] = impz(b,a,n);
    IR = [IR, h];
end

%% MULTI POINT EQUALISATION
[num, den] = MultiPointEQ(IR,numPoles * 2);


%% plot results
figure(1); hold on; grid on;

% approximation frequency response
[h,w]  = freqz(num, den);
h = mag2db(abs(h));
plot(w, h, 'r','LineWidth',2);

% inverse frequency response
[h,w]  = freqz(den, 1);
h = mag2db(abs(h));
plot(w, h, 'g')

% last IR frequency response
for it = 1:numOfIR
    [h,w]  = freqz(IR(:,it), 1);
    h = mag2db(abs(h));
    plot(w, h)
end

% labels
axis tight
xlabel('Frequency [rad]')
ylabel('Magnitude [dB]')
title('Magnitude Response of Multi-Point Equalisation')
legend('Multi-point Approximation', 'Multi-point Inverse','Simulated IRs')
hold off;
