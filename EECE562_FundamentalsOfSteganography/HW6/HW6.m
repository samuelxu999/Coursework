% First of all, add stc toolbox to search path
% addpath('G:\My Drive\EECE562_Steganography\HW5\all_stego_images\')

% ----------------- Assignment on FLD  -------------- 
% tic;
FLD_Test();
% toc;
% fprintf(' Total execution time is %s \n', datestr(toc/(24*60*60),'HH:MM:SS:FFF'));

% ------------------ FLD function -----------------
function FLD_Test()

    % define the test data dimension
    d = 10;
    N = 1000;
    a = [0 0.25 0.5 0.75 1 1.5];
    
    % generate random test data
    X = randn(d,N);     
    
    for i=1:length(a)
        Y = a(i) + randn(d,N);  

        % execute FLD function
        [v,Pe]=FLD(X,Y,i, a(i)); 
        fprintf("The P_E(%.2f) is %.4f. \n", a(i), Pe);
    end
%     plotFLD(X,Y);
end

% ------------------ FLD function -----------------
% Input parameter:
%    X ...a matrix of cover features as cloumns
%    Y ...a matrix of stego features as cloumns
% Output parameters:
%    v ...generalized eigenvector
%    Pe ... total minimal detection error under equal priors
function [v,Pe]=FLD(X,Y,sub_index, a)
    % calculate mean of features(row) in X
    mu_X = mean(X, 2);
    % calculate mean of features(row) in Y
    mu_Y = mean(Y, 2);

    % matrix X normalized so that each row of X has a zero mean
    Mx = normalize(X,2);
    %mu_Mx = mean(Mx, 2);
    
    % matrix Y normalized so that each row of Y has a zero mean
    My = normalize(Y,2);
    %mu_My = mean(My, 2);

    % compute scatter matrix Sx of X using covariance
    Sx = cov(X')*length(X);    
    % compute scatter matrix Sy of Y using covariance
    Sy = cov(Y')*length(Y);
    
    % with in scatter matrix Sw
    Sw = Sx + Sy;
    
    % inverse of Sw
    inv_Sw = inv(Sw);
    
    % calculate vector-w
    v = inv_Sw * (mu_X-mu_Y);
    
    % calculate projection Px
    Px = v' * X;
    % calculate projection Px
    Py = v' * Y;
    
    % adjust projections so that so that cover Px always on the left.
    if(mean(Px)>mean(Py))
        Px=-Px;
        Py=-Py;
    end 
    
    % merge Px and Py into one row vector P
    P = [Px, Py];
    
    %define a vector I of length N, the first N elements are zeros, the
    %last N are 1    
    vector_I = [zeros(1,length(X)), ones(1,length(X))]; 
    [~,rank] = sort(P);
    
    % the vector_I(rank) contain the class labels (0 or 1), used for calculate ROC 
    vector_I(rank);
    
    % Plot ROC
    vecter_P_FA = zeros(1,length(X)*2+1);
    vecter_P_D = zeros(1,length(X)*2+1);
    Pe = 1.0;
    
    % Start from P_FA(1)=P_D(1)=1
    P_FA=1;
    P_D=1;
    vecter_P_FA(1) = P_FA;
    vecter_P_D(1) = P_D;
    % for cycle to calculate ROC
    for i=1:(length(X)*2)
       % means that add a cover image left of your thresholds
      if vector_I(rank(i))==0
          %lower P_FA by 1/N
          P_FA=P_FA - 1/length(X);
      end
      if vector_I(rank(i))==1
          %lower P_D by 1/N
          P_D=P_D - 1/length(X);
      end
        % update vector
        vecter_P_FA(i+1) = P_FA;
        vecter_P_D(i+1) = P_D;
        % update Pe
        Pe =  min(Pe,( vecter_P_FA(i+1)+1-vecter_P_D(i+1))/2 );
    end
    
    Draw_ROC(vecter_P_FA,vecter_P_D,sub_index, a);
end

function Draw_ROC(vecter_P_FA,vecter_P_D, sub_index, a)
     %draw ROC
    figure(1);
    plot_pos = 230 + sub_index;
    subplot(plot_pos);
    plot(vecter_P_FA, vecter_P_D, '-k');
    title(sprintf('ROC curve a=%.2f', a));
    xlabel('P_{FA}');
    ylabel('P_D');
    axis([0 1 0 1]);   
end
