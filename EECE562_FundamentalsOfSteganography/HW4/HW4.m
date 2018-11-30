% First of all, add stc toolbox to search path
% addpath('G:\My Drive\EECE562_Steganography\HW4\stc\')

% ----------------- Test  -------------- 
tic;
STC_Task('130.bmp', 5);
toc;
fprintf(' Total execution time is %s \n', datestr(toc/(24*60*60),'HH:MM:SS:FFF'));

% ------------------ main task -----------------
function STC_Task(test_image, h)

    [R,D,lambda,rho] = DrawRDbound(test_image,'N');   % Obtain data for R-D bound and costs for cover 'image'
    figure, plot(R, D, 'k')                      % Draw R-D bound
    title(sprintf('Rate--distortion bound %s, h=%d',test_image,h)), xlabel('Rate (bpp)'), ylabel('Distortion per pixel'), 
    hold on
    
    for w=2:10
        [alpha, ave_cost] = GetEmbeddingCost(test_image, rho, h, w, 10);
    
        fprintf('  Relative payload alpha = %f  embedded with minimum average cost of %f \n', alpha, ave_cost);

        plot(alpha, ave_cost,'k*') % Draw the point in the R-D bound plot to see how far you are from the bound
                                    % Note that the point should be above the bound (the distortion will be slightly larger)
    end
   
end

function [alpha, min_cost]=GetEmbeddingCost(image, rho, h_row, w_column, Nruns)
    
    %------------------ parameter configuration --------------------
    h = h_row;       % Constraint height h (no. of rows of H_hat)
    w = w_column;       % No. of columns of H_hat
    alpha = 1/w; % Relative message length that can be embedded with codes built from H_hat

    rep = 100;   % Number of message bits that will be embedded in each pixel block
             % Each block will have rep*w pixels => we can embed rep bits.
    min_cost = 1.0; % initialize min_csot as 1
    
    %------------------ try Nruns to find minimum cost ------------------
    for i=1:Nruns
        H_hat = round(rand(h,w)); % H_hat is generated randomly
        H_hat(1,:) = 1;           % The first and last rows of H_hat should be all ones
        H_hat(end,:) = 1;


        [code,alpha] = create_code_from_submatrix(H_hat, rep);  % Create the STC

        % Test the code

        X = double(imread(image));  % Cover image
        X = X(2:end-1,2:end-1);     % rhos are available only for the inner portion of X (see DrawRDbound.m), thus we crop X
        x = mod(X(:), 2);           % LSBs of image X arranged as a 1-d vector
        message = round(rand(1,floor(alpha*numel(x)))); % A random binary message of relative length alpha

        [y, cost] = STC_Embed(message, x, rho, code);    % Embed message in x using code for costs in rho
        
        ave_cost = cost/numel(x);
        
        if ave_cost < min_cost
            min_cost = ave_cost;
        end
        
%         fprintf('  Relative payload alpha = %f  embedded with average cost of %f \n', alpha, ave_cost);
    end
    
%     plot(alpha, cost/numel(x),'k*') % Draw the point in the R-D bound plot to see how far you are from the bound
                                    % Note that the point should be above the bound (the distortion will be slightly larger)
%     extracted_message = STC_Extract(code,y);  % Extract the message from stego vector y using code

%     m = min(numel(message), numel(extracted_message));
% 
%     if sum(message(1:m) == extracted_message(1:m)) == m
%         fprintf('  Message correctly extracted.\n')
%     else
%         fprintf('  ERROR: Message not extracted correctly.\n')
%     end
end

