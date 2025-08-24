%#codegen
function X = fft_prepared(x)
    N = 8;
    stages = 3;
    
    % Preallocate output X as complex
    X = complex(zeros(1, N));  % <-- force complex for codegen compatibility

    % Bit-reversal for N = 8
    bitrev = [1 5 3 7 2 6 4 8];
    x = x(bitrev);

    X(:) = x;

    % Use persistent variable for twiddle factors
    persistent W;
    if isempty(W)
        W = exp(-2i * pi * (0:N/2 - 1) / N);  % Precompute twiddle factors
    end

    % Loop stages
    for s = 1:stages
        m = 2^s;
        half_m = m / 2;
        for k = 1:m:N
            for j = 0:half_m-1
                idx1 = k + j;
                idx2 = k + j + half_m;

                % Twiddle factor from precomputed W
                tw = W(mod(j * (N / m), N/2) + 1);

                t = tw * X(idx2);
                u = X(idx1);

                X(idx1) = u + t;
                X(idx2) = u - t;
            end
        end
    end
end

