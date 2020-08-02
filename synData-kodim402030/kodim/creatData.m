clc
clear
close all
maxNumCompThreads(256);

fpath = fullfile('', '*.png');
im_dir  = dir(fpath);
im_num = length(im_dir);

sigma = [40 20 30];

for i = 1:im_num
    S = regexp(im_dir(i).name, '\.', 'split');
    %     fprintf(strcat('imageName: ',S{1},' \n'))
    ori = double(imread(im_dir(i).name));
    
    [m,n,p] = size(ori);
    noi = zeros(m,n,p);
    for j=1:p
%         randn('seed', 0);
        noi(:,:,j) = ori(:,:,j)+sigma(j)*randn(m,n);
    end
    noi(noi>255)=255;
    noi(noi<0)=0;
    
    % original clean image
    oriname = strcat('ori_',S{1});
    eval([oriname,'= ori;']);
    save(oriname, oriname) 
    
    noiname = strcat('noi_',S{1},'_',num2str(sigma(1)),num2str(sigma(2)),num2str(sigma(3)));
    eval([noiname,'= noi;']);
    save(noiname, noiname) 
    
end