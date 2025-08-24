% function X = fft_prepared_fixpt(x)
% % Fixed-point Radix-2 FFT (N = 8)
% % Uses fixed-point types defined in fft_type.m
% % Input: x must be a complex fi vector (like T.x)
% 
%     %#codegen
%     N = 8;
%     stages = 3;
% 
%     % Load fixed-point type definitions
%     T = fft_type();
% 
%     % Initialize output with same type as T.X
%     X = repmat(T.X, 1, N);
% 
%     % Bit-reversal permutation
%     bitrev = [1 5 3 7 2 6 4 8];
%     x = x(bitrev);                          % Reorder input
%     X(:) = cast(x, 'like', T.X);            % Store into output
% 
%     % Precompute twiddle factors once
%     persistent W;
%     if isempty(W)
%         W = cast(exp(-2i * pi * (0:N/2 - 1) / N), 'like', T.W);
%     end
% 
%     % FFT Computation (Butterfly)
%     for s = 1:stages
%         m = 2^s;
%         half_m = m / 2;
%         for k = 1:m:N
%             for j = 0:half_m - 1
%                 idx1 = k + j;
%                 idx2 = k + j + half_m;
% 
%                 tw = W(mod(j * (N / m), N/2) + 1);       % Twiddle
%                 t  = cast(tw * X(idx2), 'like', T.t);    % Twiddle product
%                 u  = cast(X(idx1),      'like', T.u);    % Copy
% 
%                 X(idx1) = cast(u + t, 'like', T.X);      % Butterfly +
%                 X(idx2) = cast(u - t, 'like', T.X);      % Butterfly –
%             end
%         end
%     end
% end

function X = fft_prepared_fixpt(x)
% fft_prepared_fixpt - Fixed-point Radix-2 FFT (N = 8)
% Uses fixed-point types defined in fft_type.m
% Input: x must be a complex fi vector (like T.x)

    %#codegen

    N = 8;                  % FFT size
    stages = 3;             % log2(N)

    % Load fixed-point types ('fixed' mode)
    T = fft_type('fixed');

    % Initialize output vector with same type as T.X
    X = repmat(T.X, 1, N);

    % Bit-reversal permutation for input
    bitrev = [1 5 3 7 2 6 4 8];
    x = x(bitrev);  % Reorder input based on bit-reversal

    % Cast reordered input to match output type and assign
    X(:) = reshape(cast(x, 'like', T.X), 1, []);  % Ensure correct shape (row vector)

    % Precompute twiddle factors (half-length, reused)
    persistent W;
    if isempty(W)
        W = cast(exp(-2i * pi * (0:N/2 - 1) / N), 'like', T.W);
    end

    % Radix-2 Decimation-in-Time FFT computation
    for s = 1:stages
        m = 2^s;                % FFT block size
        half_m = m / 2;

        for k = 1:m:N
            for j = 0:half_m - 1
                idx1 = k + j;
                idx2 = k + j + half_m;

                % Get twiddle factor
                tw = W(mod(j * (N / m), N/2) + 1);

                % Butterfly computation (in fixed-point)
                t = cast(tw * X(idx2), 'like', T.t);  % Twiddle multiplication
                u = cast(X(idx1),       'like', T.u);  % Copy upper

                X(idx1) = cast(u + t, 'like', T.X);   % Upper output
                X(idx2) = cast(u - t, 'like', T.X);   % Lower output
            end
        end
    end
end


