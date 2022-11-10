% Sam Coeyman
% Combining Outputs from CellProfiler and doing Processing / Plotting 

%% Housekeeping
clear all; clc; close all; 

%% NO STRETCH 
% From NS_PHAL_with_DAPI_inside 
cells_NS = xlsread('NS_PHAL_with_DAPI_inside.csv');
NS_cell_image_number = cells_NS(:,1); % Image number
NS_cell_number = cells_NS(:,2); % Cell number
NS_cell_area = cells_NS(:,9)*(1/(1.976*1.976)); % Cell area in um^2
NS_cell_orientation = cells_NS(:,13); % Cell orientation 
NS_cell_elongation = cells_NS(:,11)./cells_NS(:,12); % Cell elongation 
NS_cell_eccentricity = cells_NS(:,10); % Cell eccentricity (0 is circle and 1 is line segment) 

% From NS_RelabeledGFP 
col_4_NS = xlsread('NS_RelabeledGFP.csv');
NS_col_image_number = col_4_NS(:,1); % Image number
NS_col_number = col_4_NS(:,2); % Coll number
NS_col_intensity = col_4_NS(:,13) + col_4_NS(:,15); % Coll intensity (edge + enclosed intensity)

%% STRETCH
% From S_PHAL_with_DAPI_inside 
cells_S = xlsread('S_PHAL_with_DAPI_inside.csv');
S_cell_image_number = cells_S(:,1); % Image number
S_cell_number = cells_S(:,2); % Cell number
S_cell_area = cells_S(:,9)*(1/(1.976*1.976)); % Cell area in um^2
S_cell_orientation = cells_S(:,13); % Cell orientation 
S_cell_elongation = cells_S(:,11)./cells_S(:,12); % Cell elongation 
S_cell_eccentricity = cells_S(:,10); % Cell eccentricity (0 is circle and 1 is line segment) 

% From S_RelabeledGFP 
col_4_S = xlsread('S_RelabeledGFP.csv');
S_col_image_number = col_4_S(:,1); % Image number
S_col_number = col_4_S(:,2); % Coll number
S_col_intensity = col_4_S(:,13) + col_4_S(:,15); % Coll intensity (edge + enclosed intensity)

%% Combining NS and S Data into two Big Matricies
colNames_cell = {'Cell Image Number', 'Cell Number',  'Cell Area', 'Cell Orientation', 'Cell Elongation', 'Cell Eccentricity'};
colNames_col = {'Col IV Image Number', 'Col IV Number', 'Col IV Intensity'};
NS_cell_sample = [NS_cell_image_number NS_cell_number NS_cell_area NS_cell_orientation NS_cell_elongation NS_cell_eccentricity];
NS_col_sample = [NS_col_image_number NS_col_number NS_col_intensity];
S_cell_sample = [S_cell_image_number, S_cell_number, S_cell_area, S_cell_orientation, S_cell_elongation, S_cell_eccentricity];
S_col_sample = [S_col_image_number, S_col_number, S_col_intensity];
NS_cell = array2table(NS_cell_sample,'VariableNames',colNames_cell); 
NS_col = array2table(NS_col_sample,'VariableNames',colNames_col);
S_cell = array2table(S_cell_sample,'VariableNames',colNames_cell); 
S_col = array2table(S_col_sample,'VariableNames',colNames_col); 

%% Getting total/avg values 
% NS
A = [NS_cell(:,1),NS_cell(:,3)]; % cell area
B = groupsummary(A, 'Cell Image Number', 'sum');
NS_cell_area_total_per_image = B(:,3); % total cell area where each row is image # 

A = [NS_cell(:,1),NS_cell(:,5)]; % cell elongation
B = groupsummary(A, 'Cell Image Number', 'mean');
NS_cell_elongation_average_per_image = B(:,3); % average cell elongation where each row is image # 

A = [NS_cell(:,1),NS_cell(:,4)]; % cell orientation
B = groupsummary(A, 'Cell Image Number', 'mean');
NS_cell_orientation_average_per_image = B(:,3); % average cell orientation where each row is image #

A = [NS_cell(:,1),NS_cell(:,6)]; % cell eccentricity
B = groupsummary(A, 'Cell Image Number', 'mean');
NS_cell_eccentricity_average_per_image = B(:,3); % average cell eccentricity where each row is image # 

A2 = [NS_col(:,1),NS_col(:,3)]; % collagen intensity
B2 = groupsummary(A2, 'Col IV Image Number', 'sum');
NS_col_intensity_total_per_image = B2(:,3); % total col intensity where each row is image # 

% S
C = [S_cell(:,1),S_cell(:,3)]; % cell area
D = groupsummary(C, 'Cell Image Number', 'sum');
S_cell_area_total_per_image = D(:,3); % total cell area where each row is image # 

C = [S_cell(:,1),S_cell(:,5)]; % cell elongation
D = groupsummary(C, 'Cell Image Number', 'mean');
S_cell_elongation_average_per_image = D(:,3); % average cell elongation where each row is image # 

C = [S_cell(:,1),S_cell(:,4)]; % cell orientation
D = groupsummary(C, 'Cell Image Number', 'mean');
S_cell_orientation_average_per_image = D(:,3); % average cell orientation where each row is image #

C = [S_cell(:,1),S_cell(:,6)]; % cell eccentricity
D = groupsummary(C, 'Cell Image Number', 'mean');
S_cell_eccentricity_average_per_image = D(:,3); % average cell eccentricity where each row is image #

C2 = [S_col(:,1),S_col(:,3)]; % collagen intensity
D2 = groupsummary(C2, 'Col IV Image Number', 'sum');
S_col_intensity_total_per_image = D2(:,3); % total col intensity where each row is image # 


%% Making box and whisker plots 
% Combining data from big sheet to include each spot from staining 
% Will give all the staining data per gel from each spot (1-3 - some dont have all 3)
% TR = total rows

% Converting tables to regular matricies
B_table = table2array(B); % for NS_cell
B2_table = table2array(B2); % for NS_col
D_table = table2array(D); % for S_cell
D2_table = table2array(D2); % for S_col

%%%%%%% NS %%%%%%%
% getting total rows for cell data to sort big tables
TR_NS_cell_Aug17_1 = B_table(1,2) + B_table(2,2) + B_table(3,2); 
TR_NS_cell_Aug17_3 = B_table(4,2) + B_table(5,2) + B_table(6,2); 
TR_NS_cell_Aug17_4 = B_table(7,2); 
TR_NS_cell_Aug22_1 = B_table(8,2) + B_table(9,2) + B_table(10,2); 
TR_NS_cell_Aug22_10 = B_table(11,2) + B_table(12,2) + B_table(13,2);
TR_NS_cell_Aug22_11 = B_table(14,2) + B_table(15,2) + B_table(16,2);
TR_NS_cell_Aug22_2 = B_table(17,2) + B_table(18,2) + B_table(19,2);
TR_NS_cell_Aug22_3 = B_table(20,2) + B_table(21,2) + B_table(22,2);
TR_NS_cell_Aug22_5 = B_table(23,2) + B_table(24,2) + B_table(25,2);
TR_NS_cell_Aug22_6 = B_table(26,2) + B_table(27,2) + B_table(28,2);
TR_NS_cell_Aug22_7 = B_table(29,2) + B_table(30,2) + B_table(31,2);
TR_NS_cell_Aug22_8 = B_table(32,2) + B_table(33,2) + B_table(34,2);
TR_NS_cell_Aug22_9 = B_table(35,2) + B_table(36,2) + B_table(37,2);
TR_NS_cell_Aug28_1 = B_table(38,2) + B_table(39,2) + B_table(40,2);
TR_NS_cell_Aug28_10 = B_table(41,2) + B_table(42,2) + B_table(43,2);
TR_NS_cell_Aug28_2 = B_table(44,2) + B_table(45,2) + B_table(46,2);
TR_NS_cell_Aug28_3 = B_table(47,2) + B_table(48,2) + B_table(49,2);
TR_NS_cell_Aug28_4 = B_table(50,2) + B_table(51,2) + B_table(52,2);
TR_NS_cell_Aug28_5 = B_table(53,2) + B_table(54,2) + B_table(55,2);
TR_NS_cell_Aug28_6 = B_table(56,2) + B_table(57,2) + B_table(58,2);
TR_NS_cell_Aug28_8 = B_table(59,2) + B_table(60,2) + B_table(61,2);
TR_NS_cell_Nov3_1 = B_table(62,2) + B_table(63,2) + B_table(64,2);
TR_NS_cell_Nov3_2 = B_table(65,2) + B_table(66,2) + B_table(67,2);
TR_NS_cell_Nov3_3 = B_table(68,2) + B_table(69,2) + B_table(70,2);
TR_NS_cell_Oct13_1 = B_table(71,2) + B_table(72,2) + B_table(73,2);
TR_NS_cell_Oct13_2 = B_table(74,2) + B_table(75,2) + B_table(76,2);
TR_NS_cell_Oct13_3 = B_table(77,2) + B_table(78,2) + B_table(79,2); 
 
% getting total rows for collagen data to sort big tables
TR_NS_col_Aug17_1 = B2_table(1,2) + B2_table(2,2) + B2_table(3,2); 
TR_NS_col_Aug17_3 = B2_table(4,2) + B2_table(5,2) + B2_table(6,2); 
TR_NS_col_Aug17_4 = B2_table(7,2); 
TR_NS_col_Aug22_1 = B2_table(8,2) + B2_table(9,2) + B2_table(10,2); 
TR_NS_col_Aug22_10 = B2_table(11,2) + B2_table(12,2) + B2_table(13,2);
TR_NS_col_Aug22_11 = B2_table(14,2) + B2_table(15,2) + B2_table(16,2);
TR_NS_col_Aug22_2 = B2_table(17,2) + B2_table(18,2) + B2_table(19,2);
TR_NS_col_Aug22_3 = B2_table(20,2) + B2_table(21,2) + B2_table(22,2);
TR_NS_col_Aug22_5 = B2_table(23,2) + B2_table(24,2) + B2_table(25,2);
TR_NS_col_Aug22_6 = B2_table(26,2) + B2_table(27,2) + B2_table(28,2);
TR_NS_col_Aug22_7 = B2_table(29,2) + B2_table(30,2) + B2_table(31,2);
TR_NS_col_Aug22_8 = B2_table(32,2) + B2_table(33,2) + B2_table(34,2);
TR_NS_col_Aug22_9 = B2_table(35,2) + B2_table(36,2) + B2_table(37,2);
TR_NS_col_Aug28_1 = B2_table(38,2) + B2_table(39,2) + B2_table(40,2);
TR_NS_col_Aug28_10 = B2_table(41,2) + B2_table(42,2) + B2_table(43,2);
TR_NS_col_Aug28_2 = B2_table(44,2) + B2_table(45,2) + B2_table(46,2);
TR_NS_col_Aug28_3 = B2_table(47,2) + B2_table(48,2) + B2_table(49,2);
TR_NS_col_Aug28_4 = B2_table(50,2) + B2_table(51,2) + B2_table(52,2);
TR_NS_col_Aug28_5 = B2_table(53,2) + B2_table(54,2) + B2_table(55,2);
TR_NS_col_Aug28_6 = B2_table(56,2) + B2_table(57,2) + B2_table(58,2);
TR_NS_col_Aug28_8 = B2_table(59,2) + B2_table(60,2) + B2_table(61,2);
TR_NS_col_Nov3_1 = B2_table(62,2) + B2_table(63,2) + B2_table(64,2);
TR_NS_col_Nov3_2 = B2_table(65,2) + B2_table(66,2) + B2_table(67,2);
TR_NS_col_Nov3_3 = B2_table(68,2) + B2_table(69,2) + B2_table(70,2);
TR_NS_col_Oct13_1 = B2_table(71,2) + B2_table(72,2) + B2_table(73,2);
TR_NS_col_Oct13_2 = B2_table(74,2) + B2_table(75,2) + B2_table(76,2);
TR_NS_col_Oct13_3 = B2_table(77,2) + B2_table(78,2) + B2_table(79,2); 

%% Aug 17 %%
% 1
NS_ceA_A171 = table2array(NS_cell(1:TR_NS_cell_Aug17_1, 3)); % Cell (ce) Area 
NS_ceO_A171 = table2array(NS_cell(1:TR_NS_cell_Aug17_1, 4)); % Orientation 
NS_ceEl_A171 = table2array(NS_cell(1:TR_NS_cell_Aug17_1, 5)); % Elongation
NS_ceEc_A171 = table2array(NS_cell(1:TR_NS_cell_Aug17_1, 6)); % Eccentricity
NS_coI_A171 = table2array(NS_col(1:TR_NS_col_Aug17_1, 3)); % Collagen (co) Intensity 

% 3 
NS_ceA_A173 = table2array(NS_cell(1:TR_NS_cell_Aug17_3, 3)); % Area 
NS_ceO_A173 = table2array(NS_cell(1:TR_NS_cell_Aug17_3, 4)); % Orientation 
NS_ceEl_A173 = table2array(NS_cell(1:TR_NS_cell_Aug17_3, 5)); % Elongation
NS_ceEc_A173 = table2array(NS_cell(1:TR_NS_cell_Aug17_3, 6)); % Eccentricity
NS_coI_A173 = table2array(NS_col(1:TR_NS_col_Aug17_3, 3)); % Intensity 

% 4
NS_ceA_A174 = table2array(NS_cell(1:TR_NS_cell_Aug17_4, 3)); % Area 
NS_ceO_A174 = table2array(NS_cell(1:TR_NS_cell_Aug17_4, 4)); % Orientation 
NS_ceEl_A174 = table2array(NS_cell(1:TR_NS_cell_Aug17_4, 5)); % Elongation
NS_ceEc_A174 = table2array(NS_cell(1:TR_NS_cell_Aug17_4, 6)); % Eccentricity
NS_coI_A174 = table2array(NS_col(1:TR_NS_col_Aug17_4, 3)); % Intensity 

%% Aug 22 %%
% 1
NS_ceA_A221 = table2array(NS_cell(1:TR_NS_cell_Aug22_1, 3)); % Area 
NS_ceO_A221 = table2array(NS_cell(1:TR_NS_cell_Aug22_1, 4)); % Orientation 
NS_ceEl_A221 = table2array(NS_cell(1:TR_NS_cell_Aug22_1, 5)); % Elongation
NS_ceEc_A221 = table2array(NS_cell(1:TR_NS_cell_Aug22_1, 6)); % Eccentricity
NS_coI_A221 = table2array(NS_col(1:TR_NS_col_Aug22_1, 3)); % Intensity 

% 2 
NS_ceA_A222 = table2array(NS_cell(1:TR_NS_cell_Aug22_2, 3)); % Area 
NS_ceO_A222 = table2array(NS_cell(1:TR_NS_cell_Aug22_2, 4)); % Orientation 
NS_ceEl_A222 = table2array(NS_cell(1:TR_NS_cell_Aug22_2, 5)); % Elongation
NS_ceEc_A222 = table2array(NS_cell(1:TR_NS_cell_Aug22_2, 6)); % Eccentricity
NS_coI_A222 = table2array(NS_col(1:TR_NS_col_Aug22_2, 3)); % Intensity 

% 3
NS_ceA_A223 = table2array(NS_cell(1:TR_NS_cell_Aug22_3, 3)); % Area 
NS_ceO_A223 = table2array(NS_cell(1:TR_NS_cell_Aug22_3, 4)); % Orientation 
NS_ceEl_A223 = table2array(NS_cell(1:TR_NS_cell_Aug22_3, 5)); % Elongation
NS_ceEc_A223 = table2array(NS_cell(1:TR_NS_cell_Aug22_3, 6)); % Eccentricity
NS_coI_A223 = table2array(NS_col(1:TR_NS_col_Aug22_3, 3)); % Intensity 

% 5
NS_ceA_A225 = table2array(NS_cell(1:TR_NS_cell_Aug22_5, 3)); % Area 
NS_ceO_A225 = table2array(NS_cell(1:TR_NS_cell_Aug22_5, 4)); % Orientation 
NS_ceEl_A225 = table2array(NS_cell(1:TR_NS_cell_Aug22_5, 5)); % Elongation
NS_ceEc_A225 = table2array(NS_cell(1:TR_NS_cell_Aug22_5, 6)); % Eccentricity
NS_coI_A225 = table2array(NS_col(1:TR_NS_col_Aug22_5, 3)); % Intensity 

% 6
NS_ceA_A226 = table2array(NS_cell(1:TR_NS_cell_Aug22_6, 3)); % Area 
NS_ceO_A226 = table2array(NS_cell(1:TR_NS_cell_Aug22_6, 4)); % Orientation 
NS_ceEl_A226 = table2array(NS_cell(1:TR_NS_cell_Aug22_6, 5)); % Elongation
NS_ceEc_A226 = table2array(NS_cell(1:TR_NS_cell_Aug22_6, 6)); % Eccentricity
NS_coI_A226 = table2array(NS_col(1:TR_NS_col_Aug22_6, 3)); % Intensity 

% 7 
NS_ceA_A227 = table2array(NS_cell(1:TR_NS_cell_Aug22_7, 3)); % Area 
NS_ceO_A227 = table2array(NS_cell(1:TR_NS_cell_Aug22_7, 4)); % Orientation 
NS_ceEl_A227 = table2array(NS_cell(1:TR_NS_cell_Aug22_7, 5)); % Elongation
NS_ceEc_A227 = table2array(NS_cell(1:TR_NS_cell_Aug22_7, 6)); % Eccentricity
NS_coI_A227 = table2array(NS_col(1:TR_NS_col_Aug22_7, 3)); % Intensity 

% 8 
NS_ceA_A228 = table2array(NS_cell(1:TR_NS_cell_Aug22_8, 3)); % Area 
NS_ceO_A228 = table2array(NS_cell(1:TR_NS_cell_Aug22_8, 4)); % Orientation 
NS_ceEl_A228 = table2array(NS_cell(1:TR_NS_cell_Aug22_8, 5)); % Elongation
NS_ceEc_A228 = table2array(NS_cell(1:TR_NS_cell_Aug22_8, 6)); % Eccentricity
NS_coI_A228 = table2array(NS_col(1:TR_NS_col_Aug22_8, 3)); % Intensity 

% 9 
NS_ceA_A229 = table2array(NS_cell(1:TR_NS_cell_Aug22_9, 3)); % Area 
NS_ceO_A229 = table2array(NS_cell(1:TR_NS_cell_Aug22_9, 4)); % Orientation 
NS_ceEl_A229 = table2array(NS_cell(1:TR_NS_cell_Aug22_9, 5)); % Elongation
NS_ceEc_A229 = table2array(NS_cell(1:TR_NS_cell_Aug22_9, 6)); % Eccentricity
NS_coI_A229 = table2array(NS_col(1:TR_NS_col_Aug22_9, 3)); % Intensity 

% 10
NS_ceA_A2210 = table2array(NS_cell(1:TR_NS_cell_Aug22_10, 3)); % Area 
NS_ceO_A2210 = table2array(NS_cell(1:TR_NS_cell_Aug22_10, 4)); % Orientation 
NS_ceEl_A2210 = table2array(NS_cell(1:TR_NS_cell_Aug22_10, 5)); % Elongation
NS_ceEc_A2210 = table2array(NS_cell(1:TR_NS_cell_Aug22_10, 6)); % Eccentricity
NS_coI_A2210 = table2array(NS_col(1:TR_NS_col_Aug22_10, 3)); % Intensity 

% 11 
NS_ceA_A2211 = table2array(NS_cell(1:TR_NS_cell_Aug22_11, 3)); % Area 
NS_ceO_A2211 = table2array(NS_cell(1:TR_NS_cell_Aug22_11, 4)); % Orientation 
NS_ceEl_A2211 = table2array(NS_cell(1:TR_NS_cell_Aug22_11, 5)); % Elongation
NS_ceEc_A2211 = table2array(NS_cell(1:TR_NS_cell_Aug22_11, 6)); % Eccentricity
NS_coI_A2211 = table2array(NS_col(1:TR_NS_col_Aug22_11, 3)); % Intensity 

%% Aug 28 %%
% 1
NS_ceA_A281 = table2array(NS_cell(1:TR_NS_cell_Aug28_1, 3)); % Area 
NS_ceO_A281 = table2array(NS_cell(1:TR_NS_cell_Aug28_1, 4)); % Orientation 
NS_ceEl_A281 = table2array(NS_cell(1:TR_NS_cell_Aug28_1, 5)); % Elongation
NS_ceEc_A281 = table2array(NS_cell(1:TR_NS_cell_Aug28_1, 6)); % Eccentricity
NS_coI_A281 = table2array(NS_col(1:TR_NS_col_Aug28_1, 3)); % Intensity 

% 2
NS_ceA_A282 = table2array(NS_cell(1:TR_NS_cell_Aug28_2, 3)); % Area 
NS_ceO_A282 = table2array(NS_cell(1:TR_NS_cell_Aug28_2, 4)); % Orientation 
NS_ceEl_A282 = table2array(NS_cell(1:TR_NS_cell_Aug28_2, 5)); % Elongation
NS_ceEc_A282 = table2array(NS_cell(1:TR_NS_cell_Aug28_2, 6)); % Eccentricity
NS_coI_A282 = table2array(NS_col(1:TR_NS_col_Aug28_2, 3)); % Intensity 

% 3
NS_ceA_A283 = table2array(NS_cell(1:TR_NS_cell_Aug28_3, 3)); % Area 
NS_ceO_A283 = table2array(NS_cell(1:TR_NS_cell_Aug28_3, 4)); % Orientation 
NS_ceEl_A283 = table2array(NS_cell(1:TR_NS_cell_Aug28_3, 5)); % Elongation
NS_ceEc_A283 = table2array(NS_cell(1:TR_NS_cell_Aug28_3, 6)); % Eccentricity
NS_coI_A283 = table2array(NS_col(1:TR_NS_col_Aug28_3, 3)); % Intensity 

% 4
NS_ceA_A284 = table2array(NS_cell(1:TR_NS_cell_Aug28_4, 3)); % Area 
NS_ceO_A284 = table2array(NS_cell(1:TR_NS_cell_Aug28_4, 4)); % Orientation 
NS_ceEl_A284 = table2array(NS_cell(1:TR_NS_cell_Aug28_4, 5)); % Elongation
NS_ceEc_A284 = table2array(NS_cell(1:TR_NS_cell_Aug28_4, 6)); % Eccentricity
NS_coI_A284 = table2array(NS_col(1:TR_NS_col_Aug28_4, 3)); % Intensity 

% 5
NS_ceA_A285 = table2array(NS_cell(1:TR_NS_cell_Aug28_5, 3)); % Area 
NS_ceO_A285 = table2array(NS_cell(1:TR_NS_cell_Aug28_5, 4)); % Orientation 
NS_ceEl_A285 = table2array(NS_cell(1:TR_NS_cell_Aug28_5, 5)); % Elongation
NS_ceEc_A285 = table2array(NS_cell(1:TR_NS_cell_Aug28_5, 6)); % Eccentricity
NS_coI_A285 = table2array(NS_col(1:TR_NS_col_Aug28_5, 3)); % Intensity 

% 6
NS_ceA_A286 = table2array(NS_cell(1:TR_NS_cell_Aug28_6, 3)); % Area 
NS_ceO_A286 = table2array(NS_cell(1:TR_NS_cell_Aug28_6, 4)); % Orientation 
NS_ceEl_A286 = table2array(NS_cell(1:TR_NS_cell_Aug28_6, 5)); % Elongation
NS_ceEc_A286 = table2array(NS_cell(1:TR_NS_cell_Aug28_6, 6)); % Eccentricity
NS_coI_A286 = table2array(NS_col(1:TR_NS_col_Aug28_6, 3)); % Intensity 

% 8
NS_ceA_A288 = table2array(NS_cell(1:TR_NS_cell_Aug28_8, 3)); % Area 
NS_ceO_A288 = table2array(NS_cell(1:TR_NS_cell_Aug28_8, 4)); % Orientation 
NS_ceEl_A288 = table2array(NS_cell(1:TR_NS_cell_Aug28_8, 5)); % Elongation
NS_ceEc_A288 = table2array(NS_cell(1:TR_NS_cell_Aug28_8, 6)); % Eccentricity
NS_coI_A288 = table2array(NS_col(1:TR_NS_col_Aug28_8, 3)); % Intensity 

% 10
NS_ceA_A2810 = table2array(NS_cell(1:TR_NS_cell_Aug28_10, 3)); % Area 
NS_ceO_A2810 = table2array(NS_cell(1:TR_NS_cell_Aug28_10, 4)); % Orientation 
NS_ceEl_A2810 = table2array(NS_cell(1:TR_NS_cell_Aug28_10, 5)); % Elongation
NS_ceEc_A2810 = table2array(NS_cell(1:TR_NS_cell_Aug28_10, 6)); % Eccentricity
NS_coI_A2810 = table2array(NS_col(1:TR_NS_col_Aug28_10, 3)); % Intensity 

%% Oct 13 %%
% 1
NS_ceA_O131 = table2array(NS_cell(1:TR_NS_cell_Oct13_1, 3)); % Area 
NS_ceO_O131 = table2array(NS_cell(1:TR_NS_cell_Oct13_1, 4)); % Orientation 
NS_ceEl_O131 = table2array(NS_cell(1:TR_NS_cell_Oct13_1, 5)); % Elongation
NS_ceEc_O131 = table2array(NS_cell(1:TR_NS_cell_Oct13_1, 6)); % Eccentricity
NS_coI_O131 = table2array(NS_col(1:TR_NS_col_Oct13_1, 3)); % Intensity 

% 2
NS_ceA_O132 = table2array(NS_cell(1:TR_NS_cell_Oct13_2, 3)); % Area 
NS_ceO_O132 = table2array(NS_cell(1:TR_NS_cell_Oct13_2, 4)); % Orientation 
NS_ceEl_O132 = table2array(NS_cell(1:TR_NS_cell_Oct13_2, 5)); % Elongation
NS_ceEc_O132 = table2array(NS_cell(1:TR_NS_cell_Oct13_2, 6)); % Eccentricity
NS_coI_O132 = table2array(NS_col(1:TR_NS_col_Oct13_2, 3)); % Intensity 

% 3
NS_ceA_O133 = table2array(NS_cell(1:TR_NS_cell_Oct13_3, 3)); % Area 
NS_ceO_O133 = table2array(NS_cell(1:TR_NS_cell_Oct13_3, 4)); % Orientation 
NS_ceEl_O133 = table2array(NS_cell(1:TR_NS_cell_Oct13_3, 5)); % Elongation
NS_ceEc_O133 = table2array(NS_cell(1:TR_NS_cell_Oct13_3, 6)); % Eccentricity
NS_coI_O133 = table2array(NS_col(1:TR_NS_col_Oct13_3, 3)); % Intensity 

%% Nov 3 %%
% 1
NS_ceA_N031 = table2array(NS_cell(1:TR_NS_cell_Nov3_1, 3)); % Area 
NS_ceO_N031 = table2array(NS_cell(1:TR_NS_cell_Nov3_1, 4)); % Orientation 
NS_ceEl_N031 = table2array(NS_cell(1:TR_NS_cell_Nov3_1, 5)); % Elongation
NS_ceEc_N031 = table2array(NS_cell(1:TR_NS_cell_Nov3_1, 6)); % Eccentricity
NS_coI_N031 = table2array(NS_col(1:TR_NS_col_Nov3_1, 3)); % Intensity 

% 2 
NS_ceA_N032 = table2array(NS_cell(1:TR_NS_cell_Nov3_2, 3)); % Area 
NS_ceO_N032 = table2array(NS_cell(1:TR_NS_cell_Nov3_2, 4)); % Orientation 
NS_ceEl_N032 = table2array(NS_cell(1:TR_NS_cell_Nov3_2, 5)); % Elongation
NS_ceEc_N032 = table2array(NS_cell(1:TR_NS_cell_Nov3_2, 6)); % Eccentricity
NS_coI_N032 = table2array(NS_col(1:TR_NS_col_Nov3_2, 3)); % Intensity 

% 3
NS_ceA_N033 = table2array(NS_cell(1:TR_NS_cell_Nov3_3, 3)); % Area 
NS_ceO_N033 = table2array(NS_cell(1:TR_NS_cell_Nov3_3, 4)); % Orientation 
NS_ceEl_N033 = table2array(NS_cell(1:TR_NS_cell_Nov3_3, 5)); % Elongation
NS_ceEc_N033 = table2array(NS_cell(1:TR_NS_cell_Nov3_3, 6)); % Eccentricity
NS_coI_N033 = table2array(NS_col(1:TR_NS_col_Nov3_3, 3)); % Intensity 

%%%%%%% S %%%%%%% 
% getting total rows for cell data to sort big tables
TR_S_cell_Aug17_1 = D_table(1,2) + D_table(2,2) + D_table(3,2); 
TR_S_cell_Aug17_3 = D_table(4,2) + D_table(5,2) + D_table(6,2); 
TR_S_cell_Aug17_4 = D_table(7,2) + D_table(8,2) + D_table(9,2);  
TR_S_cell_Aug17_5 = D_table(10,2); 
TR_S_cell_Aug22_1 = D_table(11,2) + D_table(12,2) + D_table(13,2);
TR_S_cell_Aug22_2 = D_table(14,2) + D_table(15,2) + D_table(16,2);
TR_S_cell_Aug22_3 = D_table(17,2) + D_table(18,2) + D_table(19,2);
TR_S_cell_Aug22_6 = D_table(20,2) + D_table(21,2) + D_table(22,2);
TR_S_cell_Aug22_7 = D_table(23,2) + D_table(24,2) + D_table(25,2);
TR_S_cell_Aug22_8 = D_table(26,2) + D_table(27,2) + D_table(28,2);
TR_S_cell_Aug22_9 = D_table(29,2) + D_table(30,2) + D_table(31,2);
TR_S_cell_Aug22_10 = D_table(32,2) + D_table(33,2) + D_table(34,2);
TR_S_cell_Aug22_11 = D_table(35,2) + D_table(36,2) + D_table(37,2); 
TR_S_cell_Aug28_1 = D_table(38,2) + D_table(39,2) + D_table(40,2);
TR_S_cell_Aug28_2 = D_table(41,2) + D_table(42,2) + D_table(43,2);
TR_S_cell_Aug28_3 = D_table(44,2) + D_table(45,2) + D_table(46,2);
TR_S_cell_Aug28_4 = D_table(47,2) + D_table(48,2) + D_table(49,2);
TR_S_cell_Aug28_5 = D_table(50,2) + D_table(51,2) + D_table(52,2);
TR_S_cell_Aug28_6 = D_table(53,2) + D_table(54,2) + D_table(55,2);
TR_S_cell_Aug28_7 = D_table(56,2) + D_table(57,2) + D_table(58,2);
TR_S_cell_Aug28_8 = D_table(59,2) + D_table(60,2) + D_table(61,2);
TR_S_cell_Aug28_9 = D_table(62,2) + D_table(63,2) + D_table(64,2);
TR_S_cell_Aug28_10 = D_table(65,2) + D_table(66,2) + D_table(67,2);
TR_S_cell_Aug28_11 = D_table(68,2) + D_table(69,2) + D_table(70,2);
TR_S_cell_Aug28_12 = D_table(71,2) + D_table(72,2) + D_table(73,2);
TR_S_cell_Nov3_1 = D_table(74,2) + D_table(75,2) + D_table(76,2);
TR_S_cell_Nov3_2 = D_table(77,2) + D_table(78,2) + D_table(79,2); 
TR_S_cell_Nov3_3 = D_table(80,2) + D_table(81,2) + D_table(82,2); 
TR_S_cell_Oct13_1 = D_table(83,2) + D_table(84,2) + D_table(85,2); 
TR_S_cell_Oct13_2 = D_table(86,2) + D_table(87,2) + D_table(88,2);  
TR_S_cell_Oct13_3 = D_table(89,2) + D_table(90,2) + D_table(91,2);  
 
% getting total rows for collagen data to sort big tables
TR_S_col_Aug17_1 = D2_table(1,2) + D2_table(2,2) + D2_table(3,2); 
TR_S_col_Aug17_3 = D2_table(4,2) + D2_table(5,2) + D2_table(6,2); 
TR_S_col_Aug17_4 = D2_table(7,2) + D2_table(8,2) + D2_table(9,2);  
TR_S_col_Aug17_5 = D2_table(10,2); 
TR_S_col_Aug22_1 = D2_table(11,2) + D2_table(12,2) + D2_table(13,2);
TR_S_col_Aug22_2 = D2_table(14,2) + D2_table(15,2) + D2_table(16,2);
TR_S_col_Aug22_3 = D2_table(17,2) + D2_table(18,2) + D2_table(19,2);
TR_S_col_Aug22_6 = D2_table(20,2) + D2_table(21,2) + D2_table(22,2);
TR_S_col_Aug22_7 = D2_table(23,2) + D2_table(24,2) + D2_table(25,2);
TR_S_col_Aug22_8 = D2_table(26,2) + D2_table(27,2) + D2_table(28,2);
TR_S_col_Aug22_9 = D2_table(29,2) + D2_table(30,2) + D2_table(31,2);
TR_S_col_Aug22_10 = D2_table(32,2) + D2_table(33,2) + D2_table(34,2);
TR_S_col_Aug22_11 = D2_table(35,2) + D2_table(36,2) + D2_table(37,2); 
TR_S_col_Aug28_1 = D2_table(38,2) + D2_table(39,2) + D2_table(40,2);
TR_S_col_Aug28_2 = D2_table(41,2) + D2_table(42,2) + D2_table(43,2);
TR_S_col_Aug28_3 = D2_table(44,2) + D2_table(45,2) + D2_table(46,2);
TR_S_col_Aug28_4 = D2_table(47,2) + D2_table(48,2) + D2_table(49,2);
TR_S_col_Aug28_5 = D2_table(50,2) + D2_table(51,2) + D2_table(52,2);
TR_S_col_Aug28_6 = D2_table(53,2) + D2_table(54,2) + D2_table(55,2);
TR_S_col_Aug28_7 = D2_table(56,2) + D2_table(57,2) + D2_table(58,2);
TR_S_col_Aug28_8 = D2_table(59,2) + D2_table(60,2) + D2_table(61,2);
TR_S_col_Aug28_9 = D2_table(62,2) + D2_table(63,2) + D2_table(64,2);
TR_S_col_Aug28_10 = D2_table(65,2) + D2_table(66,2) + D2_table(67,2);
TR_S_col_Aug28_11 = D2_table(68,2) + D2_table(69,2) + D2_table(70,2);
TR_S_col_Aug28_12 = D2_table(71,2) + D2_table(72,2) + D2_table(73,2);
TR_S_col_Nov3_1 = D2_table(74,2) + D2_table(75,2) + D2_table(76,2);
TR_S_col_Nov3_2 = D2_table(77,2) + D2_table(78,2) + D2_table(79,2); 
TR_S_col_Nov3_3 = D2_table(80,2) + D2_table(81,2) + D2_table(82,2); 
TR_S_col_Oct13_1 = D2_table(83,2) + D2_table(84,2) + D2_table(85,2); 
TR_S_col_Oct13_2 = D2_table(86,2) + D2_table(87,2) + D2_table(88,2);  
TR_S_col_Oct13_3 = D2_table(89,2) + D2_table(90,2) + D2_table(91,2);  

%% Aug 17 %%
% 1
S_ceA_A171 = table2array(S_cell(1:TR_S_cell_Aug17_1, 3)); % Area 
S_ceO_A171 = table2array(S_cell(1:TR_S_cell_Aug17_1, 4)); % Orientation 
S_ceEl_A171 = table2array(S_cell(1:TR_S_cell_Aug17_1, 5)); % Elongation
S_ceEc_A171 = table2array(S_cell(1:TR_S_cell_Aug17_1, 6)); % Eccentricity
S_coI_A171 = table2array(S_col(1:TR_S_col_Aug17_1, 3)); % Intensity 

% 3
S_ceA_A173 = table2array(S_cell(1:TR_S_cell_Aug17_3, 3)); % Area 
S_ceO_A173 = table2array(S_cell(1:TR_S_cell_Aug17_3, 4)); % Orientation 
S_ceEl_A173 = table2array(S_cell(1:TR_S_cell_Aug17_3, 5)); % Elongation
S_ceEc_A173 = table2array(S_cell(1:TR_S_cell_Aug17_3, 6)); % Eccentricity
S_coI_A173 = table2array(S_col(1:TR_S_col_Aug17_3, 3)); % Intensity 

% 4
S_ceA_A174 = table2array(S_cell(1:TR_S_cell_Aug17_4, 3)); % Area 
S_ceO_A174 = table2array(S_cell(1:TR_S_cell_Aug17_4, 4)); % Orientation 
S_ceEl_A174 = table2array(S_cell(1:TR_S_cell_Aug17_4, 5)); % Elongation
S_ceEc_A174 = table2array(S_cell(1:TR_S_cell_Aug17_4, 6)); % Eccentricity
S_coI_A174 = table2array(S_col(1:TR_S_col_Aug17_4, 3)); % Intensity 

% 5
S_ceA_A175 = table2array(S_cell(1:TR_S_cell_Aug17_5, 3)); % Area 
S_ceO_A175 = table2array(S_cell(1:TR_S_cell_Aug17_5, 4)); % Orientation 
S_ceEl_A175 = table2array(S_cell(1:TR_S_cell_Aug17_5, 5)); % Elongation
S_ceEc_A175 = table2array(S_cell(1:TR_S_cell_Aug17_5, 6)); % Eccentricity
S_coI_A175 = table2array(S_col(1:TR_S_col_Aug17_5, 3)); % Intensity 

%% Aug 22 %%
% 1
S_ceA_A221 = table2array(S_cell(1:TR_S_cell_Aug22_1, 3)); % Area 
S_ceO_A221 = table2array(S_cell(1:TR_S_cell_Aug22_1, 4)); % Orientation 
S_ceEl_A221 = table2array(S_cell(1:TR_S_cell_Aug22_1, 5)); % Elongation
S_ceEc_A221 = table2array(S_cell(1:TR_S_cell_Aug22_1, 6)); % Eccentricity
S_coI_A221 = table2array(S_col(1:TR_S_col_Aug22_1, 3)); % Intensity 

% 2 
S_ceA_A222 = table2array(S_cell(1:TR_S_cell_Aug22_2, 3)); % Area 
S_ceO_A222 = table2array(S_cell(1:TR_S_cell_Aug22_2, 4)); % Orientation 
S_ceEl_A222 = table2array(S_cell(1:TR_S_cell_Aug22_2, 5)); % Elongation
S_ceEc_A222 = table2array(S_cell(1:TR_S_cell_Aug22_2, 6)); % Eccentricity
S_coI_A222 = table2array(S_col(1:TR_S_col_Aug22_2, 3)); % Intensity 

% 3
S_ceA_A223 = table2array(S_cell(1:TR_S_cell_Aug22_3, 3)); % Area 
S_ceO_A223 = table2array(S_cell(1:TR_S_cell_Aug22_3, 4)); % Orientation 
S_ceEl_A223 = table2array(S_cell(1:TR_S_cell_Aug22_3, 5)); % Elongation
S_ceEc_A223 = table2array(S_cell(1:TR_S_cell_Aug22_3, 6)); % Eccentricity
S_coI_A223 = table2array(S_col(1:TR_S_col_Aug22_3, 3)); % Intensity 

% 6
S_ceA_A226 = table2array(S_cell(1:TR_S_cell_Aug22_6, 3)); % Area 
S_ceO_A226 = table2array(S_cell(1:TR_S_cell_Aug22_6, 4)); % Orientation 
S_ceEl_A226 = table2array(S_cell(1:TR_S_cell_Aug22_6, 5)); % Elongation
S_ceEc_A226 = table2array(S_cell(1:TR_S_cell_Aug22_6, 6)); % Eccentricity
S_coI_A226 = table2array(S_col(1:TR_S_col_Aug22_6, 3)); % Intensity 

% 7
S_ceA_A227 = table2array(S_cell(1:TR_S_cell_Aug22_7, 3)); % Area 
S_ceO_A227 = table2array(S_cell(1:TR_S_cell_Aug22_7, 4)); % Orientation 
S_ceEl_A227 = table2array(S_cell(1:TR_S_cell_Aug22_7, 5)); % Elongation
S_ceEc_A227 = table2array(S_cell(1:TR_S_cell_Aug22_7, 6)); % Eccentricity
S_coI_A227 = table2array(S_col(1:TR_S_col_Aug22_7, 3)); % Intensity 

% 8
S_ceA_A228 = table2array(S_cell(1:TR_S_cell_Aug22_8, 3)); % Area 
S_ceO_A228 = table2array(S_cell(1:TR_S_cell_Aug22_8, 4)); % Orientation 
S_ceEl_A228 = table2array(S_cell(1:TR_S_cell_Aug22_8, 5)); % Elongation
S_ceEc_A228 = table2array(S_cell(1:TR_S_cell_Aug22_8, 6)); % Eccentricity
S_coI_A228 = table2array(S_col(1:TR_S_col_Aug22_8, 3)); % Intensity 

% 9
S_ceA_A229 = table2array(S_cell(1:TR_S_cell_Aug22_9, 3)); % Area 
S_ceO_A229 = table2array(S_cell(1:TR_S_cell_Aug22_9, 4)); % Orientation 
S_ceEl_A229 = table2array(S_cell(1:TR_S_cell_Aug22_9, 5)); % Elongation
S_ceEc_A229 = table2array(S_cell(1:TR_S_cell_Aug22_9, 6)); % Eccentricity
S_coI_A229 = table2array(S_col(1:TR_S_col_Aug22_9, 3)); % Intensity 

% 10
S_ceA_A2210 = table2array(S_cell(1:TR_S_cell_Aug22_10, 3)); % Area 
S_ceO_A2210 = table2array(S_cell(1:TR_S_cell_Aug22_10, 4)); % Orientation 
S_ceEl_A2210 = table2array(S_cell(1:TR_S_cell_Aug22_10, 5)); % Elongation
S_ceEc_A2210 = table2array(S_cell(1:TR_S_cell_Aug22_10, 6)); % Eccentricity
S_coI_A2210 = table2array(S_col(1:TR_S_col_Aug22_10, 3)); % Intensity 

% 11
S_ceA_A2211 = table2array(S_cell(1:TR_S_cell_Aug22_11, 3)); % Area 
S_ceO_A2211 = table2array(S_cell(1:TR_S_cell_Aug22_11, 4)); % Orientation 
S_ceEl_A2211 = table2array(S_cell(1:TR_S_cell_Aug22_11, 5)); % Elongation
S_ceEc_A2211 = table2array(S_cell(1:TR_S_cell_Aug22_11, 6)); % Eccentricity
S_coI_A2211 = table2array(S_col(1:TR_S_col_Aug22_11, 3)); % Intensity 

%% Aug 28 %%
% 1
S_ceA_A281 = table2array(S_cell(1:TR_S_cell_Aug28_1, 3)); % Area 
S_ceO_A281 = table2array(S_cell(1:TR_S_cell_Aug28_1, 4)); % Orientation 
S_ceEl_A281 = table2array(S_cell(1:TR_S_cell_Aug28_1, 5)); % Elongation
S_ceEc_A281 = table2array(S_cell(1:TR_S_cell_Aug28_1, 6)); % Eccentricity
S_coI_A281 = table2array(S_col(1:TR_S_col_Aug28_1, 3)); % Intensity 

% 2
S_ceA_A282 = table2array(S_cell(1:TR_S_cell_Aug28_2, 3)); % Area 
S_ceO_A282 = table2array(S_cell(1:TR_S_cell_Aug28_2, 4)); % Orientation 
S_ceEl_A282 = table2array(S_cell(1:TR_S_cell_Aug28_2, 5)); % Elongation
S_ceEc_A282 = table2array(S_cell(1:TR_S_cell_Aug28_2, 6)); % Eccentricity
S_coI_A282 = table2array(S_col(1:TR_S_col_Aug28_2, 3)); % Intensity 

% 3
S_ceA_A283 = table2array(S_cell(1:TR_S_cell_Aug28_3, 3)); % Area 
S_ceO_A283 = table2array(S_cell(1:TR_S_cell_Aug28_3, 4)); % Orientation 
S_ceEl_A283 = table2array(S_cell(1:TR_S_cell_Aug28_3, 5)); % Elongation
S_ceEc_A283 = table2array(S_cell(1:TR_S_cell_Aug28_3, 6)); % Eccentricity
S_coI_A283 = table2array(S_col(1:TR_S_col_Aug28_3, 3)); % Intensity 

% 4
S_ceA_A284 = table2array(S_cell(1:TR_S_cell_Aug28_4, 3)); % Area 
S_ceO_A284 = table2array(S_cell(1:TR_S_cell_Aug28_4, 4)); % Orientation 
S_ceEl_A284 = table2array(S_cell(1:TR_S_cell_Aug28_4, 5)); % Elongation
S_ceEc_A284 = table2array(S_cell(1:TR_S_cell_Aug28_4, 6)); % Eccentricity
S_coI_A284 = table2array(S_col(1:TR_S_col_Aug28_4, 3)); % Intensity 

% 5
S_ceA_A285 = table2array(S_cell(1:TR_S_cell_Aug28_5, 3)); % Area 
S_ceO_A285 = table2array(S_cell(1:TR_S_cell_Aug28_5, 4)); % Orientation 
S_ceEl_A285 = table2array(S_cell(1:TR_S_cell_Aug28_5, 5)); % Elongation
S_ceEc_A285 = table2array(S_cell(1:TR_S_cell_Aug28_5, 6)); % Eccentricity
S_coI_A285 = table2array(S_col(1:TR_S_col_Aug28_5, 3)); % Intensity 

% 6
S_ceA_A286 = table2array(S_cell(1:TR_S_cell_Aug28_6, 3)); % Area 
S_ceO_A286 = table2array(S_cell(1:TR_S_cell_Aug28_6, 4)); % Orientation 
S_ceEl_A286 = table2array(S_cell(1:TR_S_cell_Aug28_6, 5)); % Elongation
S_ceEc_A286 = table2array(S_cell(1:TR_S_cell_Aug28_6, 6)); % Eccentricity
S_coI_A286 = table2array(S_col(1:TR_S_col_Aug28_6, 3)); % Intensity 

% 7
S_ceA_A287 = table2array(S_cell(1:TR_S_cell_Aug28_7, 3)); % Area 
S_ceO_A287 = table2array(S_cell(1:TR_S_cell_Aug28_7, 4)); % Orientation 
S_ceEl_A287 = table2array(S_cell(1:TR_S_cell_Aug28_7, 5)); % Elongation
S_ceEc_A287 = table2array(S_cell(1:TR_S_cell_Aug28_7, 6)); % Eccentricity
S_coI_A287 = table2array(S_col(1:TR_S_col_Aug28_7, 3)); % Intensity 

% 8
S_ceA_A288 = table2array(S_cell(1:TR_S_cell_Aug28_8, 3)); % Area 
S_ceO_A288 = table2array(S_cell(1:TR_S_cell_Aug28_8, 4)); % Orientation 
S_ceEl_A288 = table2array(S_cell(1:TR_S_cell_Aug28_8, 5)); % Elongation
S_ceEc_A288 = table2array(S_cell(1:TR_S_cell_Aug28_8, 6)); % Eccentricity
S_coI_A288 = table2array(S_col(1:TR_S_col_Aug28_8, 3)); % Intensity 

% 9
S_ceA_A289 = table2array(S_cell(1:TR_S_cell_Aug28_9, 3)); % Area 
S_ceO_A289 = table2array(S_cell(1:TR_S_cell_Aug28_9, 4)); % Orientation 
S_ceEl_A289 = table2array(S_cell(1:TR_S_cell_Aug28_9, 5)); % Elongation
S_ceEc_A289 = table2array(S_cell(1:TR_S_cell_Aug28_9, 6)); % Eccentricity
S_coI_A289 = table2array(S_col(1:TR_S_col_Aug28_9, 3)); % Intensity 

% 10
S_ceA_A2810 = table2array(S_cell(1:TR_S_cell_Aug28_10, 3)); % Area 
S_ceO_A2810 = table2array(S_cell(1:TR_S_cell_Aug28_10, 4)); % Orientation 
S_ceEl_A2810 = table2array(S_cell(1:TR_S_cell_Aug28_10, 5)); % Elongation
S_ceEc_A2810 = table2array(S_cell(1:TR_S_cell_Aug28_10, 6)); % Eccentricity
S_coI_A2810 = table2array(S_col(1:TR_S_col_Aug28_10, 3)); % Intensity 

% 11
S_ceA_A2811 = table2array(S_cell(1:TR_S_cell_Aug28_11, 3)); % Area 
S_ceO_A2811 = table2array(S_cell(1:TR_S_cell_Aug28_11, 4)); % Orientation 
S_ceEl_A2811 = table2array(S_cell(1:TR_S_cell_Aug28_11, 5)); % Elongation
S_ceEc_A2811 = table2array(S_cell(1:TR_S_cell_Aug28_11, 6)); % Eccentricity
S_coI_A2811 = table2array(S_col(1:TR_S_col_Aug28_11, 3)); % Intensity 

% 12
S_ceA_A2812 = table2array(S_cell(1:TR_S_cell_Aug28_12, 3)); % Area 
S_ceO_A2812 = table2array(S_cell(1:TR_S_cell_Aug28_12, 4)); % Orientation 
S_ceEl_A2812 = table2array(S_cell(1:TR_S_cell_Aug28_12, 5)); % Elongation
S_ceEc_A2812 = table2array(S_cell(1:TR_S_cell_Aug28_12, 6)); % Eccentricity
S_coI_A2812 = table2array(S_col(1:TR_S_col_Aug28_12, 3)); % Intensity 

%% Oct 13 %%
% 1
S_ceA_O131 = table2array(S_cell(1:TR_S_cell_Oct13_1, 3)); % Area 
S_ceO_O131 = table2array(S_cell(1:TR_S_cell_Oct13_1, 4)); % Orientation 
S_ceEl_O131 = table2array(S_cell(1:TR_S_cell_Oct13_1, 5)); % Elongation
S_ceEc_O131 = table2array(S_cell(1:TR_S_cell_Oct13_1, 6)); % Eccentricity
S_coI_O131 = table2array(S_col(1:TR_S_col_Oct13_1, 3)); % Intensity 

% 2
S_ceA_O132 = table2array(S_cell(1:TR_S_cell_Oct13_2, 3)); % Area 
S_ceO_O132 = table2array(S_cell(1:TR_S_cell_Oct13_2, 4)); % Orientation 
S_ceEl_O132 = table2array(S_cell(1:TR_S_cell_Oct13_2, 5)); % Elongation
S_ceEc_O132 = table2array(S_cell(1:TR_S_cell_Oct13_2, 6)); % Eccentricity
S_coI_O132 = table2array(S_col(1:TR_S_col_Oct13_2, 3)); % Intensity 

% 3
S_ceA_O133 = table2array(S_cell(1:TR_S_cell_Oct13_3, 3)); % Area 
S_ceO_O133 = table2array(S_cell(1:TR_S_cell_Oct13_3, 4)); % Orientation 
S_ceEl_O133 = table2array(S_cell(1:TR_S_cell_Oct13_3, 5)); % Elongation
S_ceEc_O133 = table2array(S_cell(1:TR_S_cell_Oct13_3, 6)); % Eccentricity
S_coI_O133 = table2array(S_col(1:TR_S_col_Oct13_3, 3)); % Intensity 

%% Nov 3 %%
% 1
S_ceA_N031 = table2array(S_cell(1:TR_S_cell_Nov3_1, 3)); % Area 
S_ceO_N031 = table2array(S_cell(1:TR_S_cell_Nov3_1, 4)); % Orientation 
S_ceEl_N031 = table2array(S_cell(1:TR_S_cell_Nov3_1, 5)); % Elongation
S_ceEc_N031 = table2array(S_cell(1:TR_S_cell_Nov3_1, 6)); % Eccentricity
S_coI_N031 = table2array(S_col(1:TR_S_col_Nov3_1, 3)); % Intensity 

% 2
S_ceA_N032 = table2array(S_cell(1:TR_S_cell_Nov3_2, 3)); % Area 
S_ceO_N032 = table2array(S_cell(1:TR_S_cell_Nov3_2, 4)); % Orientation 
S_ceEl_N032 = table2array(S_cell(1:TR_S_cell_Nov3_2, 5)); % Elongation
S_ceEc_N032 = table2array(S_cell(1:TR_S_cell_Nov3_2, 6)); % Eccentricity
S_coI_N032 = table2array(S_col(1:TR_S_col_Nov3_2, 3)); % Intensity 

% 3
S_ceA_N033 = table2array(S_cell(1:TR_S_cell_Nov3_3, 3)); % Area 
S_ceO_N033 = table2array(S_cell(1:TR_S_cell_Nov3_3, 4)); % Orientation 
S_ceEl_N033 = table2array(S_cell(1:TR_S_cell_Nov3_3, 5)); % Elongation
S_ceEc_N033 = table2array(S_cell(1:TR_S_cell_Nov3_3, 6)); % Eccentricity
S_coI_N033 = table2array(S_col(1:TR_S_col_Nov3_3, 3)); % Intensity 


%%% Gathering all S and NS Data for box and whiskers plots 
% include avg from each date shown as a colored dot matching stiffness format
%% NS %%
% Avg cell # per image (total cells / 3) 
Avg_cell_num_NS_Aug17_1 = TR_NS_cell_Aug17_1/3;
Avg_cell_num_NS_Aug17_3 = TR_NS_cell_Aug17_3/3;
Avg_cell_num_NS_Aug17_4 = TR_NS_cell_Aug17_4/1;
Avg_cell_num_NS_Aug22_1 = TR_NS_cell_Aug22_1/3;
Avg_cell_num_NS_Aug22_2 = TR_NS_cell_Aug22_2/3;
Avg_cell_num_NS_Aug22_3 = TR_NS_cell_Aug22_3/3;
Avg_cell_num_NS_Aug22_5 = TR_NS_cell_Aug22_5/3;
Avg_cell_num_NS_Aug22_6 = TR_NS_cell_Aug22_6/3;
Avg_cell_num_NS_Aug22_7 = TR_NS_cell_Aug22_7/3;
Avg_cell_num_NS_Aug22_8 = TR_NS_cell_Aug22_8/3;
Avg_cell_num_NS_Aug22_9 = TR_NS_cell_Aug22_9/3;
Avg_cell_num_NS_Aug22_10 = TR_NS_cell_Aug22_10/3;
Avg_cell_num_NS_Aug22_11 = TR_NS_cell_Aug22_11/3;
Avg_cell_num_NS_Aug28_1 = TR_NS_cell_Aug28_1/3;
Avg_cell_num_NS_Aug28_2 = TR_NS_cell_Aug28_2/3;
Avg_cell_num_NS_Aug28_3 = TR_NS_cell_Aug28_3/3;
Avg_cell_num_NS_Aug28_4 = TR_NS_cell_Aug28_4/3;
Avg_cell_num_NS_Aug28_5 = TR_NS_cell_Aug28_5/3;
Avg_cell_num_NS_Aug28_6 = TR_NS_cell_Aug28_6/3;
Avg_cell_num_NS_Aug28_8 = TR_NS_cell_Aug28_8/3;
Avg_cell_num_NS_Aug28_10 = TR_NS_cell_Aug28_10/3; 
Avg_cell_num_NS_Oct13_1 = TR_NS_cell_Oct13_1/3; 
Avg_cell_num_NS_Oct13_2 = TR_NS_cell_Oct13_2/3; 
Avg_cell_num_NS_Oct13_3 = TR_NS_cell_Oct13_3/3;
Avg_cell_num_NS_Nov3_1 = TR_NS_cell_Nov3_1/3; 
Avg_cell_num_NS_Nov3_2 = TR_NS_cell_Nov3_2/3; 
Avg_cell_num_NS_Nov3_3 = TR_NS_cell_Nov3_3/3;

% Avg cell area per image 
Avg_cell_area_NS_Aug17_1 = mean(NS_ceA_A171); 
Avg_cell_area_NS_Aug17_3 = mean(NS_ceA_A173);
Avg_cell_area_NS_Aug17_4 = mean(NS_ceA_A174);
Avg_cell_area_NS_Aug22_1 = mean(NS_ceA_A221);
Avg_cell_area_NS_Aug22_2 = mean(NS_ceA_A222);
Avg_cell_area_NS_Aug22_3 = mean(NS_ceA_A223);
Avg_cell_area_NS_Aug22_5 = mean(NS_ceA_A225);
Avg_cell_area_NS_Aug22_6 = mean(NS_ceA_A226);
Avg_cell_area_NS_Aug22_7 = mean(NS_ceA_A227);
Avg_cell_area_NS_Aug22_8 = mean(NS_ceA_A228);
Avg_cell_area_NS_Aug22_9 = mean(NS_ceA_A229);
Avg_cell_area_NS_Aug22_10 = mean(NS_ceA_A2210);
Avg_cell_area_NS_Aug22_11 = mean(NS_ceA_A2211);
Avg_cell_area_NS_Aug28_1 = mean(NS_ceA_A281);
Avg_cell_area_NS_Aug28_2 = mean(NS_ceA_A282);
Avg_cell_area_NS_Aug28_3 = mean(NS_ceA_A283);
Avg_cell_area_NS_Aug28_4 = mean(NS_ceA_A284);
Avg_cell_area_NS_Aug28_5 = mean(NS_ceA_A285);
Avg_cell_area_NS_Aug28_6 = mean(NS_ceA_A286);
Avg_cell_area_NS_Aug28_8 = mean(NS_ceA_A288);
Avg_cell_area_NS_Aug28_10 = mean(NS_ceA_A2810);
Avg_cell_area_NS_Oct13_1 = mean(NS_ceA_O131); 
Avg_cell_area_NS_Oct13_2 = mean(NS_ceA_O132); 
Avg_cell_area_NS_Oct13_3 = mean(NS_ceA_O133); 
Avg_cell_area_NS_Nov3_1 = mean(NS_ceA_N031);  
Avg_cell_area_NS_Nov3_2 = mean(NS_ceA_N032); 
Avg_cell_area_NS_Nov3_3 = mean(NS_ceA_N033); 

% Avg cell elongation per image 
Avg_cell_elon_NS_Aug17_1 = mean(NS_ceEl_A171); 
Avg_cell_elon_NS_Aug17_3 = mean(NS_ceEl_A173);
Avg_cell_elon_NS_Aug17_4 = mean(NS_ceEl_A174);
Avg_cell_elon_NS_Aug22_1 = mean(NS_ceEl_A221);
Avg_cell_elon_NS_Aug22_2 = mean(NS_ceEl_A222);
Avg_cell_elon_NS_Aug22_3 = mean(NS_ceEl_A223);
Avg_cell_elon_NS_Aug22_5 = mean(NS_ceEl_A225);
Avg_cell_elon_NS_Aug22_6 = mean(NS_ceEl_A226);
Avg_cell_elon_NS_Aug22_7 = mean(NS_ceEl_A227);
Avg_cell_elon_NS_Aug22_8 = mean(NS_ceEl_A228);
Avg_cell_elon_NS_Aug22_9 = mean(NS_ceEl_A229);
Avg_cell_elon_NS_Aug22_10 = mean(NS_ceEl_A2210);
Avg_cell_elon_NS_Aug22_11 = mean(NS_ceEl_A2211);
Avg_cell_elon_NS_Aug28_1 = mean(NS_ceEl_A281);
Avg_cell_elon_NS_Aug28_2 = mean(NS_ceEl_A282);
Avg_cell_elon_NS_Aug28_3 = mean(NS_ceEl_A283);
Avg_cell_elon_NS_Aug28_4 = mean(NS_ceEl_A284);
Avg_cell_elon_NS_Aug28_5 = mean(NS_ceEl_A285);
Avg_cell_elon_NS_Aug28_6 = mean(NS_ceEl_A286);
Avg_cell_elon_NS_Aug28_8 = mean(NS_ceEl_A288);
Avg_cell_elon_NS_Aug28_10 = mean(NS_ceEl_A2810);
Avg_cell_elon_NS_Oct13_1 = mean(NS_ceEl_O131); 
Avg_cell_elon_NS_Oct13_2 = mean(NS_ceEl_O132); 
Avg_cell_elon_NS_Oct13_3 = mean(NS_ceEl_O133); 
Avg_cell_elon_NS_Nov3_1 = mean(NS_ceEl_N031);  
Avg_cell_elon_NS_Nov3_2 = mean(NS_ceEl_N032); 
Avg_cell_elon_NS_Nov3_3 = mean(NS_ceEl_N033); 

% Avg cell eccentricity per image 
Avg_cell_ecc_NS_Aug17_1 = mean(NS_ceEc_A171); 
Avg_cell_ecc_NS_Aug17_3 = mean(NS_ceEc_A173);
Avg_cell_ecc_NS_Aug17_4 = mean(NS_ceEc_A174);
Avg_cell_ecc_NS_Aug22_1 = mean(NS_ceEc_A221);
Avg_cell_ecc_NS_Aug22_2 = mean(NS_ceEc_A222);
Avg_cell_ecc_NS_Aug22_3 = mean(NS_ceEc_A223);
Avg_cell_ecc_NS_Aug22_5 = mean(NS_ceEc_A225);
Avg_cell_ecc_NS_Aug22_6 = mean(NS_ceEc_A226);
Avg_cell_ecc_NS_Aug22_7 = mean(NS_ceEc_A227);
Avg_cell_ecc_NS_Aug22_8 = mean(NS_ceEc_A228);
Avg_cell_ecc_NS_Aug22_9 = mean(NS_ceEc_A229);
Avg_cell_ecc_NS_Aug22_10 = mean(NS_ceEc_A2210);
Avg_cell_ecc_NS_Aug22_11 = mean(NS_ceEc_A2211);
Avg_cell_ecc_NS_Aug28_1 = mean(NS_ceEc_A281);
Avg_cell_ecc_NS_Aug28_2 = mean(NS_ceEc_A282);
Avg_cell_ecc_NS_Aug28_3 = mean(NS_ceEc_A283);
Avg_cell_ecc_NS_Aug28_4 = mean(NS_ceEc_A284);
Avg_cell_ecc_NS_Aug28_5 = mean(NS_ceEc_A285);
Avg_cell_ecc_NS_Aug28_6 = mean(NS_ceEc_A286);
Avg_cell_ecc_NS_Aug28_8 = mean(NS_ceEc_A288);
Avg_cell_ecc_NS_Aug28_10 = mean(NS_ceEc_A2810);
Avg_cell_ecc_NS_Oct13_1 = mean(NS_ceEc_O131); 
Avg_cell_ecc_NS_Oct13_2 = mean(NS_ceEc_O132); 
Avg_cell_ecc_NS_Oct13_3 = mean(NS_ceEc_O133); 
Avg_cell_ecc_NS_Nov3_1 = mean(NS_ceEc_N031);  
Avg_cell_ecc_NS_Nov3_2 = mean(NS_ceEc_N032); 
Avg_cell_ecc_NS_Nov3_3 = mean(NS_ceEc_N033);

% Cell alignment per image -> MVL STUFF: 0 is random, 1 is aligned
c2m = mean(cos(2*NS_ceO_A171*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A171*pi/180),'omitnan'); 
MVL_NS_A17_1 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*NS_ceO_A173*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A173*pi/180),'omitnan'); 
MVL_NS_A17_3 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*NS_ceO_A174*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A174*pi/180),'omitnan'); 
MVL_NS_A17_4 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*NS_ceO_A221*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A221*pi/180),'omitnan'); 
MVL_NS_A22_1 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*NS_ceO_A222*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A222*pi/180),'omitnan'); 
MVL_NS_A22_2 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*NS_ceO_A223*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A223*pi/180),'omitnan'); 
MVL_NS_A22_3 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*NS_ceO_A225*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A225*pi/180),'omitnan'); 
MVL_NS_A22_5 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*NS_ceO_A226*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A226*pi/180),'omitnan'); 
MVL_NS_A22_6 = sqrt(s2m^2 + c2m^2);             % mean vector length 
c2m = mean(cos(2*NS_ceO_A227*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A227*pi/180),'omitnan'); 
MVL_NS_A22_7 = sqrt(s2m^2 + c2m^2);             % mean vector length 
c2m = mean(cos(2*NS_ceO_A228*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A228*pi/180),'omitnan'); 
MVL_NS_A22_8 = sqrt(s2m^2 + c2m^2);             % mean vector length 
c2m = mean(cos(2*NS_ceO_A229*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A229*pi/180),'omitnan'); 
MVL_NS_A22_9 = sqrt(s2m^2 + c2m^2);             % mean vector length 
c2m = mean(cos(2*NS_ceO_A2210*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A2210*pi/180),'omitnan'); 
MVL_NS_A22_10 = sqrt(s2m^2 + c2m^2);            % mean vector length 
c2m = mean(cos(2*NS_ceO_A2211*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A2211*pi/180),'omitnan'); 
MVL_NS_A22_11 = sqrt(s2m^2 + c2m^2);            % mean vector length 
c2m = mean(cos(2*NS_ceO_A281*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A281*pi/180),'omitnan'); 
MVL_NS_A28_1 = sqrt(s2m^2 + c2m^2);             % mean vector length 
c2m = mean(cos(2*NS_ceO_A282*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A282*pi/180),'omitnan'); 
MVL_NS_A28_2 = sqrt(s2m^2 + c2m^2);             % mean vector length 
c2m = mean(cos(2*NS_ceO_A283*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A283*pi/180),'omitnan'); 
MVL_NS_A28_3 = sqrt(s2m^2 + c2m^2);             % mean vector length 
c2m = mean(cos(2*NS_ceO_A284*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A284*pi/180),'omitnan'); 
MVL_NS_A28_4 = sqrt(s2m^2 + c2m^2);             % mean vector length 
c2m = mean(cos(2*NS_ceO_A285*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A285*pi/180),'omitnan'); 
MVL_NS_A28_5 = sqrt(s2m^2 + c2m^2);             % mean vector length 
c2m = mean(cos(2*NS_ceO_A286*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A286*pi/180),'omitnan'); 
MVL_NS_A28_6 = sqrt(s2m^2 + c2m^2);             % mean vector length 
c2m = mean(cos(2*NS_ceO_A288*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A288*pi/180),'omitnan'); 
MVL_NS_A28_8 = sqrt(s2m^2 + c2m^2);             % mean vector length 
c2m = mean(cos(2*NS_ceO_A2810*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_A2810*pi/180),'omitnan'); 
MVL_NS_A28_10 = sqrt(s2m^2 + c2m^2);            % mean vector length 
c2m = mean(cos(2*NS_ceO_O131*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_O131*pi/180),'omitnan'); 
MVL_NS_O13_1 = sqrt(s2m^2 + c2m^2);            % mean vector length 
c2m = mean(cos(2*NS_ceO_O132*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_O132*pi/180),'omitnan'); 
MVL_NS_O13_2 = sqrt(s2m^2 + c2m^2);            % mean vector length 
c2m = mean(cos(2*NS_ceO_O133*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_O133*pi/180),'omitnan'); 
MVL_NS_O13_3 = sqrt(s2m^2 + c2m^2);            % mean vector length 
c2m = mean(cos(2*NS_ceO_N031*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_N031*pi/180),'omitnan'); 
MVL_NS_N03_1 = sqrt(s2m^2 + c2m^2);            % mean vector length 
c2m = mean(cos(2*NS_ceO_N032*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_N032*pi/180),'omitnan'); 
MVL_NS_N03_2 = sqrt(s2m^2 + c2m^2);            % mean vector length 
c2m = mean(cos(2*NS_ceO_N033*pi/180),'omitnan'); 
s2m = mean(sin(2*NS_ceO_N033*pi/180),'omitnan'); 
MVL_NS_N03_3 = sqrt(s2m^2 + c2m^2);            % mean vector length 

% Col intensity per cell -> sum the col intensity divided by total number of cells
Col_I_per_cell_NS_A17_1 = sum(NS_coI_A171) / TR_NS_cell_Aug17_1; 
Col_I_per_cell_NS_A17_3 = sum(NS_coI_A173) / TR_NS_cell_Aug17_3;
Col_I_per_cell_NS_A17_4 = sum(NS_coI_A174) / TR_NS_cell_Aug17_4;
Col_I_per_cell_NS_A22_1 = sum(NS_coI_A221) / TR_NS_cell_Aug22_1;
Col_I_per_cell_NS_A22_2 = sum(NS_coI_A222) / TR_NS_cell_Aug22_2;
Col_I_per_cell_NS_A22_3 = sum(NS_coI_A223) / TR_NS_cell_Aug22_3;
Col_I_per_cell_NS_A22_5 = sum(NS_coI_A225) / TR_NS_cell_Aug22_5;
Col_I_per_cell_NS_A22_6 = sum(NS_coI_A226) / TR_NS_cell_Aug22_6;
Col_I_per_cell_NS_A22_7 = sum(NS_coI_A227) / TR_NS_cell_Aug22_7;
Col_I_per_cell_NS_A22_8 = sum(NS_coI_A228) / TR_NS_cell_Aug22_8;
Col_I_per_cell_NS_A22_9 = sum(NS_coI_A229) / TR_NS_cell_Aug22_9;
Col_I_per_cell_NS_A22_10 = sum(NS_coI_A2210) / TR_NS_cell_Aug22_10;
Col_I_per_cell_NS_A22_11 = sum(NS_coI_A2211) / TR_NS_cell_Aug22_11;
Col_I_per_cell_NS_A28_1 = sum(NS_coI_A281) / TR_NS_cell_Aug28_1;
Col_I_per_cell_NS_A28_2 = sum(NS_coI_A282) / TR_NS_cell_Aug28_2;
Col_I_per_cell_NS_A28_3 = sum(NS_coI_A283) / TR_NS_cell_Aug28_3;
Col_I_per_cell_NS_A28_4 = sum(NS_coI_A284) / TR_NS_cell_Aug28_4;
Col_I_per_cell_NS_A28_5 = sum(NS_coI_A285) / TR_NS_cell_Aug28_5;
Col_I_per_cell_NS_A28_6 = sum(NS_coI_A286) / TR_NS_cell_Aug28_6;
Col_I_per_cell_NS_A28_8 = sum(NS_coI_A288) / TR_NS_cell_Aug28_8;
Col_I_per_cell_NS_A28_10 = sum(NS_coI_A2810) / TR_NS_cell_Aug28_10;
Col_I_per_cell_NS_O13_1 = sum(NS_coI_O131) / TR_NS_cell_Oct13_1;
Col_I_per_cell_NS_O13_2 = sum(NS_coI_O132) / TR_NS_cell_Oct13_2;
Col_I_per_cell_NS_O13_3 = sum(NS_coI_O133) / TR_NS_cell_Oct13_3;
Col_I_per_cell_NS_N03_1 = sum(NS_coI_N031) / TR_NS_cell_Nov3_1;
Col_I_per_cell_NS_N03_2 = sum(NS_coI_N032) / TR_NS_cell_Nov3_2;
Col_I_per_cell_NS_N03_3 = sum(NS_coI_N033) / TR_NS_cell_Nov3_3;

% Gathering NS Data
% [Avg cell # per image, avg cell area per image, avg cell elongation per image,... 
... avg cell eccentricity per image, cell alignment per image, col intensity per cell]
NS = [Avg_cell_num_NS_Aug17_1, Avg_cell_area_NS_Aug17_1, Avg_cell_elon_NS_Aug17_1, Avg_cell_ecc_NS_Aug17_1, MVL_NS_A17_1, Col_I_per_cell_NS_A17_1;  
      Avg_cell_num_NS_Aug17_3, Avg_cell_area_NS_Aug17_3, Avg_cell_elon_NS_Aug17_3, Avg_cell_ecc_NS_Aug17_3, MVL_NS_A17_3, Col_I_per_cell_NS_A17_3;
      Avg_cell_num_NS_Aug17_4, Avg_cell_area_NS_Aug17_4, Avg_cell_elon_NS_Aug17_4, Avg_cell_ecc_NS_Aug17_4, MVL_NS_A17_4, Col_I_per_cell_NS_A17_4;
      Avg_cell_num_NS_Aug22_1, Avg_cell_area_NS_Aug22_1, Avg_cell_elon_NS_Aug22_1, Avg_cell_ecc_NS_Aug22_1, MVL_NS_A22_1, Col_I_per_cell_NS_A22_1;
      Avg_cell_num_NS_Aug22_2, Avg_cell_area_NS_Aug22_2, Avg_cell_elon_NS_Aug22_2, Avg_cell_ecc_NS_Aug22_2, MVL_NS_A22_2, Col_I_per_cell_NS_A22_2;
      Avg_cell_num_NS_Aug22_3, Avg_cell_area_NS_Aug22_3, Avg_cell_elon_NS_Aug22_3, Avg_cell_ecc_NS_Aug22_3, MVL_NS_A22_3, Col_I_per_cell_NS_A22_3;
      Avg_cell_num_NS_Aug22_5, Avg_cell_area_NS_Aug22_5, Avg_cell_elon_NS_Aug22_5, Avg_cell_ecc_NS_Aug22_5, MVL_NS_A22_5, Col_I_per_cell_NS_A22_5;
      Avg_cell_num_NS_Aug22_6, Avg_cell_area_NS_Aug22_6, Avg_cell_elon_NS_Aug22_6, Avg_cell_ecc_NS_Aug22_6, MVL_NS_A22_6, Col_I_per_cell_NS_A22_6;
      Avg_cell_num_NS_Aug22_7, Avg_cell_area_NS_Aug22_7, Avg_cell_elon_NS_Aug22_7, Avg_cell_ecc_NS_Aug22_7, MVL_NS_A22_7, Col_I_per_cell_NS_A22_7;
      Avg_cell_num_NS_Aug22_8, Avg_cell_area_NS_Aug22_8, Avg_cell_elon_NS_Aug22_8, Avg_cell_ecc_NS_Aug22_8, MVL_NS_A22_8, Col_I_per_cell_NS_A22_8;
      Avg_cell_num_NS_Aug22_9, Avg_cell_area_NS_Aug22_9, Avg_cell_elon_NS_Aug22_9, Avg_cell_ecc_NS_Aug22_9, MVL_NS_A22_9, Col_I_per_cell_NS_A22_9;
      Avg_cell_num_NS_Aug22_10, Avg_cell_area_NS_Aug22_10, Avg_cell_elon_NS_Aug22_10, Avg_cell_ecc_NS_Aug22_10, MVL_NS_A22_10, Col_I_per_cell_NS_A22_10;
      Avg_cell_num_NS_Aug22_11, Avg_cell_area_NS_Aug22_11, Avg_cell_elon_NS_Aug22_11, Avg_cell_ecc_NS_Aug22_11, MVL_NS_A22_11, Col_I_per_cell_NS_A22_11;
      Avg_cell_num_NS_Aug28_1, Avg_cell_area_NS_Aug28_1, Avg_cell_elon_NS_Aug28_1, Avg_cell_ecc_NS_Aug28_1, MVL_NS_A28_1, Col_I_per_cell_NS_A28_1;
      Avg_cell_num_NS_Aug28_2, Avg_cell_area_NS_Aug28_2, Avg_cell_elon_NS_Aug28_2, Avg_cell_ecc_NS_Aug28_2, MVL_NS_A28_2, Col_I_per_cell_NS_A28_2;
      Avg_cell_num_NS_Aug28_3, Avg_cell_area_NS_Aug28_3, Avg_cell_elon_NS_Aug28_3, Avg_cell_ecc_NS_Aug28_3, MVL_NS_A28_3, Col_I_per_cell_NS_A28_3;
      Avg_cell_num_NS_Aug28_4, Avg_cell_area_NS_Aug28_4, Avg_cell_elon_NS_Aug28_4, Avg_cell_ecc_NS_Aug28_4, MVL_NS_A28_4, Col_I_per_cell_NS_A28_4;
      Avg_cell_num_NS_Aug28_5, Avg_cell_area_NS_Aug28_5, Avg_cell_elon_NS_Aug28_5, Avg_cell_ecc_NS_Aug28_5, MVL_NS_A28_5, Col_I_per_cell_NS_A28_5;
      Avg_cell_num_NS_Aug28_6, Avg_cell_area_NS_Aug28_6, Avg_cell_elon_NS_Aug28_6, Avg_cell_ecc_NS_Aug28_6, MVL_NS_A28_6, Col_I_per_cell_NS_A28_6;
      Avg_cell_num_NS_Aug28_8, Avg_cell_area_NS_Aug28_8, Avg_cell_elon_NS_Aug28_8, Avg_cell_ecc_NS_Aug28_8, MVL_NS_A28_8, Col_I_per_cell_NS_A28_8;
      Avg_cell_num_NS_Aug28_10, Avg_cell_area_NS_Aug28_10, Avg_cell_elon_NS_Aug28_10, Avg_cell_ecc_NS_Aug28_10, MVL_NS_A28_10, Col_I_per_cell_NS_A28_10;
      Avg_cell_num_NS_Oct13_1, Avg_cell_area_NS_Oct13_1, Avg_cell_elon_NS_Oct13_1, Avg_cell_ecc_NS_Oct13_1, MVL_NS_O13_1, Col_I_per_cell_NS_O13_1;
      Avg_cell_num_NS_Oct13_2, Avg_cell_area_NS_Oct13_2, Avg_cell_elon_NS_Oct13_2, Avg_cell_ecc_NS_Oct13_2, MVL_NS_O13_2, Col_I_per_cell_NS_O13_2;
      Avg_cell_num_NS_Oct13_3, Avg_cell_area_NS_Oct13_3, Avg_cell_elon_NS_Oct13_3, Avg_cell_ecc_NS_Oct13_3, MVL_NS_O13_3, Col_I_per_cell_NS_O13_3;
      Avg_cell_num_NS_Nov3_1, Avg_cell_area_NS_Nov3_1, Avg_cell_elon_NS_Nov3_1, Avg_cell_ecc_NS_Nov3_1, MVL_NS_N03_1, Col_I_per_cell_NS_N03_1;
      Avg_cell_num_NS_Nov3_2, Avg_cell_area_NS_Nov3_2, Avg_cell_elon_NS_Nov3_2, Avg_cell_ecc_NS_Nov3_2, MVL_NS_N03_2, Col_I_per_cell_NS_N03_2;
      Avg_cell_num_NS_Nov3_3, Avg_cell_area_NS_Nov3_3, Avg_cell_elon_NS_Nov3_3, Avg_cell_ecc_NS_Nov3_3, MVL_NS_N03_3, Col_I_per_cell_NS_N03_3];

%% S %%
% Avg cell # per image (total cells / # spots) 
Avg_cell_num_S_Aug17_1 = TR_S_cell_Aug17_1/3;
Avg_cell_num_S_Aug17_3 = TR_S_cell_Aug17_3/3;
Avg_cell_num_S_Aug17_4 = TR_S_cell_Aug17_4/3;
Avg_cell_num_S_Aug17_5 = TR_S_cell_Aug17_5/1;
Avg_cell_num_S_Aug22_1 = TR_S_cell_Aug22_1/3;
Avg_cell_num_S_Aug22_2 = TR_S_cell_Aug22_2/3;
Avg_cell_num_S_Aug22_3 = TR_S_cell_Aug22_3/3;
Avg_cell_num_S_Aug22_6 = TR_S_cell_Aug22_6/3;
Avg_cell_num_S_Aug22_7 = TR_S_cell_Aug22_7/3;
Avg_cell_num_S_Aug22_8 = TR_S_cell_Aug22_8/3;
Avg_cell_num_S_Aug22_9 = TR_S_cell_Aug22_9/3;
Avg_cell_num_S_Aug22_10 = TR_S_cell_Aug22_10/3;
Avg_cell_num_S_Aug22_11 = TR_S_cell_Aug22_11/3;
Avg_cell_num_S_Aug28_1 = TR_S_cell_Aug28_1/3;
Avg_cell_num_S_Aug28_2 = TR_S_cell_Aug28_2/3;
Avg_cell_num_S_Aug28_3 = TR_S_cell_Aug28_3/3;
Avg_cell_num_S_Aug28_4 = TR_S_cell_Aug28_4/3;
Avg_cell_num_S_Aug28_5 = TR_S_cell_Aug28_5/3;
Avg_cell_num_S_Aug28_6 = TR_S_cell_Aug28_6/3;
Avg_cell_num_S_Aug28_7 = TR_S_cell_Aug28_7/3;
Avg_cell_num_S_Aug28_8 = TR_S_cell_Aug28_8/3;
Avg_cell_num_S_Aug28_9 = TR_S_cell_Aug28_9/3;
Avg_cell_num_S_Aug28_10 = TR_S_cell_Aug28_10/3;
Avg_cell_num_S_Aug28_11 = TR_S_cell_Aug28_11/3;
Avg_cell_num_S_Aug28_12 = TR_S_cell_Aug28_12/3;
Avg_cell_num_S_Oct13_1 = TR_S_cell_Oct13_1/3;
Avg_cell_num_S_Oct13_2 = TR_S_cell_Oct13_2/3;
Avg_cell_num_S_Oct13_3 = TR_S_cell_Oct13_3/3;
Avg_cell_num_S_Nov3_1 = TR_S_cell_Nov3_1/3;
Avg_cell_num_S_Nov3_2 = TR_S_cell_Nov3_2/3;
Avg_cell_num_S_Nov3_3 = TR_S_cell_Nov3_3/3;

% Avg cell area per image 
Avg_cell_area_S_Aug17_1 = mean(S_ceA_A171); 
Avg_cell_area_S_Aug17_3 = mean(S_ceA_A173); 
Avg_cell_area_S_Aug17_4 = mean(S_ceA_A174); 
Avg_cell_area_S_Aug17_5 = mean(S_ceA_A175); 
Avg_cell_area_S_Aug22_1 = mean(S_ceA_A221);
Avg_cell_area_S_Aug22_2 = mean(S_ceA_A222);
Avg_cell_area_S_Aug22_3 = mean(S_ceA_A223);
Avg_cell_area_S_Aug22_6 = mean(S_ceA_A226);
Avg_cell_area_S_Aug22_7 = mean(S_ceA_A227);
Avg_cell_area_S_Aug22_8 = mean(S_ceA_A228);
Avg_cell_area_S_Aug22_9 = mean(S_ceA_A229);
Avg_cell_area_S_Aug22_10 = mean(S_ceA_A2210);
Avg_cell_area_S_Aug22_11 = mean(S_ceA_A2211);
Avg_cell_area_S_Aug28_1 = mean(S_ceA_A281);
Avg_cell_area_S_Aug28_2 = mean(S_ceA_A282);
Avg_cell_area_S_Aug28_3 = mean(S_ceA_A283);
Avg_cell_area_S_Aug28_4 = mean(S_ceA_A284);
Avg_cell_area_S_Aug28_5 = mean(S_ceA_A285);
Avg_cell_area_S_Aug28_6 = mean(S_ceA_A286);
Avg_cell_area_S_Aug28_7 = mean(S_ceA_A287);
Avg_cell_area_S_Aug28_8 = mean(S_ceA_A288);
Avg_cell_area_S_Aug28_9 = mean(S_ceA_A289);
Avg_cell_area_S_Aug28_10 = mean(S_ceA_A2810);
Avg_cell_area_S_Aug28_11 = mean(S_ceA_A2811);
Avg_cell_area_S_Aug28_12 = mean(S_ceA_A2812);
Avg_cell_area_S_Oct13_1 = mean(S_ceA_O131);
Avg_cell_area_S_Oct13_2 = mean(S_ceA_O132);
Avg_cell_area_S_Oct13_3 = mean(S_ceA_O133);
Avg_cell_area_S_Nov3_1 = mean(S_ceA_N031);
Avg_cell_area_S_Nov3_2 = mean(S_ceA_N032);
Avg_cell_area_S_Nov3_3 = mean(S_ceA_N033);

% Avg cell elongation per image 
Avg_cell_elon_S_Aug17_1 = mean(S_ceEl_A171); 
Avg_cell_elon_S_Aug17_3 = mean(S_ceEl_A173); 
Avg_cell_elon_S_Aug17_4 = mean(S_ceEl_A174); 
Avg_cell_elon_S_Aug17_5 = mean(S_ceEl_A175);
Avg_cell_elon_S_Aug22_1 = mean(S_ceEl_A221); 
Avg_cell_elon_S_Aug22_2 = mean(S_ceEl_A222); 
Avg_cell_elon_S_Aug22_3 = mean(S_ceEl_A223); 
Avg_cell_elon_S_Aug22_6 = mean(S_ceEl_A226); 
Avg_cell_elon_S_Aug22_7 = mean(S_ceEl_A227); 
Avg_cell_elon_S_Aug22_8 = mean(S_ceEl_A228); 
Avg_cell_elon_S_Aug22_9 = mean(S_ceEl_A229); 
Avg_cell_elon_S_Aug22_10 = mean(S_ceEl_A2210); 
Avg_cell_elon_S_Aug22_11 = mean(S_ceEl_A2211);
Avg_cell_elon_S_Aug28_1 = mean(S_ceEl_A281); 
Avg_cell_elon_S_Aug28_2 = mean(S_ceEl_A282); 
Avg_cell_elon_S_Aug28_3 = mean(S_ceEl_A283); 
Avg_cell_elon_S_Aug28_4 = mean(S_ceEl_A284); 
Avg_cell_elon_S_Aug28_5 = mean(S_ceEl_A285); 
Avg_cell_elon_S_Aug28_6 = mean(S_ceEl_A286); 
Avg_cell_elon_S_Aug28_7 = mean(S_ceEl_A287); 
Avg_cell_elon_S_Aug28_8 = mean(S_ceEl_A288); 
Avg_cell_elon_S_Aug28_9 = mean(S_ceEl_A289); 
Avg_cell_elon_S_Aug28_10 = mean(S_ceEl_A2810); 
Avg_cell_elon_S_Aug28_11 = mean(S_ceEl_A2812); 
Avg_cell_elon_S_Aug28_12 = mean(S_ceEl_A2812); 
Avg_cell_elon_S_Oct13_1 = mean(S_ceEl_O131); 
Avg_cell_elon_S_Oct13_2 = mean(S_ceEl_O132);
Avg_cell_elon_S_Oct13_3 = mean(S_ceEl_O133);
Avg_cell_elon_S_Nov3_1 = mean(S_ceEl_N031);
Avg_cell_elon_S_Nov3_2 = mean(S_ceEl_N032);
Avg_cell_elon_S_Nov3_3 = mean(S_ceEl_N033);

% Avg cell eccentricity per image 
Avg_cell_ecc_S_Aug17_1 = mean(S_ceEc_A171); 
Avg_cell_ecc_S_Aug17_3 = mean(S_ceEc_A173); 
Avg_cell_ecc_S_Aug17_4 = mean(S_ceEc_A174); 
Avg_cell_ecc_S_Aug17_5 = mean(S_ceEc_A175); 
Avg_cell_ecc_S_Aug22_1 = mean(S_ceEc_A221);
Avg_cell_ecc_S_Aug22_2 = mean(S_ceEc_A222);
Avg_cell_ecc_S_Aug22_3 = mean(S_ceEc_A223);
Avg_cell_ecc_S_Aug22_6 = mean(S_ceEc_A226);
Avg_cell_ecc_S_Aug22_7 = mean(S_ceEc_A227);
Avg_cell_ecc_S_Aug22_8 = mean(S_ceEc_A228);
Avg_cell_ecc_S_Aug22_9 = mean(S_ceEc_A229);
Avg_cell_ecc_S_Aug22_10 = mean(S_ceEc_A2210);
Avg_cell_ecc_S_Aug22_11 = mean(S_ceEc_A2211);
Avg_cell_ecc_S_Aug28_1 = mean(S_ceEc_A281);
Avg_cell_ecc_S_Aug28_2 = mean(S_ceEc_A282);
Avg_cell_ecc_S_Aug28_3 = mean(S_ceEc_A283);
Avg_cell_ecc_S_Aug28_4 = mean(S_ceEc_A284);
Avg_cell_ecc_S_Aug28_5 = mean(S_ceEc_A285);
Avg_cell_ecc_S_Aug28_6 = mean(S_ceEc_A286);
Avg_cell_ecc_S_Aug28_7 = mean(S_ceEc_A287);
Avg_cell_ecc_S_Aug28_8 = mean(S_ceEc_A288);
Avg_cell_ecc_S_Aug28_9 = mean(S_ceEc_A289);
Avg_cell_ecc_S_Aug28_10 = mean(S_ceEc_A2810);
Avg_cell_ecc_S_Aug28_11 = mean(S_ceEc_A2811);
Avg_cell_ecc_S_Aug28_12 = mean(S_ceEc_A2812);
Avg_cell_ecc_S_Oct13_1 = mean(S_ceEc_O131);
Avg_cell_ecc_S_Oct13_2 = mean(S_ceEc_O132);
Avg_cell_ecc_S_Oct13_3 = mean(S_ceEc_O133);
Avg_cell_ecc_S_Nov3_1 = mean(S_ceEc_N031);
Avg_cell_ecc_S_Nov3_2 = mean(S_ceEc_N032);
Avg_cell_ecc_S_Nov3_3 = mean(S_ceEc_N033);

% Cell alignment per image -> MVL STUFF: 0 is random, 1 is aligned
c2m = mean(cos(2*S_ceO_A171*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A171*pi/180),'omitnan'); 
MVL_S_A17_1 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A173*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A173*pi/180),'omitnan'); 
MVL_S_A17_3 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A174*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A174*pi/180),'omitnan'); 
MVL_S_A17_4 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A175*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A175*pi/180),'omitnan'); 
MVL_S_A17_5 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A221*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A221*pi/180),'omitnan'); 
MVL_S_A22_1 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A222*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A222*pi/180),'omitnan'); 
MVL_S_A22_2 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A223*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A223*pi/180),'omitnan'); 
MVL_S_A22_3 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A226*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A226*pi/180),'omitnan'); 
MVL_S_A22_6 = sqrt(s2m^2 + c2m^2);             % mean vector length

c2m = mean(cos(2*S_ceO_A227*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A227*pi/180),'omitnan'); 
MVL_S_A22_7 = sqrt(s2m^2 + c2m^2);             % mean vector length

c2m = mean(cos(2*S_ceO_A228*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A228*pi/180),'omitnan'); 
MVL_S_A22_8 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A229*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A229*pi/180),'omitnan'); 
MVL_S_A22_9 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A2210*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A2210*pi/180),'omitnan'); 
MVL_S_A22_10 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A2211*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A2211*pi/180),'omitnan'); 
MVL_S_A22_11 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A281*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A281*pi/180),'omitnan'); 
MVL_S_A28_1 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A282*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A282*pi/180),'omitnan'); 
MVL_S_A28_2 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A283*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A283*pi/180),'omitnan'); 
MVL_S_A28_3 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A284*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A284*pi/180),'omitnan'); 
MVL_S_A28_4 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A285*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A285*pi/180),'omitnan'); 
MVL_S_A28_5 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A286*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A286*pi/180),'omitnan'); 
MVL_S_A28_6 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A287*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A287*pi/180),'omitnan'); 
MVL_S_A28_7 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A288*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A288*pi/180),'omitnan'); 
MVL_S_A28_8 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A289*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A289*pi/180),'omitnan'); 
MVL_S_A28_9 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A2810*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A2810*pi/180),'omitnan'); 
MVL_S_A28_10 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A2811*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A2811*pi/180),'omitnan'); 
MVL_S_A28_11 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_A2812*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_A2812*pi/180),'omitnan'); 
MVL_S_A28_12 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_O131*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_O131*pi/180),'omitnan'); 
MVL_S_O13_1 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_O132*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_O132*pi/180),'omitnan'); 
MVL_S_O13_2 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_O133*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_O133*pi/180),'omitnan'); 
MVL_S_O13_3 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_N031*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_N031*pi/180),'omitnan'); 
MVL_S_N03_1 = sqrt(s2m^2 + c2m^2);             % mean vector length
c2m = mean(cos(2*S_ceO_N032*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_N032*pi/180),'omitnan'); 
MVL_S_N03_2 = sqrt(s2m^2 + c2m^2);             % mean vector lengt
c2m = mean(cos(2*S_ceO_N033*pi/180),'omitnan'); 
s2m = mean(sin(2*S_ceO_N033*pi/180),'omitnan'); 
MVL_S_N03_3 = sqrt(s2m^2 + c2m^2);             % mean vector lengt

% Col intensity per cell -> sum the col intensity divided by number of
% cells
Col_I_per_cell_S_A17_1 = sum(S_coI_A171) / TR_S_cell_Aug17_1; 
Col_I_per_cell_S_A17_3 = sum(S_coI_A173) / TR_S_cell_Aug17_3;
Col_I_per_cell_S_A17_4 = sum(S_coI_A174) / TR_S_cell_Aug17_4;
Col_I_per_cell_S_A17_5 = sum(S_coI_A175) / TR_S_cell_Aug17_5;
Col_I_per_cell_S_A22_1 = sum(S_coI_A221) / TR_S_cell_Aug22_1;
Col_I_per_cell_S_A22_2 = sum(S_coI_A222) / TR_S_cell_Aug22_2;
Col_I_per_cell_S_A22_3 = sum(S_coI_A223) / TR_S_cell_Aug22_3;
Col_I_per_cell_S_A22_6 = sum(S_coI_A226) / TR_S_cell_Aug22_6;
Col_I_per_cell_S_A22_7 = sum(S_coI_A227) / TR_S_cell_Aug22_7;
Col_I_per_cell_S_A22_8 = sum(S_coI_A228) / TR_S_cell_Aug22_8;
Col_I_per_cell_S_A22_9 = sum(S_coI_A229) / TR_S_cell_Aug22_9;
Col_I_per_cell_S_A22_10 = sum(S_coI_A2210) / TR_S_cell_Aug22_10;
Col_I_per_cell_S_A22_11 = sum(S_coI_A2211) / TR_S_cell_Aug22_11;
Col_I_per_cell_S_A28_1 = sum(S_coI_A281) / TR_S_cell_Aug28_1;
Col_I_per_cell_S_A28_2 = sum(S_coI_A282) / TR_S_cell_Aug28_2;
Col_I_per_cell_S_A28_3 = sum(S_coI_A283) / TR_S_cell_Aug28_3;
Col_I_per_cell_S_A28_4 = sum(S_coI_A284) / TR_S_cell_Aug28_4;
Col_I_per_cell_S_A28_5 = sum(S_coI_A285) / TR_S_cell_Aug28_5;
Col_I_per_cell_S_A28_6 = sum(S_coI_A286) / TR_S_cell_Aug28_6;
Col_I_per_cell_S_A28_7 = sum(S_coI_A287) / TR_S_cell_Aug28_7;
Col_I_per_cell_S_A28_8 = sum(S_coI_A288) / TR_S_cell_Aug28_8;
Col_I_per_cell_S_A28_9 = sum(S_coI_A289) / TR_S_cell_Aug28_9;
Col_I_per_cell_S_A28_10 = sum(S_coI_A2810) / TR_S_cell_Aug28_10;
Col_I_per_cell_S_A28_11 = sum(S_coI_A2811) / TR_S_cell_Aug28_11;
Col_I_per_cell_S_A28_12 = sum(S_coI_A2812) / TR_S_cell_Aug28_12;
Col_I_per_cell_S_O13_1 = sum(S_coI_O131) / TR_S_cell_Oct13_1;
Col_I_per_cell_S_O13_2 = sum(S_coI_O132) / TR_S_cell_Oct13_2;
Col_I_per_cell_S_O13_3 = sum(S_coI_O133) / TR_S_cell_Oct13_3;
Col_I_per_cell_S_N03_1 = sum(S_coI_N031) / TR_S_cell_Nov3_1;
Col_I_per_cell_S_N03_2 = sum(S_coI_N032) / TR_S_cell_Nov3_2;
Col_I_per_cell_S_N03_3 = sum(S_coI_N033) / TR_S_cell_Nov3_3;

% Gathering S Data 
% [Avg cell # per image, avg cell area per image, avg cell elongation per image,... 
... avg cell eccentricity per image, cell alignment per image, col intensity per cell]
S = [Avg_cell_num_S_Aug17_1, Avg_cell_area_S_Aug17_1, Avg_cell_elon_S_Aug17_1, Avg_cell_ecc_S_Aug17_1, MVL_S_A17_1, Col_I_per_cell_S_A17_1;  
     Avg_cell_num_S_Aug17_3, Avg_cell_area_S_Aug17_3, Avg_cell_elon_S_Aug17_3, Avg_cell_ecc_S_Aug17_3, MVL_S_A17_3, Col_I_per_cell_S_A17_3; 
     Avg_cell_num_S_Aug17_4, Avg_cell_area_S_Aug17_4, Avg_cell_elon_S_Aug17_4, Avg_cell_ecc_S_Aug17_4, MVL_S_A17_4, Col_I_per_cell_S_A17_4; 
     Avg_cell_num_S_Aug17_5, Avg_cell_area_S_Aug17_5, Avg_cell_elon_S_Aug17_5, Avg_cell_ecc_S_Aug17_5, MVL_S_A17_5, Col_I_per_cell_S_A17_5;
     Avg_cell_num_S_Aug22_1, Avg_cell_area_S_Aug22_1, Avg_cell_elon_S_Aug22_1, Avg_cell_ecc_S_Aug22_1, MVL_S_A22_1, Col_I_per_cell_S_A22_1; 
     Avg_cell_num_S_Aug22_2, Avg_cell_area_S_Aug22_2, Avg_cell_elon_S_Aug22_2, Avg_cell_ecc_S_Aug22_2, MVL_S_A22_2, Col_I_per_cell_S_A22_2;
     Avg_cell_num_S_Aug22_3, Avg_cell_area_S_Aug22_3, Avg_cell_elon_S_Aug22_3, Avg_cell_ecc_S_Aug22_3, MVL_S_A22_3, Col_I_per_cell_S_A22_3;
     Avg_cell_num_S_Aug22_6, Avg_cell_area_S_Aug22_6, Avg_cell_elon_S_Aug22_6, Avg_cell_ecc_S_Aug22_6, MVL_S_A22_6, Col_I_per_cell_S_A22_6;
     Avg_cell_num_S_Aug22_7, Avg_cell_area_S_Aug22_7, Avg_cell_elon_S_Aug22_7, Avg_cell_ecc_S_Aug22_7, MVL_S_A22_7, Col_I_per_cell_S_A22_7;
     Avg_cell_num_S_Aug22_8, Avg_cell_area_S_Aug22_8, Avg_cell_elon_S_Aug22_8, Avg_cell_ecc_S_Aug22_8, MVL_S_A22_8, Col_I_per_cell_S_A22_8;
     Avg_cell_num_S_Aug22_9, Avg_cell_area_S_Aug22_9, Avg_cell_elon_S_Aug22_9, Avg_cell_ecc_S_Aug22_9, MVL_S_A22_9, Col_I_per_cell_S_A22_9;
     Avg_cell_num_S_Aug22_10, Avg_cell_area_S_Aug22_10, Avg_cell_elon_S_Aug22_10, Avg_cell_ecc_S_Aug22_10, MVL_S_A22_10, Col_I_per_cell_S_A22_10;
     Avg_cell_num_S_Aug22_11, Avg_cell_area_S_Aug22_11, Avg_cell_elon_S_Aug22_11, Avg_cell_ecc_S_Aug22_11, MVL_S_A22_11, Col_I_per_cell_S_A22_11;
     Avg_cell_num_S_Aug28_1, Avg_cell_area_S_Aug28_1, Avg_cell_elon_S_Aug28_1, Avg_cell_ecc_S_Aug28_1, MVL_S_A28_1, Col_I_per_cell_S_A28_1;                                         
     Avg_cell_num_S_Aug28_2, Avg_cell_area_S_Aug28_2, Avg_cell_elon_S_Aug28_2, Avg_cell_ecc_S_Aug28_2, MVL_S_A28_2, Col_I_per_cell_S_A28_2;   
     Avg_cell_num_S_Aug28_3, Avg_cell_area_S_Aug28_3, Avg_cell_elon_S_Aug28_3, Avg_cell_ecc_S_Aug28_3, MVL_S_A28_3, Col_I_per_cell_S_A28_3;   
     Avg_cell_num_S_Aug28_4, Avg_cell_area_S_Aug28_4, Avg_cell_elon_S_Aug28_4, Avg_cell_ecc_S_Aug28_4, MVL_S_A28_4, Col_I_per_cell_S_A28_4;   
     Avg_cell_num_S_Aug28_5, Avg_cell_area_S_Aug28_5, Avg_cell_elon_S_Aug28_5, Avg_cell_ecc_S_Aug28_5, MVL_S_A28_5, Col_I_per_cell_S_A28_5;   
     Avg_cell_num_S_Aug28_6, Avg_cell_area_S_Aug28_6, Avg_cell_elon_S_Aug28_6, Avg_cell_ecc_S_Aug28_6, MVL_S_A28_6, Col_I_per_cell_S_A28_6;   
     Avg_cell_num_S_Aug28_7, Avg_cell_area_S_Aug28_7, Avg_cell_elon_S_Aug28_7, Avg_cell_ecc_S_Aug28_7, MVL_S_A28_7, Col_I_per_cell_S_A28_7;   
     Avg_cell_num_S_Aug28_8, Avg_cell_area_S_Aug28_8, Avg_cell_elon_S_Aug28_8, Avg_cell_ecc_S_Aug28_8, MVL_S_A28_8, Col_I_per_cell_S_A28_8;   
     Avg_cell_num_S_Aug28_9, Avg_cell_area_S_Aug28_9, Avg_cell_elon_S_Aug28_9, Avg_cell_ecc_S_Aug28_9, MVL_S_A28_9, Col_I_per_cell_S_A28_9;   
     Avg_cell_num_S_Aug28_10, Avg_cell_area_S_Aug28_10, Avg_cell_elon_S_Aug28_10, Avg_cell_ecc_S_Aug28_10, MVL_S_A28_10, Col_I_per_cell_S_A28_10;   
     Avg_cell_num_S_Aug28_11, Avg_cell_area_S_Aug28_11, Avg_cell_elon_S_Aug28_11, Avg_cell_ecc_S_Aug28_11, MVL_S_A28_11, Col_I_per_cell_S_A28_11;   
     Avg_cell_num_S_Aug28_12, Avg_cell_area_S_Aug28_12, Avg_cell_elon_S_Aug28_12, Avg_cell_ecc_S_Aug28_12, MVL_S_A28_12, Col_I_per_cell_S_A28_12; 
     Avg_cell_num_S_Oct13_1, Avg_cell_area_S_Oct13_1, Avg_cell_elon_S_Oct13_1, Avg_cell_ecc_S_Oct13_1, MVL_S_O13_1, Col_I_per_cell_S_O13_1;   
     Avg_cell_num_S_Oct13_2, Avg_cell_area_S_Oct13_2, Avg_cell_elon_S_Oct13_2, Avg_cell_ecc_S_Oct13_2, MVL_S_O13_2, Col_I_per_cell_S_O13_2; 
     Avg_cell_num_S_Oct13_3, Avg_cell_area_S_Oct13_3, Avg_cell_elon_S_Oct13_3, Avg_cell_ecc_S_Oct13_3, MVL_S_O13_3, Col_I_per_cell_S_O13_3;
     Avg_cell_num_S_Nov3_1, Avg_cell_area_S_Nov3_1, Avg_cell_elon_S_Nov3_1, Avg_cell_ecc_S_Nov3_1, MVL_S_N03_1, Col_I_per_cell_S_N03_1; 
     Avg_cell_num_S_Nov3_2, Avg_cell_area_S_Nov3_2, Avg_cell_elon_S_Nov3_2, Avg_cell_ecc_S_Nov3_2, MVL_S_N03_2, Col_I_per_cell_S_N03_2; 
     Avg_cell_num_S_Nov3_3, Avg_cell_area_S_Nov3_3, Avg_cell_elon_S_Nov3_3, Avg_cell_ecc_S_Nov3_3, MVL_S_N03_3, Col_I_per_cell_S_N03_3];

%% Gathering Data  
% Cell Number 
a = S(:,1); b = NS(:,1); c = size(a); d = size(b); e(1:d) = NS(:,1); e(d:c) = NaN; e = e';
F(:,1) = e; F(:,2) = a;
% Cell Area
a = S(:,2); b = NS(:,2); c = size(a); d = size(b); e(1:d) = NS(:,2); e(d:c) = NaN; e = e';
F(:,3) = e; F(:,4) = a;
% Cell Elongation
a = S(:,3); b = NS(:,3); c = size(a); d = size(b); e(1:d) = NS(:,3); e(d:c) = NaN; e = e';
F(:,5) = e; F(:,6) = a;
% Cell Eccentricity
a = S(:,4); b = NS(:,4); c = size(a); d = size(b); e(1:d) = NS(:,4); e(d:c) = NaN; e = e';
F(:,7) = e; F(:,8) = a;
% Cell Alignment
a = S(:,5); b = NS(:,5); c = size(a); d = size(b); e(1:d) = NS(:,5); e(d:c) = NaN; e = e';
F(:,9) = e; F(:,10) = a;
% Collagen IV per cell
a = S(:,6); b = NS(:,6); c = size(a); d = size(b); e(1:d) = NS(:,6); e(d:c) = NaN; e = e';
F(:,11) = e; F(:,12) = a;

%% Stats 
% [h,p] = ttest2(___)
[h(1),p(1)] = ttest2(F(:,1),F(:,2)); 
[h(2),p(2)] = ttest2(F(:,3),F(:,4)); 
[h(3),p(3)] = ttest2(F(:,5),F(:,6)); % elongation... 
[h(4),p(4)] = ttest2(F(:,7),F(:,8)); 
[h(5),p(5)] = ttest2(F(:,9),F(:,10)); 
[h(6),p(6)] = ttest2(F(:,11),F(:,12)); 
p = round(p,3,'significant');

%% Plotting
fig = figure('Name', 'No Stretch vs Stretch'); 
subplot(1,5,1);
boxplot((F(:,1:2)),'symbol','','Labels',{'No Stretch','Stretch'}); 
title(sprintf('Cell Number')); 
ylim([0 425]);
% Change the boxplot color 
c = get(get(gca,'children'),'children');   % Get the handles of all the objects
get(c,'tag'); 
set(c(6,:),'color','k','linewidth',1); 
color = {'r','b'};
e = findobj(gca,'Tag','Box');
for i = 1:length(e)
    patch(get(e(i),'XData'), get(e(i),'YData'), color{i}, 'FaceAlpha', 0.5);
end
% Changing median color
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k');
% Adding p-value
txt = ['p > 0.95'];
text(1.25,405,txt);

subplot(1,5,2); 
boxplot(F(:,3:4),'symbol','','Labels',{'No Stretch','Stretch'}); 
title(sprintf('Cell Area', p(2)));   
ylim([0 600]);
% Change the boxplot color 
c = get(get(gca,'children'),'children');   % Get the handles of all the objects
get(c,'tag'); 
set(c(6,:),'color','k','linewidth',1); 
color = {'r','b'};
e = findobj(gca,'Tag','Box');
for i = 1:length(e)
    patch(get(e(i),'XData'), get(e(i),'YData'), color{i}, 'FaceAlpha', 0.5);
end
% Changing median color
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k');
% Adding p-value
txt = ['p < 0.01'];
text(1.25,565,txt);

subplot(1,5,3);
boxplot(F(:,7:8),'symbol','','Labels',{'No Stretch','Stretch'});   
ylim([0 0.9]);
title(sprintf('Cell Eccentricity'));
% Change the boxplot color 
c = get(get(gca,'children'),'children');   % Get the handles of all the objects
get(c,'tag'); 
set(c(6,:),'color','k','linewidth',1); 
color = {'r','b'};
e = findobj(gca,'Tag','Box');
for i = 1:length(e)
    patch(get(e(i),'XData'), get(e(i),'YData'), color{i}, 'FaceAlpha', 0.5);
end
% Changing median color
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k');
% Adding p-value
txt = ['p < 0.01'];
text(1.25,0.855,txt);

subplot(1,5,4); 
boxplot(F(:,9:10),'symbol','','Labels',{'No Stretch','Stretch'}); 
title(sprintf('Cell Alignment')); 
ylim([0 0.64]);
% Change the boxplot color 
c = get(get(gca,'children'),'children');   % Get the handles of all the objects
get(c,'tag'); 
set(c(6,:),'color','k','linewidth',1); 
color = {'r','b'};
e = findobj(gca,'Tag','Box');
for i = 1:length(e)
    patch(get(e(i),'XData'), get(e(i),'YData'), color{i}, 'FaceAlpha', 0.5);
end
% Changing median color
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k');
% Adding p-value
txt = ['p < 0.01'];
text(1.25,0.608,txt);

subplot(1,5,5);
boxplot(F(:,11:12),'symbol','','Labels',{'No Stretch','Stretch'}); 
title(sprintf('Collagen IV Intensity'));  
ylim([0 440]);
% Change the boxplot color 
c = get(get(gca,'children'),'children');   % Get the handles of all the objects
get(c,'tag'); 
set(c(6,:),'color','k','linewidth',1); 
color = {'r','b'};
e = findobj(gca,'Tag','Box');
for i = 1:length(e)
    patch(get(e(i),'XData'), get(e(i),'YData'), color{i}, 'FaceAlpha', 0.5);
end
% Changing median color
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k');
% Adding p-value
txt = ['p < 0.01'];
text(1.25,417,txt);

