% First of all, add stc toolbox to search path
% addpath('G:\My Drive\EECE562_Steganography\HW5\all_stego_images\')

% ----------------- Test  -------------- 
% tic;
SPA_Test('test.bmp');
% toc;
% fprintf(' Total execution time is %s \n', datestr(toc/(24*60*60),'HH:MM:SS:FFF'));

% ------------------ main task -----------------
function SPA_Test(test_image)

%     beta = (SP_HPairs(test_image) + SP_VPairs(test_image))/2;
%     fprintf(' For image %s, change rate is %f, estimated message length is %.4f. \n', test_image, beta,2*beta);  

    % apply SPA to test images
    listfiles = dir('all_stego_images/*.bmp');
    filenames = {listfiles.name};

    for img_index=1:length(filenames)
        img_file = strcat('all_stego_images/', filenames{img_index});
        beta_H = SP_HPairs(img_file);
        beta_V = SP_VPairs(img_file);
        beta = (beta_H + beta_V)/2;
        
        fprintf('For image %s: \n',img_file);
        fprintf(' Horizontal pairs: change rate is %f, estimated message length is %.4f. \n',beta_H,2*beta_H); 
        fprintf(' Vertical pairs: change rate is %f, estimated message length is %.4f. \n',beta_V,2*beta_V);
        fprintf(' Over all: change rate is %f, estimated message length is %.4f. \n',beta,2*beta);
    end
   
end

%------------------ caculate change rate by using samle pairs-Horizontal --------------------
function [p_beta]=SP_HPairs(test_image)
    
    %read image
    matrix_img=double(imread(test_image));
    [M, N] = size(matrix_img);
    
    % initialize parameter
    p_beta = 0;
    x = 0;
    y = 0;
    z = 0;

    % Form pixel pairs   
    P_r = reshape(matrix_img(:,1:N-1), [1, M*(N-1)]);
    P_s = reshape(matrix_img(:,2:N), [1, M*(N-1)]);

    % Calculate sample pair histogram
    for k=1:M*(N-1)
        % if (s even and r<s ) or (s odd and r>s )
        if ( mod(P_s(k),2)==0 && P_r(k)<P_s(k)) || ( mod(P_s(k),2)==1 && P_r(k)>P_s(k))
            x=x+1;
        end
        % if (s even and r>s ) or (s odd and r<s )
        if ( mod(P_s(k),2)==0 && P_r(k)>P_s(k)) || ( mod(P_s(k),2)==1 && P_r(k)<P_s(k))
            y=y+1;
        end
        % if (s even and r>s ) or (s odd and r<s )
        if ( floor(P_r(k)/2)== floor(P_s(k)/2) )
            z=z+1;
        end
    end
    
    if(z==0)
        fprintf(' SPA failed because z=%d \n', z);
        return;
    end
    
    % Compute change rate beta
    a = 2*z;
    b = 2*(2*x-M*(N-1));
    c = y-x;
    
    beta_1 = real((-b+sqrt(b*b - 4*a*c))/(2*a));
    beta_0 = real((-b-sqrt(b*b - 4*a*c))/(2*a));
    
    p_beta =max(0, min(beta_0, beta_1));

end

%------------------ caculate change rate by using samle pairs-Vertical--------------------
function [p_beta]=SP_VPairs(test_image)
    
    %read image and transpose for vertical pair
    matrix_img=double(transpose(imread(test_image)));
    [M, N] = size(matrix_img);
    
    % initialize parameter
    p_beta = 0;
    x = 0;
    y = 0;
    z = 0;

    % Form pixel pairs   
    P_r = reshape(matrix_img(:,1:N-1), [1, M*(N-1)]);
    P_s = reshape(matrix_img(:,2:N), [1, M*(N-1)]);

    % Calculate sample pair histogram
    for k=1:M*(N-1)
        % if (s even and r<s ) or (s odd and r>s )
        if ( mod(P_s(k),2)==0 && P_r(k)<P_s(k)) || ( mod(P_s(k),2)==1 && P_r(k)>P_s(k))
            x=x+1;
        end
        % if (s even and r>s ) or (s odd and r<s )
        if ( mod(P_s(k),2)==0 && P_r(k)>P_s(k)) || ( mod(P_s(k),2)==1 && P_r(k)<P_s(k))
            y=y+1;
        end
        % if (s even and r>s ) or (s odd and r<s )
        if ( floor(P_r(k)/2)== floor(P_s(k)/2) )
            z=z+1;
        end
    end
    
    if(z==0)
        fprintf(' SPA failed because z=%d \n', z);
        return;
    end
    
    % Compute change rate beta
    a = 2*z;
    b = 2*(2*x-M*(N-1));
    c = y-x;
    
    beta_1 = real((-b+sqrt(b*b - 4*a*c))/(2*a));
    beta_0 = real((-b-sqrt(b*b - 4*a*c))/(2*a));
    
    p_beta =max(0, min(beta_0, beta_1));

end

