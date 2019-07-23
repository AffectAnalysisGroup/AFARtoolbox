# Automated Facial Affect Recognition (AFAR)

Automated measurement of face and head dynamics, detection of facial action units and expression, and affect detection are crucial to multiple domains (e.g., health, education, entertainment). Commercial tools are available but costly and of unknown validity. Open-source ones lack user-friendly GUI for use by non-programmers. For both types, evidence of domain transfer and options for retraining for use in new domains typically are lacking. Deep approaches have two key advantages. They typically outperform shallow ones for facial affect recognition. And pre-trained models provided by deep approaches can be fine tuned with new datasets to optimize performance. AFAR is an open-source, deep-learning based, user-friendly tool for automated facial affect recognition. It consists of a pipeline having four components: (i) face tracking, ii) face registration, (iii) action unit (AU) detection and (iv) visualization. Moreover, finetuning component allows the interested users to finetune the pretrained AU detection models with their own dataset. AFAR has been used in comparative studies of action unit detectors [[1]](https://www.jeffcohn.net/wp-content/uploads/2019/07/BMVC2019_PAttNet.pdf.pdf), [[2]](http://www.jeffcohn.net/wp-content/uploads/2019/07/ACII2019_3DCNN.pdf) and to investigate cross-domain generalizability [[3]](https://ieeexplore.ieee.org/abstract/document/8756543), assess treatment response to deep brain stimulation (DBS) for treatment-resistant obsessive compulsive disorder [[4]](https://dl.acm.org/citation.cfm?id=3243023), and to explore facial dynamics in young children [[5]](https://journals.lww.com/prsgo/Fulltext/2019/01000/Dynamics_of_Face_and_Head_Movement_in_Infants_with.9.aspx) and in adults in treatment for depression [[6]](https://www.ncbi.nlm.nih.gov/pubmed/28278485) among other research.


![afar_pipeline](https://user-images.githubusercontent.com/12033328/61708950-15539700-ad1c-11e9-85a7-23d1db0475ac.png)

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

## Citation

If you use any of the resources provided on this page, please cite the pipeline paper and papers relevant to the components you used:

**Pipeline:**
```
@inproceedings{ertugrul2019afar,
  title={AFAR: A Deep Learning Based Tool for Automated Facial Affect Recognition},
  author={Onal Ertugrul, Itir and Jeni, L{\'a}szl{\'o} A and Ding, Wanqiao and Cohn, Jeffrey F},
  booktitle={2019 14th IEEE International Conference on Automatic Face \& Gesture Recognition (FG 2019)},
  year={2019},
  organization={IEEE}
}
```

**AU detector and AFAR finetune:**
```
@inproceedings{ertugrul2019cross,
  title={Cross-domain AU Detection: Domains, Learning Approaches, and Measures},
  author={Onal Ertugrul, Itir and Cohn, Jeffrey F and Jeni, L{\'a}szl{\'o} A and Zhang, Zheng and Yin, Lijun and Ji, Qiang},
  booktitle={2019 14th IEEE International Conference on Automatic Face \& Gesture Recognition (FG 2019)},
  year={2019},
  organization={IEEE}
}
```

**ZFace:**
```
@article{jeni2017dense,
  title={Dense 3d face alignment from 2d video for real-time use},
  author={Jeni, L{\'a}szl{\'o} A and Cohn, Jeffrey F and Kanade, Takeo},
  journal={Image and Vision Computing},
  volume={58},
  pages={13--24},
  year={2017},
  publisher={Elsevier}
}

@inproceedings{jeni2015dense,
  title={Dense 3D face alignment from 2D videos in real-time},
  author={Jeni, L{\'a}szl{\'o} A and Cohn, Jeffrey F and Kanade, Takeo},
  booktitle={2015 11th IEEE international conference and workshops on automatic face and gesture recognition (FG)},
  year={2015},
  organization={IEEE}
}
```

## Links to the papers
[Cross-domain AU detection: Domains, Learning Approaches, and Measures](https://www.jeffcohn.net/wp-content/uploads/2019/02/FG2019_cross_domain_final_version.pdf)

[AFAR: A Deep Learning Based Tool for Automated Facial Affect Recognition](https://www.jeffcohn.net/wp-content/uploads/2019/07/FG2019_demo_paper.pdf.pdf)

[Dense 3d face alignment from 2d video for real-time use](http://www.laszlojeni.com/pub/articles/Jeni16_ImaVis_ZFace.pdf)

[Dense 3D face alignment from 2D videos in real-time](http://www.laszlojeni.com/pub/articles/Jeni15FG_ZFace.pdf)

## Use AFAR GUI
Make sure run pipelineMain.m under the same path where
each module's folder is.
(That's the default module location. Otherwise you have 
to check and manually change the locations of 
ZFace/FETA/AUDetector directory)

## License
AFAR is freely available for free non-commercial use, and may be redistributed under these conditions. Please, see the [license](LICENSE) for further details. Interested in a commercial license? Please contact [Jeffrey Cohn](http://www.jeffcohn.net/).
