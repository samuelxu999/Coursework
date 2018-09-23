
%Here are test code 

rgb_img = 'stego_white_pocket_test.bmp';
gray_img = 'lena_gray.bmp';
Bit_index = 8;
Bit_plane_analysis(rgb_img, Bit_index);
%Bit_plane_analysis(gray_img, Bit_index);


%============================= Display bit planes for image
%=======================
% @test_image: The test bitmap image file path
% @bit_index:  The bit index that range from 1 ~ 8 \. L=8 for LSB while L=1
% for MSB
function Bit_plane_analysis(test_image, bit_index)
    %read image
    matrix_img=imread(test_image);
    
    % get channel number
    color_channel = size(matrix_img, 3);
    
    % if RGB image, extract plane for each color from matrix_img
    if(color_channel==3)
        plane_Red = matrix_img;
        plane_Green = matrix_img;
        plane_Blue = matrix_img;
           
        %Get RGB values from matrix_img
        R = matrix_img(:,:,1);    
        G = matrix_img(:,:,2);    
        B = matrix_img(:,:,3);
        
        % get dimention of image Row * Column
        [row, column] = size(R);
        
        % preallocate zero histogram
        hist_Red = zeros(1,256);
        hist_Green = zeros(1,256);
        hist_Blue = zeros(1,256);
        
    % if Gray image, direct use matrix_img
    else
        plane_Gray = matrix_img;
        % get dimention of image
        [row, column] = size(matrix_img);
        
        % preallocate zero histogram
        hist_Gray = zeros(1,256);
    end
   
  % For each pixel to analyze bit data   
      for i=1:row
          for j=1:column
            if(color_channel==3)
                 %calculate Red plane
                 Bit_value= uint8(mod(R(i,j)/(2^(bit_index-1)),2^bit_index));
                 if(Bit_value==1)
                     plane_Red(i,j,:)=[255, 0, 0];
                 else
                     plane_Red(i,j,:)=[255, 255, 255];
                 end
                 %calculate Red histogram
                 hist_Red(R(i,j)+1)=hist_Red(R(i,j)+1)+1;

                 %calculate Green plane
                 Bit_value= uint8(mod(G(i,j)/(2^(bit_index-1)),2^bit_index));
                 if(Bit_value==1)
                     plane_Green(i,j,:)=[0, 255, 0];
                 else
                     plane_Green(i,j,:)=[255, 255, 255];
                 end
                 %calculate Green histogram
                 hist_Green(G(i,j)+1)=hist_Green(G(i,j)+1)+1;                

                 %calculate Blue plane
                 Bit_value= uint8(mod(B(i,j)/(2^(bit_index-1)),2^bit_index));
                 if(Bit_value==1)
                     plane_Blue(i,j,:)=[0, 0, 255];
                 else
                     plane_Blue(i,j,:)=[255, 255, 255];
                 end
                 %calculate Blue histogram
                 hist_Blue(B(i,j)+1)=hist_Blue(B(i,j)+1)+1;
            else
                 %calculate Gray plane
                 Bit_value= uint8(mod(matrix_img(i,j)/(2^(bit_index-1)),2^bit_index));
                 if(Bit_value==1)
                     plane_Gray(i,j)=0;
                 else
                     plane_Gray(i,j)=255;
                 end
                 %calculate Gray histogram
                 hist_Gray(matrix_img(i,j)+1)=hist_Gray(matrix_img(i,j)+1)+1;
            end
          end
      end

    %-------- Plot bit planes
    if(color_channel==3)
        figure, imshow(plane_Red);
        figure, imshow(plane_Green);
        figure, imshow(plane_Blue);
    else
        figure, imshow(plane_Gray);
    end
    
    %Plot histogram
    figure, hold on;
    if(color_channel==3)
%         % combine rgb histogram
%         hist_Combined=[hist_Red(:),hist_Green(:), hist_Blue(:)];
%         % plot as group bars
%         h_bar=bar(hist_Combined);
%         set(h_bar(1), 'FaceColor', 'r');
%         set(h_bar(2), 'FaceColor', 'g');
%         set(h_bar(3), 'FaceColor', 'b');
        
        % plot as curve
        curve_x = 0:(length(hist_Red)-1);
        plot(curve_x, hist_Red, 'r');
        plot(curve_x, hist_Green, 'g');
        plot(curve_x, hist_Blue, 'b');
        xlim([0 256]);
    else        
%         % plot as bars
%         h_bar=bar(hist_Gray);

        % plot as curve
        curve_x = 0:(length(hist_Gray)-1);
        plot(curve_x, hist_Gray, 'k');
        xlim([0 256]);
    end
end

