% Example for multi-point equalization routine
%
% Sebastian J. Schlecht, Tuesday, 21. April 2020

clear; clc; close all;
rng(1);

%% Create some impulse responses from all pole models
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

%% Multi-point Equalization
[num, den] = MultiPointEQ(IR,numPoles * 2);


%% Plot results
figure(1); hold on; grid on;

% approximation frequency response
[h,w]  = freqz(num, den);
h = mag2db(abs(h));
p1 = plot(w, h, 'r','LineWidth',2);

% inverse frequency response
[h,w]  = freqz(den, 1);
h = mag2db(abs(h));
p2 = plot(w, h, 'g');

% last IR frequency response
for it = 1:numOfIR
    [h,w]  = freqz(IR(:,it), 1);
    h = mag2db(abs(h));
    p3 = plot(w, h);
end
uistack(p1,'top');

% labels
axis tight
xlabel('Frequency [rad]')
ylabel('Magnitude [dB]')
title('Magnitude Response of Multi-Point Equalisation')
legend([p1,p2,p3(1)],'Multi-point Approximation', 'Multi-point Inverse','Simulated IRs')
hold off;
