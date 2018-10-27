% The assignment 2 for EECE562-Steganography
% First of all, add jpeg toolbox to search path
% addpath('G:\My Drive\EECE562_Steganography\jpegtbx_1.4_win7_64\')
% 

% ----------------------- Q2 solution test ------------------- 
% rgb_img = '6.pgm';
% 
% [I0, Beta, Alph] = cal_payload_normal(rgb_img, 0.5, 0.01);
% 
% disp([I0, Beta, Alph]);


% ----------------- Embed secret image test -------------- 
% matrix_stego = Embedding_image_in_bitplane('white_pocket.bmp', 'math_joke.bmp', 1, 7);
% imwrite(matrix_stego, 'embedded.bmp');

% ----------------- Read extract image test -------------- 
[row, column] = size(imread('math_joke.bmp'));
% matrix_msg = Read_image_in_bitplane('embedded.bmp', row, column, 1, 7);
matrix_msg = Read_image_in_bitplane_color('embedded.bmp', row, column, 1, 7);
% imwrite(matrix_msg, 'extract_msg_color.bmp');


% calculate normalized payload given PD and FA
function [I_LSBR0, Beta, Alph_opt]=cal_payload_normal(test_image, P_D, P_FA)

    %read image
    matrix_img=double(imread(test_image));
    
    % get dimention of image
    [row, column] = size(matrix_img);
    n = row*column;
    
    % preallocate zero histogram
    hist_Gray = zeros(1,256);
    
    sum_pixel = 0;
    
  % For each pixel to calculate histogram and sum pixel   
    for i=1:row
        for j=1:column
           %calculate Gray histogram
           hist_Gray(matrix_img(i,j)+1) = hist_Gray(matrix_img(i,j)+1)+1;
           sum_pixel=sum_pixel+1;
        end
    end
    
    % preallocate normalized histogram
    hist_Norm = zeros(1,256);
    % For each pixel to calculate histogram and sum pixel   
    for i=1:256
       hist_Norm(i)= hist_Gray(i)/sum_pixel;
    end
    % ------------ Plot histogram --------
%     figure, hold on;
%     
%     %plot as curve
%     curve_x = 0:(length(hist_Gray)-1);
%     plot(curve_x, hist_Norm, 'k');
%     xlim([0 256]);
    

    % calculate I_LSBR0
    I_LSBR0 = 0;
    for i=1:128
       I_LSBR0 = I_LSBR0 +(1/hist_Norm(2*i-1) + 1/hist_Norm(2*i)) * (hist_Norm(2*i-1)-hist_Norm(2*i))^2;
    end
    
    %calculate 
    Beta = (my_qfuncinv(P_FA) - my_qfuncinv(P_D))/sqrt(n * I_LSBR0);
    
    %calculate optimal a
    Alph_opt = my_Entropy(Beta);
end

% ------------------- define Entropy, Q and Qinv function -------------
function H = my_Entropy(x)
    H = -x * log2(x)-(1-x)*log2(1-x);
end

function Q = my_qfunc(x)
    Q = 0.5 * (1 - erfc(x/sqrt(2)));
end

function Q_inv = my_qfuncinv(x)
    Q_inv = sqrt(2) * erfinv(1-2*x);
end

%============================= Hide an white-black image in bitplane =======================
% Functionality: This routine could hide a secret balck and white images in the upper left 
% corner of a select bitplane of the cover image 
% Input parameters:
%   @cover_img: The cover bitmap image file path
%   @secret_img: The secret black-white bitmap image file path
%   @channel_index: Channel selection for color bitmap
%   @L_bit:  The bit index that range from 1 ~ 8 \. L=8 for LSB while L=1 for MSB
% Output parameters:
%   @Steg_img: The stegon bitmap image file path
%===========================================================================================
function Steg_img = Embedding_image_in_bitplane(cover_img, secret_img, channel_index, L_bit)
    %read cover image
    matrix_cover = imread(cover_img);
        
    % transfer pixel value from uint8 to double
    matrix_cover = double(matrix_cover);
    matrix_stego = matrix_cover;
    
    % get dimention of cover image
    [row_cover, column_cover] = size(matrix_cover);
      
    %read secretimage
    matrix_secret=imread(secret_img);
    
    % get dimention of cover image
    [row_secret, column_secret] = size(matrix_secret);

    % First of all, transfer white-black image to 0/1 matrix image.
    % 0-black, 1-white.
    bit_plane_secret = matrix_secret;
    % transfer secret image value to 0 or 1
    for i=1:row_secret
        for j=1:column_secret
          if(matrix_secret(i,j)==0)
            bit_plane_secret(i,j)=0;
          else
            bit_plane_secret(i,j)=1;
          end           
        end
    end
    
    % save bit value for each pixel
    bit_value=zeros(8);
    
    % For each pixel to embed secret bit data   
    for i=1:row_cover
      % not change unused bits
      if(i>row_secret)
          break;
      end
      for j=1:column_cover
        % not change unused bits
        if(j>column_secret)
          break;
        end
        % calculate bit value of L_bit on bitplane 
%         bit_value_cover = uint8(mod(floor(matrix_cover(i,j,channel_index))/(2^(9-L_bit-1)),2));
         
        % calculate bit1 to bit8
        pixel_value = matrix_cover(i,j,channel_index);
        for bit_index=1:8
            bit_value(bit_index)= mod(pixel_value,2);
            pixel_value = floor(pixel_value/2);             
        end
        % change bit
        if bit_value(9-L_bit)~=bit_plane_secret(i,j)
            % modify pixel value
            matrix_stego(i,j,channel_index) = bitset(matrix_cover(i,j,channel_index),9-L_bit,bit_plane_secret(i,j));
        end
      end
    end

    % convert embedding pixels to uint8 and save to stegon image matrix
    Steg_img = uint8(matrix_stego);
end

%============================= Read an white-black image from bitplane =======================
% Functionality: This routine could read a secret balck and white images embedded in the upper left 
% corner of a select bitplane of the cover image 
% Input parameters:
%   @Steg_img: The stegon bitmap image file path
%   @secret_img: The secret black-white bitmap image file path, used for
%   get dimension
%   @channel_index: Channel selection for color bitmap
%   @L_bit:  The bit index that range from 1 ~ 8 \. L=8 for LSB while L=1 for MSB
% Output parameters:
%   @Extracted_img: The stegon bitmap image file path
%===========================================================================================
function Extracted_img = Read_image_in_bitplane(steg_img, row_secret, column_secret, channel_index, L_bit)

    %read secretimage
    Extracted_img=zeros(row_secret, column_secret);
%     size(Extracted_img);

    %read stegon image
    matrix_stegon = double(imread(steg_img));
    
    % save bit value for each pixel
    bit_value=zeros(8);
    
    % For each pixel to extract secret bit data   
    for i=1:row_secret
      for j=1:column_secret
        % calculate bit1 to bit8
        pixel_value = matrix_stegon(i,j,channel_index);
        for bit_index=1:8
            bit_value(bit_index)= mod(pixel_value,2);
            pixel_value = floor(pixel_value/2);             
        end

        % set white pixel
        if bit_value(9-L_bit)==1
            Extracted_img(i,j) = 255;
        end
      end
    end
    
    % show extracted secret image
    image(Extracted_img);
end

function Extracted_img = Read_image_in_bitplane_color(steg_img, row_secret, column_secret, channel_index, L_bit)

    %read secretimage
    
%     size(Extracted_img);

    %read stegon image
    matrix_stegon = double(imread(steg_img));
    
    [row_stegon, column_stegon]= size(matrix_stegon);
    
    Extracted_img=uint8(matrix_stegon);
    
    % save bit value for each pixel
    bit_value=zeros(8);
    
    % For each pixel to extract secret bit data   
    for i=1:row_stegon
      for j=1:column_stegon
        
        if(i<= row_secret && j <= column_secret)
            Extracted_img(i,j,:) = [0,0,0];
            % calculate bit1 to bit8
            pixel_value = matrix_stegon(i,j,channel_index);
            for bit_index=1:8
                bit_value(bit_index)= mod(pixel_value,2);
                pixel_value = floor(pixel_value/2);             
            end

            % set white pixel
            if bit_value(9-L_bit)==1
                Extracted_img(i,j,channel_index) = 255;
            end
        end
      end
    end
    
    % show extracted secret image
    image(Extracted_img);
end
