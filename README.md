# Automated Facial Affect Recognition(AFAR)
## Required
- [OpenCV](https://opencv.org/)
- [mexopencv](https://github.com/kyamagu/mexopencv)
- MATLAB add-on:
  - Deep Learning Toolbox Converter for ONNX Model Format
 
## Modules

### ZFace
**Folder structure**:

- 3rd_party  
    - arrow3D_pub: 3D arrow display code
    - mexopencv:MATLAB OpenCV wrapper
- opencv_2.4.11_x64_vc11_dlls: OpenCV dlls
- test_images: test images of different celebrities
- test_video: test video 
- ZFace_models: tracking models
- ZFace_src: SDK source files

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
### FETA


### AU Detector

This code uses output of FETA, which is run with the following parameters:
	- Resolution: 200
	- Interocular distance = 80

You can run the code on the sample video sample_video_norm.mp4 of size (200 x 200 x 3)

Probabilities of 12 AUs are saved to the file named sample_video_norm_result.mat

These AUs are: AU1, AU2, AU4, AU6, AU7, AU10, AU12, AU14, AU15, AU17, AU23 and AU24.

### AFAR Finetune

With this module, you can finetune pretained AU detector models trained on EB+ dataset. You can also obtain AU probabilities for frames/videos. Finetuning code and models can be found in AFAR_finetune/codes. You can run the following command:
```
python afar_finetune.py
```
We share two types of pretrained models:
- Model trained using the frames after mean frame of the video is subtracted
- Model trained using the raw frames

To finetune:

- Change train_mode = 1
- Extract frames of videos in your dataset.
- Prepare your train_txt_file that includes path + name of the frame and its AU labels in the given order: AU1, AU2, AU4, AU6, AU7, AU10, AU12, AU14, AU15, AU17, AU23 and AU24.
- If you want to use the model trained on mean subtracted frames, (i) compute mean frames of each video, (ii) save them under a folder and (iii) set mean_image_path that contains the mean frames of videos in your dataset to that folder.
Pretrained models will be saved to saved_models folder for each epoch.

To test a video:

- Change train_mode = 0
- Video_mode = 1
- Frames of the video will be tested in batches since for large videos all frames may not fit to GPU. Adjust video_test_batchsize parameter if the default is too large for your GPU.
- Set your video path (video_path) and video name (video_n)

To test your dataset using frames and a .txt file containing the paths and names of frames:
- Change train_mode = 0
- Video_mode = 0
- Precompute the scalar mean of your dataset (grayscale) and  assign grayscale_mean_of_dataset to this value.
- Set your test_txt_file and test_txt_file_name
- If you want to use the model trained on mean subtracted frames, (i) compute mean frames of each video, (ii) save them under a folder and (iii) set mean_image_path that contains the mean frames of videos in your dataset to that folder.


## Use AFAR GUI
Make sure run pipelineMain.m under the same path where
each module's folder is.
(That's the default module location. Otherwise you have 
to check and manually change the locations of 
ZFace/FETA/AUDetector directory)
