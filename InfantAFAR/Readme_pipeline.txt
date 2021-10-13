Steps to follow to obtain Infant AFAR AU detection results:

1) Run ZFace on videos using 49 markers.

2) Run FETA using resolution = 224 pixels and Interocular distance = 80 pixels
	- For "Input Videos", you should use a .txt file containing names of the videos (with their paths).
	- For "Tracking Files Folder" you should select the folder containing your ZFace outputs.
	- For "Output" you should select the folder you want your FETA outputs to be saved.
	- Tick "save normalized video" since it is required by AU detector. If you want to save landmarks and video with landmarks overlay, you can tick them as well.

3) Run Infant AFAR AU detector using the output videos of FETA to obtain AU detection probabilities. This code requires MATLAB 2018a or later version and Deep Learning Toolbox.
	- Update the "video_name" variable in the InfantAFAR_AUdetection.m with your own filename and run InfantAFAR_AUdetection.m 
	- AU probabilities are saved to "your_video_name".mat file
