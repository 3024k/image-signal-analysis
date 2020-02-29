% The following function implement whitening
%
% Input:  x It is a matrix mixture(dxn)
%
% Output: y é uma matrix (dxn) which is the whitening result
%
%
%
% Autor:   Nielsen C. Damasceno
% Data:     20.12.2010
function [y] = whitening(x)
    [E, D] = eig(cov(x'));
    y = E*D^(-0.5)*E' * x;
end