
function  [X] =  WSNM( Y,  NSig,  Par)
%     p = Par.pAd;
p = 0.999;
[U,SigmaY,V] =   svd(full(Y),'econ');
[chtimesPatsize,PatNum ]      = size(Y);
Temp = diag(SigmaY) ;
s = diag(SigmaY);
s1 = zeros(size(s));

for i=1:4 
    W_Vec    =   (Par.Constant*sqrt(chtimesPatsize*PatNum)*mean(NSig))./(Temp.^(1/p)+ eps );
    s1       =   solve_Lp_w(s, W_Vec, p);
    Temp     =   s1;
end

%     positiveNum=find (s1 > 0);
%   ind=length(positiveNum);

SigmaX = diag(s1);
X =  U*SigmaX*V' ;
return;
