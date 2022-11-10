% Sam Coeyman
% Image Processing for tracking green centroids in magnetic pistons

%% Housekeeping
clc; close all; clear;

%% Code Layout 
% Import video
% - Read first frame 
% - Use measure tool to find width of a single well in pixels 
% - Calculate how many mm's that one pixel takes up 

% Create loop 
% - Read frame 
% - Convert to binary 
% - Filter 
% - Find centroid 
% - Output coordinates of centroid 
% - Disp = current frame - original frame 

%% Importing Video 
video = VideoReader('NS1 - Oct 31.mov');                         % loading in piston displacement video
totalframes = video.NumFrames;                                   % total number of frames in video 

%% Opening first frame and getting measurements
% Loading in first frame and getting crop dimensions 
ff = read(video,10); %  starting on frame 10
figure(1)
title('Crop');
f = imshow(ff);
[ff_cropped,rect] = imcrop(ff); % cropping image
  
% Measure well width and get pixel:mm conversion
imshow(ff_cropped);
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
title('Measure the width of well');
h = imdistline(gca);
api = iptgetapi(h);
api.setLabelVisible(false);
pause('on'); 
pause;
length = api.getDistance(); % get line
onepix_inmm = 4 / length;   % well is 4 mm wide

%% Measure tissue starting lengths and min/max widths and convert to mm
% C1
imshow(ff_cropped);
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
title('Starting from bottom, measure tissue length (1st) min width (2) and max width (3)');
h = imdistline(gca);
api = iptgetapi(h);
api.setLabelVisible(false);
pause('on'); 
pause;
length = api.getDistance(); % get line
c1_tissue_length = length*onepix_inmm ; % mm - depends on daily compaction

j = imdistline(gca);
api = iptgetapi(j);
api.setLabelVisible(false);
pause('on'); 
pause;
minwidth = api.getDistance(); % get line
c1_tissue_minwidth = minwidth*onepix_inmm ; % mm - depends on daily compaction

jj = imdistline(gca);
api = iptgetapi(jj);
api.setLabelVisible(false);
pause('on'); 
pause;
maxwidth = api.getDistance(); % get line
c1_tissue_maxwidth = maxwidth*onepix_inmm ; % mm - depends on daily compaction

% C2
k = imdistline(gca);
api = iptgetapi(k);
api.setLabelVisible(false);
pause('on'); 
pause;
length2 = api.getDistance(); % get line
c2_tissue_length = length2*onepix_inmm ; % mm - depends on daily compaction

l = imdistline(gca);
api = iptgetapi(l);
api.setLabelVisible(false);
pause('on'); 
pause;
minwidth2 = api.getDistance(); % get line
c2_tissue_minwidth = minwidth2*onepix_inmm ; % mm - depends on daily compaction

ll = imdistline(gca);
api = iptgetapi(ll);
api.setLabelVisible(false);
pause('on'); 
pause;
maxwidth2 = api.getDistance(); % get line
c2_tissue_maxwidth = maxwidth2*onepix_inmm ; % mm - depends on daily compaction

% C3
m = imdistline(gca);
api = iptgetapi(m);
api.setLabelVisible(false);
pause('on'); 
pause;
length3 = api.getDistance(); % get line
c3_tissue_length = length3*onepix_inmm ; % mm - depends on daily compaction

a = imdistline(gca);
api = iptgetapi(a);
api.setLabelVisible(false);
pause('on'); 
pause;
minwidth3 = api.getDistance(); % get line
c3_tissue_minwidth = minwidth3*onepix_inmm ; % mm - depends on daily compaction

aa = imdistline(gca);
api = iptgetapi(aa);
api.setLabelVisible(false);
pause('on'); 
pause;
maxwidth3 = api.getDistance(); % get line
c3_tissue_maxwidth = maxwidth3*onepix_inmm ; % mm - depends on daily compaction

% C4
b = imdistline(gca);
api = iptgetapi(b);
api.setLabelVisible(false);
pause('on'); 
pause;
length4 = api.getDistance(); % get line
c4_tissue_length = length4*onepix_inmm ; % mm - depends on daily compaction

c = imdistline(gca);
api = iptgetapi(c);
api.setLabelVisible(false);
pause('on'); 
pause;
minwidth4 = api.getDistance(); % get line
c4_tissue_minwidth = minwidth4*onepix_inmm ; % mm - depends on daily compaction

cc = imdistline(gca);
api = iptgetapi(cc);
api.setLabelVisible(false);
pause('on'); 
pause;
maxwidth4 = api.getDistance(); % get line
c4_tissue_maxwidth = maxwidth4*onepix_inmm ; % mm - depends on daily compaction

% C5
d = imdistline(gca);
api = iptgetapi(d);
api.setLabelVisible(false);
pause('on'); 
pause;
length5 = api.getDistance(); % get line
c5_tissue_length = length5*onepix_inmm ; % mm - depends on daily compaction

e = imdistline(gca);
api = iptgetapi(e);
api.setLabelVisible(false);
pause('on'); 
pause;
minwidth5 = api.getDistance(); % get line
c5_tissue_minwidth = minwidth5*onepix_inmm ; % mm - depends on daily compaction

ee = imdistline(gca);
api = iptgetapi(ee);
api.setLabelVisible(false);
pause('on'); 
pause;
maxwidth5 = api.getDistance(); % get line
c5_tissue_maxwidth = maxwidth5*onepix_inmm ; % mm - depends on daily compaction

% C6
z = imdistline(gca);
api = iptgetapi(z);
api.setLabelVisible(false);
pause('on'); 
pause;
length6 = api.getDistance(); % get line
c6_tissue_length = length6*onepix_inmm ; % mm - depends on daily compaction

r = imdistline(gca);
api = iptgetapi(r);
api.setLabelVisible(false);
pause('on'); 
pause;
minwidth6 = api.getDistance(); % get line
c6_tissue_minwidth = minwidth6*onepix_inmm ; % mm - depends on daily compaction

rr = imdistline(gca);
api = iptgetapi(rr);
api.setLabelVisible(false);
pause('on'); 
pause;
maxwidth6 = api.getDistance(); % get line
c6_tissue_maxwidth = maxwidth6*onepix_inmm ; % mm - depends on daily compaction

%% Going through all frames
n=1;
for f = 10:1:(totalframes-10)  % frame #
    fprintf('Processing frame %d of %d...',f,totalframes);
    sf = read(video,f);                                 % reading frame from video
    sf2 = imcrop(sf,rect);                              % cropping to show magnetic pillar
    [BW,maskedRGBImage] = createMask(sf2);
    bfill = imfill(BW, 'holes');                        % filling in "holes" 
    bh = bwareaopen(bfill, 10);                        % deleting "blobs" < 50 pixels 
    
    %  Label each object so we can make measurements of it
    [labeledImage, numberOfRegions] = bwlabeln(bh, 8);  
    coloredLabels = label2rgb(labeledImage, 'hsv', 'k', 'noshuffle'); % pseudo random color labels
    
    % locate the centroid of the object
    measurements = regionprops(bh);  % change to bfill to bh if above line is running 

    % Finding centroids  
    centroids = vertcat(measurements.Centroid);
    x = centroids(:,1); % Getting x values of centroids 
    y = centroids(:,2); % Getting y values of centroids
    xx = size(x); 
    xx1 = xx(:,1);
    if xx1 == 6 
        [sortY, sortOrder] = sort(y, 'descend'); % sorts y values in ascending order

        % Sorting Measurements
        measurements = measurements(sortOrder);
        centroids = vertcat(measurements.Centroid);

        % Getting boundary boxes
        boundbox = [measurements.BoundingBox]; 
        boundbox_x = boundbox(3:4:end);
        boundbox_y = boundbox(4:4:end);

        % Plotting
        subplot(2,3,1); imshow(ff); title('Original Frame');
        subplot(2,3,2); imshow(sf); title('Current Frame Not Cropped');
        subplot(2,3,3); imshow(sf2); 
            caption = sprintf('Cropped, frame #%d 0f %d', f, totalframes);
            title(caption);
        subplot(2,3,4); imshow(maskedRGBImage); title('Cropped Frame Filtered'); 
        subplot(2,3,5); imshow(coloredLabels); title('Labeled Binary Image')
        subplot(2,3,6); imshow(sf2); title('Centroid Locations');
        hold on
            for k = 1 : numberOfRegions
                plot(centroids(k,1), centroids(k,2), 'b*');
            end
        hold off

        % Gathering centroid data 
        c1(f,:) = [centroids(1,1) centroids(1,2)]; 
        c2(f,:) = [centroids(2,1) centroids(2,2)];  
        c3(f,:) = [centroids(3,1) centroids(3,2)]; 
        c4(f,:) = [centroids(4,1) centroids(4,2)]; 
        c5(f,:) = [centroids(5,1) centroids(5,2)]; 
        c6(f,:) = [centroids(6,1) centroids(6,2)]; 

        pause(1);
        fprintf('Done.\n');
        n = n + 1; 
    else 
        n = n + 1;
    end 
end

% Conversion from Pixel to millimeter
c1_mm = c1(:,1)*onepix_inmm;    % converting from pixels to mm
c2_mm = c2(:,1)*onepix_inmm;
c3_mm = c3(:,1)*onepix_inmm;
c4_mm = c4(:,1)*onepix_inmm;
c5_mm = c5(:,1)*onepix_inmm;
c6_mm = c6(:,1)*onepix_inmm;

% Calculating Strains  
for t = 10:1:f
    c1_strain(t,1) = ((abs(c1_mm(t)-c1_mm(10)))/c1_tissue_length)*100;
    c2_strain(t,1) = ((abs(c2_mm(t)-c2_mm(10)))/c2_tissue_length)*100;
    c3_strain(t,1) = ((abs(c3_mm(t)-c3_mm(10)))/c3_tissue_length)*100;
    c4_strain(t,1) = ((abs(c4_mm(t)-c4_mm(10)))/c4_tissue_length)*100;
    c5_strain(t,1) = ((abs(c5_mm(t)-c5_mm(10)))/c5_tissue_length)*100;
    c6_strain(t,1) = ((abs(c6_mm(t)-c6_mm(10)))/c6_tissue_length)*100;
end 

%% Oragnizing strain table and removing zeros
strain = [c1_strain c2_strain c3_strain c4_strain c5_strain c6_strain];
% Rows
strain(all(~strain,2),:) = [];
% Columns
strain(:,all(~strain,1)) = [];

%% Gathering data 
well_startdata = [1, c1_tissue_length, c1_tissue_minwidth, c1_tissue_maxwidth;
                  2, c2_tissue_length, c2_tissue_minwidth, c2_tissue_maxwidth;
                  3, c3_tissue_length, c3_tissue_minwidth, c3_tissue_maxwidth;
                  4, c4_tissue_length, c4_tissue_minwidth, c4_tissue_maxwidth;
                  5, c5_tissue_length, c5_tissue_minwidth, c5_tissue_maxwidth;
                  6, c6_tissue_length, c6_tissue_minwidth, c6_tissue_maxwidth;];

rowNames = {'Well 1','Well 2','Well 3','Well 4','Well 5','Well 6'};
colNames = {'Well','Length (mm)','MinWidth (mm)','MaxWidth (mm)'};
sTable = array2table(well_startdata,'RowNames',rowNames,'VariableNames',colNames);

%% Writing data to excel table 
writetable(sTable,'Nov 3.xlsx','Sheet', 5)
xlswrite('Nov 3.xlsx', strain, 5, 'J3')