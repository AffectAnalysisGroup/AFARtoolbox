Copyright (c) 2012-2015 Laszlo A Jeni. All rights reserved.

Welcome to the ZFace 3D Facial Landmark Tracking SDK.

*** IMPORTANT ***
-----------------
This code is under no circumstances to be shared with others unless allowed by the author or through entities that are commercially licensing this code.


How to cite the SDK
-------------------

If you use the SDK please cite the following works:


László A. Jeni, Jeffrey F. Cohn, Takeo Kanade: Dense 3D Face Alignment from 2D Videos in Real-Time,
11th IEEE International Conference on Automatic Face and Gesture Recognition, 2015, Ljubljana, Slovenia.

@inproceedings{Jeni15FG_ZFace,
author = {L{\'a}szl{\'o} A. Jeni and Jeffrey F. Cohn and Takeo Kanade},
title = {Dense 3D Face Alignment from 2D Videos in Real-Time},
year = {2015},
booktitle = {2015 11th IEEE International Conference and Workshops on Automatic Face and Gesture Recognition (FG)},
shortbooktitle={FG},
url = {http://zface.org}
}

and

László A. Jeni, Jeffrey F. Cohn, Takeo Kanade, Dense 3D face alignment from 2D video for real-time use, Image and Vision Computing, Volume 58, February 2017, Pages 13-24, ISSN 0262-8856, https://doi.org/10.1016/j.imavis.2016.05.009.

@article{Jeni16_ImaVis_ZFace,
author = {L{\'a}szl{\'o} A. Jeni and Jeffrey F. Cohn and Takeo Kanade},
title = "Dense 3D face alignment from 2D video for real-time use ",
journal = "Image and Vision Computing ",
volume = "58",
number = "",
pages = "13 - 24",
year = "2017",
note = "",
issn = "0262-8856",
doi = "https://doi.org/10.1016/j.imavis.2016.05.009",
url = {http://zface.org}
}


Structure of the SDK
--------------------

This version of ZFace uses OpenCV (www.opencv.org) and the OpenCV MATLAB wrapper (https://github.com/kyamagu/mexopencv) for its image processing (i.e. different types of warps, keypoint descriptors). As such you need a current version of OpenCV version > 2.4.0. The code has been tested on OpenCV 2.4.6 and up and the latest mexopencv wrapper. The compiled 64bit mexopencv is included in the "3rd_party" folder. If you like to recompile it, please refer to the documentation (https://github.com/kyamagu/mexopencv)

Folder structure:

+ 3rd_party                % 3rd party components
    +- arrow3D_pub         % 3D arrow display code
    +- mexopencv           % MATLAB OpenCV wrapper
+ opencv_2.4.11_x64_vc11_dlls % OpenCV dlls
+ test_images              % test images of different celebrities
+ test_video		   % test video 
+ ZFace_models             % tracking models
+ ZFace_src                % SDK source files


Using the SDK
-------------
The SDK is organized into classes. The CZFace class (located in \ZFace_Src\) is the central way we use the tracker. We can simply create an instance of the tracker:

zf = CZFace('.\ZFace_models\zf_ctrl49_mesh512.mat');

And track a given image "I":

[ ctrl2D, mesh2D, mesh3D, pars ] = zf.Fit( I, [] );

The current version of ZFace has the following output:

- ctrl2D: The 2D locations of the measured facial landmarks.
- mesh3D: The reconstructed dense 3D mesh in a canonical view (without rigid transformations).
- mesh2D: Projection of the 3D mesh to 2D.
- pars: Shape parameters, in the following order: 
        - (1) uniform scaling
        - (2-3) translation x, y direction
        - (4-6) headpose using Euler angles 
          pitch(4)-yaw(5)-roll(6) in radians
        - (7-) non-rigid PDM (Point Distribution Model)  
          parameters

For more details, please refer to the included demo files:
- Demo_Camera.m
- Demo_Images.m
- Demo_Video.m

The SDK uses the mexopencv wrapper (https://github.com/kyamagu/mexopencv). It has been compiled with the 64 bit OpenCV 2.4.11 for 64bit Windows. The dlls are in the ".\opencv_2.4.11_x64_vc11_dlls\" folder. They have to be included in the system path (start menu: environment variables -> sytem variables -> path).


Troubleshooting
---------------

If you are getting an "Invalid MEX-file" error from the mexopencv wrapper, try to re-compile it:

mexopencv.make("clean",true)
mexopencv.make