% for i = 1:1000
%     %x = complex(rand(1,8));  % Random complex input (same as actual FFT use case)
%     real_part = 2 * rand(1,8) - 1;
%     imag_part = 2 * rand(1,8) - 1;
%     x = complex(real_part, imag_part);
% 
%     fft_prepared_mex(x);     % This logs variable min/max in the MEX version
% end
% %x = complex(rand(1,8));
% real_part = 2 * rand(1,8) - 1;
% imag_part = 2 * rand(1,8) - 1;
% x = complex(real_part, imag_part);
% 
% y_mex = fft_prepared_mex(x);
% y_matlab = fft_prepared(x);
% 
% fprintf("MEX vs MATLAB diff: %.6e\n", norm(y_mex - y_matlab));


T = fft_type('fixed');

% Create a sample 1x8 vector in the correct type
example_input_fixed = repmat(T.x, 1, 8);
example_input_double = complex(zeros(1,8), zeros(1,8));

% Rebuild instrumented MEX with the right size and type
buildInstrumentedMex fft_prepared -args {example_input_fixed};


% 3. Run multiple tests
for i = 1:1000
    real_part = 2 * rand(1,8) - 1;
    imag_part = 2 * rand(1,8) - 1;
    x = cast(complex(real_part, imag_part), 'like', T.x);

    fft_prepared_mex(x);   % This logs variable min/max
end

% 4. Final comparison
real_part = 2 * rand(1,8) - 1;
imag_part = 2 * rand(1,8) - 1;
x = cast(complex(real_part, imag_part), 'like', T.x);

y_mex = fft_prepared_mex(x);
y_matlab = fft_prepared(x);

fprintf("MEX vs MATLAB diff: %.6e\n", norm(double(y_mex) - double(y_matlab)));

% 5. Show instrumentation results
showInstrumentationResults('fft_prepared_mex');

