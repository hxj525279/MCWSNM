
clc
clear
close all
maxNumCompThreads(256);
addpath kodim

fpath = fullfile('kodim/', '*.png');
im_dir  = dir(fpath);
im_num = length(im_dir);

sigma = [40 20 30];
psnrOut_MCWSNM2324 = cell(im_num,2);

% parameters for denoising
Par.nSig =   sigma;                % STD of the noise image
Par.win  =   20;                   % Non-local patch searching window
Par.Constant  =  2 * sqrt(2);      % Constant num for the weight vector
Par.Innerloop =   2;               % InnerLoop Num of between re-blockmatching
Par.ps        =   6;               % Patch size, larger values would get better performance, but will be slower
Par.step      =   5;               % The step between neighbor patches, smaller values would get better performance, but will be slower
Par.Iter      =   3;               % total iter numbers
Par.display   = true;
Par.nlsp      =   70;              % Initial Non-local Patch number

% parameters for ADMM
Par.maxIter = 10;
Par.delta   = 0.1;                 % iterative regularization parameter
Par.mu      = 1.001;
Par.rho     = 3;                   
Par.lambda = 0.6;                  % for different noise levels, this parameter should be tuned to achieve better performance


%     Par.PSNR = zeros(Par.Iter, im_num, 'single');
%     Par.SSIM = zeros(Par.Iter, im_num, 'single');
for i = 23:24
    S = regexp(im_dir(i).name, '\.', 'split');
    fprintf(strcat('imageName: ',S{1},' \n'));
    
    Par.nSig0 = sigma;
    
    oriName = strcat('ori_',S{1});
    load(oriName, '-mat')
    ori = eval(oriName);
    Par.I = ori;
    
    noiName = strcat('noi_',S{1});
    load(noiName, '-mat')
    noi = eval(noiName);
    Par.nim = noi;
    
    PSNR_in =   csnr( Par.nim, Par.I, 0, 0 );
    %         SSIM = mySSIM( Par.nim, Par.I, 1);
    %         fprintf('PSNR_in = %2.4f, SSIM_in = %2.4f \n', PSNR,SSIM);
    fprintf('PSNR_in = %2.4f\n', PSNR_in);
    
    [im_out2324, Par] = MCWSNM_Denoising( noi, ori, Par );
    im_out2324(im_out2324>255)=255;
    im_out2324(im_out2324<0)=0;
    
    estName = strcat('est_',S{1});
    eval([estName,'= im_out2324;']);
    save(estName, estName) 
    
    PSNR =   csnr( im_out2324, Par.I, 0, 0 );
    %         Par.SSIM(Par.Iter, Par.image)  =   mySSIM( im_out2324, Par.I, 1 );
    fprintf('PSNR_out = %2.4f\n', PSNR);
    
    psnrOut_MCWSNM2324{i,1} = S{1};
    psnrOut_MCWSNM2324{i,2} = PSNR;
end
save results/psnrOut_MCWSNM2324 psnrOut_MCWSNM2324
