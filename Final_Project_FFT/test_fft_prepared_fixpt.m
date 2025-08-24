% function test_fft_prepared_fixpt()
%     % Testbench for fft_prepared_fixpt using fft_type.m definitions
% 
%     % Load fixed-point types
%     T = fft_type();
% 
%     % Create input signal (e.g., length-8 complex Gaussian)
%     N = 8;
%     real_part = randn(1, N);       
%     imag_part = randn(1, N);       
%     fprintf("Max real: %.3f, Min real: %.3f\n", max(real_part), min(real_part));
%     fprintf("Max imag: %.3f, Min imag: %.3f\n", max(imag_part), min(imag_part));
%     x = complex(real_part, imag_part);
% 
%     % Cast to fixed-point using your existing type
%     x = cast(x, 'like', T.x);
% 
%     % Run the fixed-point FFT
%     y_fixed = fft_prepared_fixpt(x);
% 
%     % Compare with floating-point FFT
%     y_float = fft_prepared(double(x));
% 
%     % Calculate norm difference
%     diff = norm(double(y_fixed) - y_float);
% 
%     % Display result
%     fprintf("Fixed-point error norm = %.3e\n", diff);
% 
%     % Plot comparison
%     figure;
%     subplot(2,1,1); stem(abs(y_fixed), 'filled'); title('Fixed-point FFT |Y|');
%     subplot(2,1,2); stem(abs(y_float), 'filled'); title('Floating-point FFT |Y|');
% 
%     % Instrumentation removed due to unsupported MATLAB version
% end

function test_fft_prepared_fixpt()
    % Testbench for fft_prepared_fixpt using fft_type.m

    % Load fixed-point types
    T = fft_type('fixed');

    % Generate test input
    N = 8;
    real_part = randn(1, N);
    imag_part = randn(1, N);
    x = complex(real_part, imag_part);

    % Display input statistics before casting
    fprintf("Max real: %.3f, Min real: %.3f\n", max(real_part), min(real_part));
    fprintf("Max imag: %.3f, Min imag: %.3f\n", max(imag_part), min(imag_part));

    % Cast input to fixed-point
    x = cast(x, 'like', T.x);

    % Run fixed-point FFT
    y_fixed = fft_prepared_fixpt(x);

    % Floating-point reference using MATLAB's built-in FFT
    y_float = fft(double(x));   % ✅ Built-in FFT as reference


    % Compute and report error norm
    diff = norm(double(y_fixed) - y_float);
    fprintf("Fixed-point error norm = %.3e\n", diff);

    % === SQNR Calculation ===
    err = double(y_float) - double(y_fixed);
    sqnr = 10*log10(sum(abs(y_float).^2) / sum(abs(err).^2));
    fprintf("SQNR vs MATLAB FFT = %.3f dB\n", sqnr);

    % Plot comparison of magnitudes
    figure;
    subplot(2,1,1); stem(abs(y_fixed), 'filled'); title('Fixed-point FFT |Y|');
    subplot(2,1,2); stem(abs(y_float), 'filled'); title('MATLAB Floating-point FFT |Y|');

    % Show output range manually
    fprintf("Fixed-point output min: %.3f, max: %.3f\n", ...
        min(abs(double(y_fixed))), max(abs(double(y_fixed))));

    export_fft_vectors();
end


% function test_fft_prepared_fixpt()
%     % Testbench for fft_prepared_fixpt using fft_type.m
%     % Runs multiple trials to calculate average SQNR
% 
%     % Load fixed-point types
%     T = fft_type('fixed');
% 
%     N = 8;            % FFT length
%     numTrials = 10; % Number of random test vectors
% 
%     sqnr_values = zeros(1, numTrials);
% 
%     for trial = 1:numTrials
%         % === Generate random input ===
%         real_part = randn(1, N);
%         imag_part = randn(1, N);
%         x = complex(real_part, imag_part);
% 
%         % Cast to fixed-point
%         x = cast(x, 'like', T.x);
% 
%         % === Run FFT ===
%         y_fixed = fft_prepared_fixpt(x);     % Fixed-point FFT
%         y_float = fft(double(x));            % MATLAB built-in FFT
% 
%         % === SQNR Calculation ===
%         err = double(y_float) - double(y_fixed);
%         sqnr_values(trial) = 10*log10(sum(abs(y_float).^2) / sum(abs(err).^2));
%     end
% 
%     % === Report results ===
%     fprintf("Average SQNR over %d trials: %.3f dB\n", numTrials, mean(sqnr_values));
%     fprintf("Minimum SQNR: %.3f dB\n", min(sqnr_values));
%     fprintf("Maximum SQNR: %.3f dB\n", max(sqnr_values));
% 
%     % === Plot last trial comparison ===
%     figure;
%     subplot(2,1,1); stem(abs(y_fixed), 'filled'); title('Fixed-point FFT |Y|');
%     subplot(2,1,2); stem(abs(y_float), 'filled'); title('Floating-point FFT |Y|');
% end











