function  [Z] =  MCWSNM( Y, NSig, Par )
if ~isfield(Par, 'maxIter')
    Par.maxIter = 10;
end
if ~isfield(Par, 'rho')
    Par.rho = 1;
end
if ~isfield(Par, 'mu')
    Par.mu = 1;
end
if ~isfield(Par, 'display')
    Par.display = true;
end

mNSig = min(NSig);
W = (mNSig+eps) ./ (NSig+eps);

% Initializing optimization variables
X = zeros(size(Y));
Z = zeros(size(Y));
A = zeros(size(Y));
%% Start main loop
iter = 0;
PatNum       = size(Y,2);
% TempC  = Par.Constant * sqrt(PatNum) * mNSig^2;
% TempC  = Par.Constant * sqrt(PatNum);
% Par.rho = Par.rho * (mNSig+eps)^2;

while iter < Par.maxIter
    iter = iter + 1;
    
    % update X, fix Z and A
    X = diag(1 ./ (W.^2 + 0.5 * Par.rho)) * (diag(W.^2) * Y + 0.5 * Par.rho * Z - 0.5 * A);
    
    % update Z, fix X and A
    Temp = X + A/Par.rho;
    [Z] = WSNM(Temp, NSig, Par); 
    
    % update the multiplier A, fix Z and X
    A = A + Par.rho * (X - Z);
    
    Par.rho = min(1e4, Par.mu * Par.rho);
end
return;
