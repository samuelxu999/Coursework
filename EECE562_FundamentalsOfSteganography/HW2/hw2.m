% The assignment 2 for EECE562-Steganography
% First of all, add jpeg toolbox to search path
    addpath('G:\My Drive\EECE562_Steganography\jpegtbx_1.4_win7_64\')

%here are test codes

%%----------1) Using Jsteg to embed message to Jsteg image ---------------
% cover_file = 'color_image.jpg';
% stego_file = 'color_image_stego.jpg';
% message = round(rand(1,10000));
% key = 123;

% stego = Jsteg_embed(cover_file,stego_file,message,key);
% get_msg = Jsteg_read(stego_file,key);
% disp(get_msg);

%%----------2) Get evaluate relative length for Jsteg ---------------
% img_file = 'color_image_stego.jpg';
% alpha_hat = Jsteg_det(img_file);
% disp(alpha_hat);   

%%----------3) Apply steganalysis of Jsteg on sample images ---------------
listfiles = dir('test_images/*.jpg');
filenames = {listfiles.name};

for img_index=1:length(filenames)
    img_file = strcat('test_images/', filenames{img_index});
    alpha_hat = Jsteg_det(img_file);
    txt = sprintf("The %s relative message length is:%0.3f", filenames{img_index}, alpha_hat);
    disp(txt);   
end

%============================= Display bit planes for image
%=======================
% @test_image: The test bitmap image file path
% @bit_index:  The bit index that range from 1 ~ 8 \. L=8 for LSB while L=1
% for MSB
function alpha_hat = Jsteg_det(test_image)

    % read jpeg image
    im = jpeg_read(test_image);

    % Get LUV data.
    Luminance = im.coef_arrays{im.comp_info(1).component_id};
    N_Lum = numel(Luminance);
    All_coef =  Luminance(:);

%     % if the cover is a color image
%     if im.jpeg_components == 3
%         ChromCr = im.coef_arrays{im.comp_info(2).component_id};
%         ChromCb = im.coef_arrays{im.comp_info(3).component_id};
%         N_U = numel(ChromCr);
%         All_coef =  [Luminance(:); ChromCr(:); ChromCb(:)];
%     end

    % size(Luminance);
    % size(ChromCr);
    % size(ChromCb);

    % Indicates of all non-zone and non-one coeffs
    None01 = find(All_coef~=0 & All_coef~=1);
    Capacity = length(None01);
    max_coef = max(All_coef);
    min_coef = min(All_coef);
    %disp(All_coef(None01(1:300)));

    % set coef range for calculate histogram
    range_coef = min_coef : max_coef;

    hist_coef = histc(All_coef(None01),range_coef);

    % set hist(0)
    zero_index = abs(min_coef)+1;
    None0 = find(All_coef==0);
    hist_coef(zero_index) = numel(None0);

    % set hist(1)
    None1 = find(All_coef==1);
    hist_coef(zero_index+1) = numel(None1);

    % plot histogram
    %plot_histgram(hist_coef, range_coef, 0); 
    
    % -----------calculate relative evaluate message length --------
    min_range = min(max_coef, abs(min_coef));
    sum_delta_h = 0;
    for i=1:(min_range/2)-1
       % When i > 0
      P_delta_h = hist_coef(zero_index+2*i)-hist_coef(zero_index+2*i+1);
      sum_delta_h = sum_delta_h + P_delta_h ; 
       % When i < 0
      N_delta_h = hist_coef(zero_index-2*i+1) - hist_coef(zero_index-2*i);
      sum_delta_h = sum_delta_h + N_delta_h ; 
    end
    
    alpha_hat = 1 - sum_delta_h/hist_coef(zero_index + 1);
    
end

% plot histogram figure
function plot_histgram(hist_data, bin_range, plot_type)
    %Plot histogram
    figure, hold on;
    if(plot_type==0)
        % plot as bars
        h_bar=bar(bin_range,hist_data);
    else        

        % plot as curve
        curve_x = bin_range;
        plot(curve_x, hist_data, 'k');
    end
    xlim([-10 10]);
end




