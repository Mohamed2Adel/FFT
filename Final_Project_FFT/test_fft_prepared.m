clc; clear;

x = rand(1,8);  % Input signal

% Run your hardware-prepared FFT
X_hw = fft_prepared(x);

% Compare with MATLAB built-in
X_ref = fft(x);

% Print error
fprintf("Difference norm = %.6e\n", norm(X_hw - X_ref));

% Plot comparison
figure;
subplot(2,2,1); stem(abs(X_hw), 'filled'); title('Prepared FFT - Magnitude');
subplot(2,2,2); stem(abs(X_ref), 'filled'); title('MATLAB FFT - Magnitude');
subplot(2,2,3); stem(angle(X_hw), 'filled'); title('Prepared FFT - Phase');
subplot(2,2,4); stem(angle(X_ref), 'filled'); title('MATLAB FFT - Phase');
