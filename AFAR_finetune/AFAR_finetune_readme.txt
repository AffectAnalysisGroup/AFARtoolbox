

We share two types of pretrained models:
Model trained using the frames after mean frame of the video is subtracted
Model trained using the raw frames

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
