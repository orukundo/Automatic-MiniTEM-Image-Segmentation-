% Copyright (c) 2022 Olivier Rukundo
% Enhancing the Innovation Potential by Advancing the Know-How on Biomedical Image Analysis 
% Kuopio Biomedical Image Analysis (KUBIAC)
% A.I. Virtanen Institute for Molecular Sciences, University of Eastern of Finland, Kuopio
% E-mail: olivier.rukundo@uef.fi | orukundo@gmail.com
% Version 1.0  dated 19.06.2022

function rgb_all = PrintOutlineOfMask(input_image, mask_image)
      
       % Extract mask of adenovirus 
       output_mask_adenovirus = zeros(size(mask_image));
                for ms = 1: size(mask_image,1)
                    for mk = 1: size(mask_image,2)
                        if mask_image(ms,mk) == 255
                output_mask_adenovirus(ms,mk) = mask_image(ms,mk);
                        else
                output_mask_adenovirus(ms,mk) = 0;
                        end
                    end
                end
                output_mask_adenovirus = uint8(output_mask_adenovirus);
                % remove spurious mask pixels using median filter
        output_mask_adenovirus = medfilt2(output_mask_adenovirus,[5 5]);       
        
        % Extract mask of rod debris
        output_mask_rods = zeros(size(mask_image));
                for ms = 1: size(mask_image,1)
                    for mk = 1: size(mask_image,2)
                        if mask_image(ms,mk) == 191 % instead of 109
                output_mask_rods(ms,mk) = mask_image(ms,mk);
                        else
                output_mask_rods(ms,mk) = 0;
                        end
                    end
                end
                output_mask_rods = uint8(output_mask_rods);
                % remove spurious mask pixels using median filter
        output_mask_rods = medfilt2(output_mask_rods,[5 5]);                  
        
         % Extract mask of large debris
        output_mask_largedebris = zeros(size(mask_image));
                for ms = 1: size(mask_image,1)
                    for mk = 1: size(mask_image,2)
                        if mask_image(ms,mk) == 128 % instead of 73
                output_mask_largedebris(ms,mk) = mask_image(ms,mk);
                        else
                output_mask_largedebris(ms,mk) = 0;
                        end
                    end
                end
                output_mask_largedebris = uint8(output_mask_largedebris);
                % remove spurious mask pixels using median filter
        output_mask_largedebris = medfilt2(output_mask_largedebris,[5 5]);     
        
         % Extract mask of small debris
        output_mask_smalldebris = zeros(size(mask_image));
                for ms = 1: size(mask_image,1)
                    for mk = 1: size(mask_image,2)
                        if mask_image(ms,mk) == 64 % instead of 36
                output_mask_smalldebris(ms,mk) = mask_image(ms,mk);
                        else
                output_mask_smalldebris(ms,mk) = 0;
                        end
                    end
                end
                output_mask_smalldebris = uint8(output_mask_smalldebris);
                % remove spurious mask pixels
        output_mask_smalldebris = medfilt2(output_mask_smalldebris,[5 5]);        
        
        %% Convert a 16 bits input image to 8 bits input image 
        input_image = uint8(255*mat2gray(input_image));
        
        % Find edges of adenoviruses
        edge_adenovirus= edge(output_mask_adenovirus, 'canny');
        % enlarge the size of the adenovirus edge using a radius = 5
        r = 5;                                                            
        se = strel("disk",r);
        edge_adenovirus = imdilate(edge_adenovirus,se);          
        % Burn edge of adenovirus into the input image
        rgb_adenovirus = imoverlay(input_image, edge_adenovirus,'red');
        
        % Find edges of rod debris
        edge_rods = edge(output_mask_rods, 'canny');
        % Burn edge of rod debris into the input image + edge of adenovirus
        rgb_rods = imoverlay(rgb_adenovirus, edge_rods,'green');
        
        % Find edges of large debris
        edge_largedebris = edge(output_mask_largedebris, 'canny');
        % Burn edge of large debris into the input image + edge of
        % adenovirus + rod debris
        rgb_largedebris = imoverlay(rgb_rods, edge_largedebris,'blue');
        
        % Find edges of small debris
        edge_smalldebris = edge(output_mask_smalldebris, 'canny');
        % Burn edge of small debris into the input image + edge of
        % adenovirus + rod debris + large debris
        rgb_all = imoverlay(rgb_largedebris, edge_smalldebris,'yellow');
end

