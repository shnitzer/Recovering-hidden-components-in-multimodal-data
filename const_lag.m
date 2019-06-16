 % Construct a lagmap of the signal
% ***************************************************************@

function [ lagsig ] = const_lag( sig, lag, jump )
%CONST_LAG constructs a lagmap of the signal, ``sig'', with a lag of
%``lag'' and and overlap of ``lag-jump''.

lagsig = lagmatrix(sig,0:lag);
lagsig = lagsig((lag+1):end,:);
lagsig = lagsig(1:jump:end,:);

end

