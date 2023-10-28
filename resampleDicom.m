function x = resampleDicom(filename)
% script to resample the 3D data to equal sample sizes in all dimensions


%% parameters of the output
% you can set the values here, or if left at -1 will assume default
% behavior
%filename = 'cube.dcm';


x = readDicom3D(filename);

%% Shouldn't need to modify beyond here!
dW = x.widthspan/x.width;
dH = x.heightspan/x.height;
dD = x.depthspan/x.depth;

ref = min(min(dW,dH),dD);

scaleX = dW/ref;
scaleY = dH/ref;
scaleZ = dD/ref;

% Test run to get size
x.data = reshape(x.data,x.width,x.height,x.depth,x.NumVolumes);
tmp = squeeze(x.data(:,:,:,1));
dummy = imresize3(tmp,'Scale',[scaleX scaleY scaleZ]);
sz = size(dummy);

newVols = zeros(sz(1),sz(2),sz(3),x.NumVolumes);

for i = 1:x.NumVolumes
   tmp = squeeze(x.data(:,:,:,i));
   newVols(:,:,:,i) = imresize3(tmp,'Scale',[scaleX scaleY scaleZ]);
end

%% Now write new values back into struct
x.data = newVols;
dim = size(newVols);
x.width = dim(1);
x.width_padded = dim(1);
x.height = dim(2);
x.height_padded = dim(2);
x.depth = dim(3);
x.depth_padded = dim(3);

x.widthspan = x.width*ref;
x.heightspan = x.height*ref;
x.depthspan = x.depth*ref;
x.N = x.height*x.width*x.depth;
x.N_padded = x.N;

return