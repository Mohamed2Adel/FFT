function X = FFT(x)
    N = length(x);
    
    % Base case
    if N == 1
        X = x;
    else
        % Recursive FFT on even and odd indices
        X_even = FFT(x(1:2:end));
        X_odd  = FFT(x(2:2:end));
        
        % Twiddle factors
        W = exp(-2i * pi * (0:N/2-1) / N);
        
        % Combine
        X = [X_even + W .* X_odd, ...
             X_even - W .* X_odd];
    end
end



