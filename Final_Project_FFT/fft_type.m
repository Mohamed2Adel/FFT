% function T = fft_type()
% % Define fixed-point types with 12 total bits (4 integer, 8 fractional)
% % Logging is enabled after creation
% 
%     WL = 12;   % Total word length
%     FL = 8;    % Fraction length
% 
%     T.x  = fi(0, 1, WL, FL);    % Input
%     T.X  = fi(0, 1, WL, FL);    % Output/intermediate
%     T.W  = fi(0, 1, WL, FL);    % Twiddle factor
%     T.t  = fi(0, 1, WL, FL);    % Temporary result
%     T.u  = fi(0, 1, WL, FL);    % Intermediate variable
% 
% 
% end

function T = fft_type(dt)
% Returns a struct of typed variables based on 'dt': 'double', 'single', or 'fixed'
% Safe for versions that do NOT support LoggingMode or DataTypeOverride

    switch dt
        case 'double'
            T.x = double([]);
            T.W = double([]);
            T.X = double([]);
            T.t = double([]);
            T.u = double([]);

        case 'single'
            T.x = single([]);
            T.W = single([]);
            T.X = single([]);
            T.t = single([]);
            T.u = single([]);

        case 'fixed'
            wl = 12; fl = 8;

            T.x = fi(complex(0, 0), 1, wl, fl);  % complex fi
            T.W = fi(complex(0, 0), 1, wl, fl); 
            T.X = fi(complex(0, 0), 1, wl, fl); 
            T.t = fi(complex(0, 0), 1, wl, fl); 
            T.u = fi(complex(0, 0), 1, wl, fl);


        otherwise
            error("Unsupported type '%s'", dt);
    end
end






