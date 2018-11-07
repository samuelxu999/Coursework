
% ----------------- Test  -------------- 
% MainTask('flower_gray.bmp');
% MainTask('130.bmp');
MainTask('293.bmp');

% ------------------ main task -----------------
function MainTask(test_image)

    %read image
    matrix_img=double(imread(test_image));
    
    
    % ------ 1)compute cost assignment [R, p] ----------
    [R, p]=cost_assignment(matrix_img); 
    plot_cost(test_image, p);

    % ------ 2)compute R-D bound ----------
    N = 51;
    lambda = zeros(1,N);
    a_vect = zeros(1,N);
    d_vect = zeros(1,N);
    
    for i=1:N
        lambda(i) = (1.2)^(21-i);
        [a_vect(i), d_vect(i)] = RD_bound(p, lambda(i));        
    end
    disp(a_vect);
    disp(d_vect);
    plot_RD_bound(test_image, a_vect, d_vect);

    % ------ 3)compute white-black image by highlighting highest probability embedding pixel----------  
    Max_num = 50000;
    white_img = white_img_highest_cost(p, Max_num);
    plot_whiteblack(test_image, white_img, Max_num);
    
    
    subplot_all(test_image, p, a_vect, d_vect, white_img, Max_num);
    
end

% ============== subplot all image ===============
function subplot_all(test_image, cost_p, a_vect, d_vect, white_img, Max_num)
    figure(4);
    
    %read image
    matrix_img=imread(test_image);
    subplot(221);
    imshow(matrix_img);
    title_text = sprintf("The grayscale image %s.", test_image);
    title(title_text);
    
    subplot(222);
    plot(sort(cost_p(:)));
    xlabel('Pixel no.');
    ylabel('p_{ij}');
    title_text = sprintf("Profile of costs for %s.", test_image);
    title(title_text);
    
    subplot(223);
    plot(a_vect, d_vect);
    xlabel('Rate (bpp)');
    ylabel('Distortion per pixel');
    title_text = sprintf("Rate-distortion bound for %s.", test_image);
    title(title_text);
    
    subplot(224);
    imshow(white_img);
    title_text = sprintf("In white are all %d pixels with highest probability of beding modified during embedding %s.", ... 
                            Max_num, test_image);
    title(title_text);
end

% ============== plot white-black image ===============
function plot_whiteblack(test_image, white_img, Max_num)
    figure(3);
    imshow(white_img);
    title_text = sprintf("In white are all %d pixels with highest probability of beding modified during embedding %s.", ... 
                            Max_num, test_image);
    title(title_text);
end

% ============== plot R-D bound ===============
function plot_RD_bound(test_image, a_vect, d_vect)
    figure(2);
    plot(a_vect, d_vect);
    xlabel('Rate (bpp)');
    ylabel('Distortion per pixel');
    title_text = sprintf("Rate-distortion bound for %s.", test_image);
    title(title_text);
end

% ============== plot costs of image ===============
function plot_cost(test_image, cost_p)
    figure(1);
    plot(sort(cost_p(:)));
    xlabel('Pixel no.');
    ylabel('p_{ij}');
    title_text = sprintf("Profile of costs for %s.", test_image);
    title(title_text);
end

% ============== Calculate white image of 50000 highest cost of pixel ===========
function white_img = white_img_highest_cost(cost_p, higest_num)
    white_img = zeros(size(cost_p));
    % get dimention of image
    [row, column] = size(cost_p);
    
    % find the minimum value of max_num highest p
     sorted_p = sort(cost_p(:));     
     max_cost = sorted_p(higest_num);
    
    % For each pixel to calculate relative payload-a and distortion of per pixel-d, skip boundary   
    for i=2:row-1
        for j=2:column-1
            if cost_p(i,j)< max_cost
               white_img(i,j)=255; 
            end
        end
    end
end

% ============== Calculate R-D bound of pixel ===========
function [a, d] = RD_bound(cost_p, lambda)
    % get dimention of image
    [row, column] = size(cost_p);
    
    % initialize a and d with zero
    sum_a =  0.0;
    sum_d =  0.0;
    
    % For each pixel to calculate relative payload-a and distortion of per pixel-d, skip boundary   
    for i=2:row-1
        for j=2:column-1
            sum_a = sum_a + h(1/( 1+exp( (-lambda)*cost_p(i,j) ) ) );
            sum_d = sum_d + cost_p(i,j)*( exp( (-lambda)*cost_p(i,j) )/( 1+exp( (-lambda)*cost_p(i,j) ) ) );
        end
    end
    
    a = sum_a/((row-2)*(column-2));
    d = sum_d/((row-2)*(column-2));
end

% ============== Calculate average distortion and cost of pixel ===========
function [R, p] = cost_assignment(matrix_img)
    % get dimention of image
    [row, column] = size(matrix_img);
    
    % initialize R and p with zero matrix
    R =  zeros(size(matrix_img));
    p =  zeros(size(matrix_img));
    
    % For each pixel to calculate average distortion R and cost of pixel p, skip boundary   
    for i=2:row-1
        for j=2:column-1
            R(i,j) = (abs(matrix_img(i,j)-matrix_img(i-1,j)) + abs(matrix_img(i,j)-matrix_img(i+1,j)) + ...
                      abs(matrix_img(i,j)-matrix_img(i,j-1)) + abs(matrix_img(i,j)-matrix_img(i,j+1)))/4;
            p(i,j) = 1/(1+R(i,j));
        end
    end
end


% ============== binary entropy function h(x) given a vector x ============
function y = h(x)
    y = zeros(size(x));
    I = abs(x-0.5)<0.4999999;   % avoid to take log of zero
    y(I) = -x(I).*log2(x(I))-(1-x(I)).*log2(1-x(I));
end