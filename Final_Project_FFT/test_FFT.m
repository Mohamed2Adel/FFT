% test_fft.m
clc; clear;

% Input vector
x = rand(1, 8);  % You can change to complex: x = rand(1,8) + 1i*rand(1,8);

% Run custom FFT
X_custom = FFT(x);

% Run MATLAB built-in FFT
X_builtin = fft(x);

% Display results
disp("Custom FFT Output:")
disp(X_custom)
disp("MATLAB FFT Output:")
disp(X_builtin)

% Difference
err = norm(X_custom - X_builtin);
fprintf("Difference Norm = %.6e\n", err);

% Plot results
figure;
subplot(2,1,1)
stem(abs(X_custom), 'filled'); title('Magnitude'); xlabel('Index'); ylabel('|X(k)|');

subplot(2,1,2)
stem(angle(X_custom), 'filled'); title('Phase'); xlabel('Index'); ylabel('∠X(k)');


