clc;

fprintf('Feature Extraction Toolbox - batch version\n');
fprintf('(c) Laszlo A. Jeni, www.laszlojeni.com\n');
fprintf('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n');

load('ms3D_v1024_low_forehead');

% IOD normalization
e1 = mean(ms3D(37:42,:));
e2 = mean(ms3D(43:48,:));
d = dist3D(e1,e2);
%ms3D = ms3D * (IOD/d) + res/2;

ms3D = ms3D * (IOD/d);
minXY = min(ms3D(:,1:2),[],1);
maxXY = max(ms3D(:,1:2),[],1);

ms3D(:,1) = ms3D(:,1) - (maxXY(1) + minXY(1))/2 + res/2;
ms3D(:,2) = ms3D(:,2) - (maxXY(2) + minXY(2))/2 + res/2;

descExt = [];

fprintf('input list:\t%s\n',inFile);
fprintf('tracking dir:\t%s\n',trackingDir);
fprintf('output dir:\t%s\n',outDir);
fprintf('norm. function:\t%s\n',normFunc);
fprintf('desc. function:\t%s\n',descFunc);
fprintf('\n');

fprintf('reading list: ');
fid = fopen(inFile);
C = textscan(fid,'%q%q');
fprintf('found %d item(s) to process\n\n',length(C{1,1}));
fclose(fid);

nItems = length(C{1,1});