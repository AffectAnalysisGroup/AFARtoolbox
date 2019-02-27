# Automated Facial Affect Recognition(AFAR)
## Required
- [OpenCV](https://opencv.org/)
- [mexopencv](https://github.com/kyamagu/mexopencv)
- MATLAB add-on:
  - Deep Learning Toolbox Converter for ONNX Model Format
  - Deep Learning Toolbox Importer for Tensorflow-Keras Model

## Modules

###### ZFace
**Folder structure**:

- 3rd_party                % 3rd party components
    - arrow3D_pub         % 3D arrow display code
    - mexopencv           % MATLAB OpenCV wrapper
- opencv_2.4.11_x64_vc11_dlls % OpenCV dlls
- test_images              % test images of different celebrities
- test_video		   % test video 
- ZFace_models             % tracking models
- ZFace_src                % SDK source files


**Using the SDK**
The SDK is organized into classes. The CZFace class (located in \ZFace_Src\) is the central way we use the tracker. We can simply create an instance of the tracker:
```
zf = CZFace('.\ZFace_models\zf_ctrl49_mesh512.mat');
```
And track a given image "I":
```
[ ctrl2D, mesh2D, mesh3D, pars ] = zf.Fit( I, [] );
```
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


**Troubleshooting**
If you are getting an "Invalid MEX-file" error from the mexopencv wrapper, try to re-compile it:
```
mexopencv.make("clean",true)
mexopencv.make
```
###### FETA


###### AU Detector


## Use AFAR GUI
Make sure run pipelineMain.m under the same path where
each module's folder is.
(That's the default module location. Otherwise you have 
to check and manually change the locations of 
ZFace/FETA/AUDetector directory)
