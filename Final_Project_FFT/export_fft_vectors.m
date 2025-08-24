function export_fft_vectors()
    % Parameters
    N = 8;
    WIDTH = 12;      % total bits
    FRACTION = 8;    % fractional bits (Qm.F format)

    % Load fixed-point types
    T = fft_type('fixed');

    % Test input
    real_part = randn(1, N);
    imag_part = randn(1, N);
    x_float   = complex(real_part, imag_part);

    % Cast to fixed-point
    x_fixed = cast(x_float, 'like', T.x);

    % Run fixed-point FFT
    y_fixed = fft_prepared_fixpt(x_fixed);

    % === Export Inputs ===
    fid = fopen('input_data.mem', 'w');
    for k = 1:N
        re_hex = storedInteger(fi(real(x_fixed(k)), 1, WIDTH, FRACTION));
        im_hex = storedInteger(fi(imag(x_fixed(k)), 1, WIDTH, FRACTION));
        fprintf(fid, '%03X\n', bitand(re_hex, 2^WIDTH - 1));
        fprintf(fid, '%03X\n', bitand(im_hex, 2^WIDTH - 1));
    end
    fclose(fid);

    % === Export Expected Outputs ===
    fid = fopen('expected_output.mem', 'w');
    for k = 1:N
        re_hex = storedInteger(fi(real(y_fixed(k)), 1, WIDTH, FRACTION));
        im_hex = storedInteger(fi(imag(y_fixed(k)), 1, WIDTH, FRACTION));
        fprintf(fid, '%03X\n', bitand(re_hex, 2^WIDTH - 1));
        fprintf(fid, '%03X\n', bitand(im_hex, 2^WIDTH - 1));
    end
    fclose(fid);

    % === Debug print ===
    disp('Fixed-point input samples:');
    disp(x_fixed);
    disp('Stored integers (hex):');
    for k = 1:N
        fprintf('X[%d] re=%03X im=%03X\n', k, ...
            bitand(storedInteger(fi(real(x_fixed(k)), 1, WIDTH, FRACTION)), 2^WIDTH-1), ...
            bitand(storedInteger(fi(imag(x_fixed(k)), 1, WIDTH, FRACTION)), 2^WIDTH-1));
    end

    disp('Fixed-point FFT output samples:');
    disp(y_fixed);
    disp('Stored integers (hex):');
    for k = 1:N
        fprintf('Y[%d] re=%03X im=%03X\n', k, ...
            bitand(storedInteger(fi(real(y_fixed(k)), 1, WIDTH, FRACTION)), 2^WIDTH-1), ...
            bitand(storedInteger(fi(imag(y_fixed(k)), 1, WIDTH, FRACTION)), 2^WIDTH-1));
    end
end


