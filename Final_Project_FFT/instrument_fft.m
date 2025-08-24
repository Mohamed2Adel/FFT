function Tinst = instrument_fft(T)
% instrument_fft - Create an instrumented fixed-point type based on T
%
%   Tinst = instrument_fft(T) returns a fixed-point type with the same
%   properties as T, but with logging (Min, Max, Overflow) enabled.

    Tinst = fi([], ...
        1, ...                                % Signed
        T.WordLength, ...
        T.FractionLength, ...
        'LoggingMode', 'MinMaxOverflow');     % Enable instrumentation
end

