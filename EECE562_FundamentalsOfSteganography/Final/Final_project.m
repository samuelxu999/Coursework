% First of all, add stc toolbox to search path
addpath('G:\My Drive\EECE562_Steganography\Final_stego_project\Matlab_lib\')


% =============== Step 1: Prepare stego images for each payload ===========
% Generate_stego_images(0.05);
% Generate_stego_images(0.1);
% Generate_stego_images(0.2);
% Generate_stego_images(0.3);
% Generate_stego_images(0.4);
% Generate_stego_images(0.5);

% =============== Step 2: Calculate feature for each folder  ============== 
% Generate_features_images('image_data\covers\');
% Generate_features_images('image_data\stego005\');
% Generate_features_images('image_data\stego010\');
% Generate_features_images('image_data\stego020\');
% Generate_features_images('image_data\stego030\');
% Generate_features_images('image_data\stego040\');
% Generate_features_images('image_data\stego050\');

% Read features mat
%Features_img =  load(['image_data\covers\' 'KB_features.mat'])
% Features_img =  load(['image_data\stego005\' 'KB_features.mat'])
% Features_img =  load(['image_data\stego010\' 'KB_features.mat'])
% Features_img =  load(['image_data\stego020\' 'KB_features.mat'])
% Features_img =  load(['image_data\stego030\' 'KB_features.mat'])
% Features_img =  load(['image_data\stego040\' 'KB_features.mat'])
% Features_img =  load(['image_data\stego050\' 'KB_features.mat'])


% =============== Step 3: Perform Steganalysis Test ============== 
% Steganalysis_Test()

% load result data and plot curve
load('Pe.mat', 'vec_Pe', 'alpha_vector');
plot_Pe(alpha_vector, vec_Pe);




% =========================================================================
%                          task functions 
% =========================================================================
% ------------------ plot task: Visualize P_e(a) curve -----------------
function plot_Pe(X,Y) 
    figure(1);
    % mark value of points
    strValues = strtrim(cellstr( num2str( [X(:) Y(:)], '(%.2f %.4f)') ));
    plot(X, Y, 'r-o');
    text(X, Y, strValues);
    title(sprintf('PE(a) curve'));
    xlabel('a');
    ylabel('P_E');
    axis([0.0 0.55 0.1 0.5]); 
end

% ------------------ main task: Steganalysis for each payload -----------------
function Steganalysis_Test()
    alpha_vector = [0.05 0.1 0.2 0.3 0.4 0.5];
    
    vec_Pe = [];
    for i=1:length(alpha_vector)
        fprintf("Steganalysis test: a=%.2f\n", alpha_vector(i));
        [avg_Pe, avgAD] = Steganalyze_images(alpha_vector(i));
%         avg_Pe = i/10;
        vec_Pe = [vec_Pe avg_Pe];
    end
    % save P_e result as '.mat' for plot curve.
    save('Pe.mat', 'vec_Pe', 'alpha_vector');
end



% ------------------ task 5:  steganalyze stego images using ensemble classifier-----------------
function [avg_Pe, avgAD]=Steganalyze_images(alpha)
    % number of random splits of database
    Nruns = 10;
    
    %define test error for each run
    Pe = zeros(1, Nruns);
    
    % prepare settings for ensemble classifier
    database_image = 'G:\My Drive\EECE562_Steganography\Final_stego_project\image_data';
    cover_features = [database_image '\covers\KB_features.mat'];
    
    switch alpha
        case 0.05
            stego_featres = [database_image '\stego005\KB_features.mat'];
        case 0.1
            stego_featres = [database_image '\stego010\KB_features.mat'];
        case 0.2
            stego_featres = [database_image '\stego020\KB_features.mat'];
        case 0.3
            stego_featres = [database_image '\stego030\KB_features.mat'];
        case 0.4
            stego_featres = [database_image '\stego040\KB_features.mat'];
        otherwise
            stego_featres = [database_image '\stego050\KB_features.mat'];
    end
    
    settings.cover = cover_features;
    settings.stego = stego_featres;
    
    % calculate Pe given Nruns
    for seed = 1: Nruns
        settings.seed_trntst = seed;
        results = ensemble(settings);
        Pe(seed) = results.testing_error;
    end
    
    % the result is the average error P_e and the statistical spread
    avg_Pe = mean(Pe);
    avgAD =  mean(abs(Pe- avg_Pe));
end


% ------------------ task 4:  calculate features over images of folder-----------------
function Generate_features_images(folder_path)
    % define features extraction parameters
    q = 4;
    T = 2;
    order = 4;
    
    % get all images name
    images =  filenames(folder_path, 'pgm');
    N = size(images, 2);
    
    % define features cell to save all N f column vector
    Fea = zeros(625, N);
    names = cell(N,1);

    %for each images to compute its' features
    for i=1:N
        % concatenate image file path
        image_file = sprintf('%s%s',folder_path,images(i).name);
        
        % read image file and cast to double matrix
        matrix_img = double(imread(image_file)); 
        
        % extract feature of image
        f = KB_feature(matrix_img, q, T, order);
        Fea(:,i) = f;
        names{i,1} = images(i).name;
    end
    
    % symmetrize Fea
    Fea_sym = symmetrize(Fea, T, order, 'spam', 'both');
    
    % transfer to row vector
    F = Fea_sym';
    %Fea(:,1)
    %names{:,1}
    
    % Save features to folder
    save([folder_path 'KB_features.mat'], 'F', 'names');
    
end


% ------------------ task 3:  generate stego image for alpha -----------------
function Generate_stego_images(alpha)
    % set image folder 
    folder_path = 'image_data';
    
    % set cover and stago folder
    cover_path = sprintf("%s\\covers",folder_path);
    switch alpha
        case 0.05
            stego_path = sprintf('%s\\stego005',folder_path);
        case 0.1
            stego_path = sprintf('%s\\stego010',folder_path);
        case 0.2
            stego_path = sprintf('%s\\stego020',folder_path);
        case 0.3
            stego_path = sprintf('%s\\stego030',folder_path);
        case 0.4
            stego_path = sprintf('%s\\stego040',folder_path);
        otherwise
            stego_path = sprintf('%s\\stego050',folder_path);
    end
    % get all images name
    images =  filenames(cover_path, 'pgm');
    N = size(images, 2);

    %for each cover images to compute stego images and saved in stagon
    %folder
    for i=1:N
        cover_file = sprintf('%s\\%s',cover_path, images(i).name);
        stago_file = sprintf('%s\\%s',stego_path, images(i).name);
        
        Compute_stego(cover_file, stago_file, alpha);
    end
end


% ------------------ task 2:  calculate stego image -----------------
function Compute_stego(cover_file, stago_file, alpha)
        
        % calcuate stego
        [R, p] = cost_assignment(cover_file);
        matrix_img = double(imread(cover_file)); 

        % cast stego image matrix to uint8 before save
        matrix_stego = uint8( simulate_emb(matrix_img, alpha, p));
        
        % write stego into image
        imwrite(matrix_stego, stago_file);
end


% ------------------ task 1:  Define cost ------------------------
% Calculate average distortion and cost of pixel 
function [R, p] = cost_assignment(img_file)
    matrix_img = double(imread(img_file));
    
    % get dimention of image
    [row, column] = size(matrix_img);
    
    % initialize R and p with zero matrix
    R =  zeros(size(matrix_img));
    p =  zeros(size(matrix_img));
    
    % For each pixel to calculate average distortion R and cost of pixel p, consider boundary  
    %               --- --- ---
    %              | Ul| U | Ur|
    %               --- --- ---
    %              | L | M | R |
    %               --- --- ---
    %              | Ll| L | Lr|
    %               --- --- ---
    for i=1:row
        for j=1:column
            % cornor: upper-left
            if ((i==1) && (j ==1))
                R(i,j) = ( abs(matrix_img(i,j)-matrix_img(i+1,j)) + abs(matrix_img(i,j)-matrix_img(i,j+1)) )/2;
            % cornor: upper-right
            elseif ((i==1) && (j ==column))
                R(i,j) = ( abs(matrix_img(i,j)-matrix_img(i+1,j)) + abs(matrix_img(i,j)-matrix_img(i,j-1)) )/2;
            % cornor: lower-left
            elseif ((i==row) && (j ==1))
                R(i,j) = ( abs(matrix_img(i,j)-matrix_img(i-1,j)) + abs(matrix_img(i,j)-matrix_img(i,j+1)) )/2;
            % cornor: lower-right
            elseif ((i==row) && (j ==column))
                R(i,j) = ( abs(matrix_img(i,j)-matrix_img(i-1,j)) + abs(matrix_img(i,j)-matrix_img(i,j-1)) )/2;
            % edge: upper
            elseif ((i==1) && (j>1 && j<column))
                R(i,j) = (abs(matrix_img(i,j)-matrix_img(i+1,j)) + ...
                          abs(matrix_img(i,j)-matrix_img(i,j-1)) + abs(matrix_img(i,j)-matrix_img(i,j+1)))/3;
            % edge: lower
            elseif ((i==row) && (j>1 && j<column))
                R(i,j) = (abs(matrix_img(i,j)-matrix_img(i-1,j)) + ...
                          abs(matrix_img(i,j)-matrix_img(i,j-1)) + abs(matrix_img(i,j)-matrix_img(i,j+1)))/3;
            % edge: left
            elseif ((i>1 && i<row) && (j ==1))
                R(i,j) = (abs(matrix_img(i,j)-matrix_img(i-1,j)) + abs(matrix_img(i,j)-matrix_img(i+1,j)) + ...
                          abs(matrix_img(i,j)-matrix_img(i,j+1)))/3;
            % edge: right
            elseif ((i>1 && i<row) && (j ==column))
                R(i,j) = (abs(matrix_img(i,j)-matrix_img(i-1,j)) + abs(matrix_img(i,j)-matrix_img(i+1,j)) + ...
                          abs(matrix_img(i,j)-matrix_img(i,j-1)))/3;
            % middle
            else
                R(i,j) = (abs(matrix_img(i,j)-matrix_img(i-1,j)) + abs(matrix_img(i,j)-matrix_img(i+1,j)) + ...
                          abs(matrix_img(i,j)-matrix_img(i,j-1)) + abs(matrix_img(i,j)-matrix_img(i,j+1)))/4;
            end
            p(i,j) = 1/(1+R(i,j));
        end
    end
 end
       

