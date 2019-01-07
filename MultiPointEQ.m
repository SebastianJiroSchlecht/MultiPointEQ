function [num, den] = MultiPointEQ(IR,varargin)
%MultiPointEQ Estimates frequency response with allpole filter.
%   [num, den] = MultiPointEQ(IR,varargin) reads multiple impulse responses IR,
%   and approximates the magnitude response by an allpole model. The method
%   is taken from
%       Multiple-point equalization of room transfer functions by using common acoustical poles
%       by Haneda, Y. and Makino, S. and Kaneda, Y.
%       in IEEE Transactions on Speech and Audio Processing.
%
%   INPUT:
%       IR                          impulse response [ len, numCh ]
%       numPoles (optional)         filter order of the approximation
%    
%   OUTPUT
%       num                         numerator of filter (always 1)
%       den                         denominator of filter [ 1 , numPoles ]
%
%   
%
%
%   Sebastian Schlecht (schlecsn), 2013
%   Audiolabs Erlangen-N?rnberg


%% input parser
p = inputParser;
defaultNumPoles = 100;

addRequired(p,'IR',@isnumeric);
addOptional(p,'numPoles',defaultNumPoles,@isnumeric);

parse(p,IR,varargin{:});

IR = p.Results.IR;
P = p.Results.numPoles;

[n,m] = size(IR);
if m > n % rotate IR if not correct
    error('Impulse Responses have to be column vectors')
end




%% Algortihm
W = [];
v = [];

for itm = 1:m
    H_i = [];
    h_i = IR(:,itm);
    for it = 1:P
        H_i = [H_i, [zeros(it - 1, 1); h_i; zeros(P - it, 1)]];
    end
    W = [W; H_i];
    v = [v; [h_i(2:end); zeros(P - 0, 1)]];
end

a = (W' * W) \ (W' * v);


%% Result
den = [1; -a];
num = 1;


