import torch
import os
import torch.nn as nn
import torchvision
import torchvision.transforms as transforms
from torch.utils.data import Dataset
from torchvision import datasets
import pandas as pd
from PIL import Image
import pickle
import sys
import argparse
import numpy as np
import scipy.io as sio


# Device configuration
device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')

torch.manual_seed(1)
torch.cuda.manual_seed(1)
torch.cuda.manual_seed_all(1)

# Hyper parameters
num_epochs = 2
num_classes = 12
batch_size = 100
learning_rate = 0.001
mean_subtract_flag = 1
train_mode = 0
video_mode = 1

aus = [1, 2, 4, 6, 7, 10, 12, 14, 15, 17, 23, 24]

# If mean_subtract_flag == 1 and video_mode ==0
grayscale_mean_of_dataset = 0.34
mean_image_path = '../sample_mean_data/'
# If train_mode == 1
model_save_path = '../saved_models/'
train_txt_file = '../sample_txt/sample_train.txt'


# If train_mode == 0
output_path = '../outputs_video_mat/'
test_txt_file_name = 'sample_test.txt'
test_txt_file = '../sample_txt/' + test_txt_file_name

# If video_mode = 1 and train_mode == 0
video_path = '../sample_video/'
video_n = 'F040_01_norm.mp4'
video_test_batchsize = 100



def rgb2gray(rgb):
    return np.dot(rgb[..., :3], [0.299, 0.587, 0.114])

######################################## Data loader from video ######################################################
def load_mydata_video(filename):

    import imageio
    import cv2

    cap = cv2.VideoCapture(filename)
    num_elem = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    #print(num_elem)
    x_test = np.zeros((num_elem, 1, 200, 200))

    vid = imageio.get_reader(filename, 'ffmpeg')

    for num in range(0, num_elem):
        image = vid.get_data(num)
        image = rgb2gray(image)
        #print image.shape
        x_test[num] = np.expand_dims(image, axis=0)

    x_test = x_test.astype('float16') / 255.

    if  mean_subtract_flag == 1:
        video_mean = np.mean(x_test, axis=0)
        print(video_mean.shape)
        x_test = x_test - video_mean
    else:
        video_mean_scalar = np.mean(x_test)
        x_test = x_test - video_mean_scalar
    return x_test

########################################## Data loader from file ######################################################
class FaceDataset(Dataset):
    """Face Landmarks dataset."""

    def __init__(self, txt_file, mean_image_path=None, transform=None):

        with open(txt_file) as f:
            list_content = f.readlines()
        list_content = [x.strip() for x in list_content]
        self.list_content = list_content

        self.labels_frame = pd.read_csv(txt_file, header=None)
        self.mean_image_path = mean_image_path
        self.transform = transform

    def __len__(self):
        return len(self.labels_frame)

    def __getitem__(self, idx):
        splitted = self.list_content[idx].split('\t')
        img_name = splitted[0]
        label = np.asarray(splitted[1:]).astype('float')

        image = Image.open(img_name)
        image = image.convert('L')
        sp = img_name.split('/')

        if self.transform:
            image = self.transform(image)

        if self.mean_image_path:
            #print('aaa')
            mean_image_name = os.path.join(self.mean_image_path + sp[-2] + '.png')
            mean_image = Image.open(mean_image_name)
            mean_image = mean_image.convert('L')
            if self.transform:
                mean_image = self.transform(mean_image)

            image = image - mean_image
        return image, label


dataset_transform = transforms.Compose([
    transforms.ToTensor(),
])

dataset_transform_no_mean_sub = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize((grayscale_mean_of_dataset,), (1.,))
])


############################################# Convolutional neural network  ###############################
class ConvNet_nodr(nn.Module):
    def __init__(self, num_classes=12):
        super(ConvNet_nodr, self).__init__()
        self.layer1 = nn.Sequential(
            nn.Conv2d(1, 64, kernel_size=5, stride=2),
            nn.BatchNorm2d(64),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2))
        self.layer2 = nn.Sequential(
            nn.Conv2d(64, 128, kernel_size=5, stride=1),
            nn.BatchNorm2d(128),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2))
        self.layer3 = nn.Sequential(
            nn.Conv2d(128, 128, kernel_size=5, stride=1),
            nn.BatchNorm2d(128),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2))
        # self.fc1 = nn.Linear(2048, 400)
        self.fc1 = nn.Linear(10368, 400)
        self.fc2 = nn.Linear(400, num_classes)


    def forward(self, x):
        out = self.layer1(x)
        out = self.layer2(out)
        out = self.layer3(out)
        out = out.reshape(out.size(0), -1)
        out = self.fc1(out)
        out = self.fc2(out)
        return out

########################################## Train - Test #####################################################
if train_mode == 1:

    if mean_subtract_flag == 1:
        face_train_dataset = FaceDataset(
            txt_file=train_txt_file,
        mean_image_path=mean_image_path, transform=dataset_transform)
    elif mean_subtract_flag == 0:
        face_train_dataset = FaceDataset(
            txt_file=train_txt_file,
        transform=dataset_transform_no_mean_sub)

    face_train_loader = torch.utils.data.DataLoader(face_train_dataset, batch_size=batch_size, shuffle=True)


    if mean_subtract_flag == 1:
        model = ConvNet_nodr(num_classes).to(device)
        model.load_state_dict(
            torch.load('model_mean_sub.pt'))
    else:
        model = ConvNet_nodr(num_classes).to(device)
        model.load_state_dict(torch.load('model_no_mean_sub.pt'))

    # Loss and optimizer
    criterion = nn.BCEWithLogitsLoss()
    optimizer = torch.optim.SGD(model.parameters(), lr=learning_rate, momentum=0.9)

    model.train()
    # Train the model
    total_step = len(face_train_loader)
    for epoch in range(num_epochs):
        for i, (images, labels) in enumerate(face_train_loader):
            images = images.to(device)
            labels = labels.type(torch.FloatTensor).to(device)

            # Forward pass
            outputs = model(images)
            loss = criterion(outputs, labels)

            # Backward and optimize
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

            if (i + 1) % 100 == 0:
                print('Epoch [{}/{}], Step [{}/{}], Loss: {:.4f}'
                      .format(epoch + 1, num_epochs, i + 1, total_step, loss.item()))
        if not os.path.exists(model_save_path):
            os.makedirs(model_save_path)
        torch.save(model.state_dict(), model_save_path + '/model_' + 'epoch' + str(epoch + 1) + '.pt')
else:
    if video_mode == 1: # testing with a video

            # Load model
            if mean_subtract_flag ==1:
                model = ConvNet_nodr(num_classes).to(device)
                model.load_state_dict(torch.load('model_mean_sub.pt'))
                
            else:
                model = ConvNet_nodr(num_classes).to(device)
                model.load_state_dict(torch.load('model_no_mean_sub.pt'))

            video_name = video_path + video_n
            sp = video_n.split('.')
            fname = sp[0]

            # Test the model
            model.eval()  # eval mode
            with torch.no_grad():

                all_est = torch.cuda.FloatTensor()
                images = load_mydata_video(video_name)
                #print(images.shape)
                for i in range(0,images.shape[0],video_test_batchsize):
                    if i+video_test_batchsize < images.shape[0]:
                        max_lim = i+video_test_batchsize
                    else:
                        max_lim = images.shape[0]
                    images_chunk = torch.from_numpy(images[i:int(max_lim)])
                    images_chunk = images_chunk.type(torch.FloatTensor).to(device)

                    outputs = model(images_chunk)
                    outputs = torch.sigmoid(outputs)
                    all_est = torch.cat((all_est, outputs), 0)

                all_est = all_est.data.cpu().numpy()
                if not os.path.exists(output_path + 'video_mode' + str(video_mode) + '/' + fname):
                    os.makedirs(output_path + 'video_mode' + str(video_mode) + '/' + fname)
                sio.savemat(output_path + 'video_mode' + str(video_mode) + '/' + fname + '/' + 'results_meansub' + str(mean_subtract_flag) + '.mat',
                                {'all_est': all_est})
    else: # testing with frames and a .txt file
        if mean_subtract_flag == 1:
            face_test_dataset = FaceDataset(
                txt_file=test_txt_file,
                mean_image_path=mean_image_path, transform=dataset_transform)
        elif mean_subtract_flag == 0:
            face_test_dataset = FaceDataset(
                txt_file=test_txt_file,
                transform=dataset_transform_no_mean_sub)

        face_test_loader = torch.utils.data.DataLoader(face_test_dataset, batch_size=batch_size, shuffle=False)

        if mean_subtract_flag == 1:
            model = ConvNet_nodr(num_classes).to(device)
            model.load_state_dict(
                torch.load('model_mean_sub.pt'))
        else:
            model = ConvNet_nodr(num_classes).to(device)
            model.load_state_dict(torch.load('model_no_mean_sub.pt'))
        sp = test_txt_file_name.split('.')
        fname = sp[0]

        # Test the model
        model.eval()  # eval mode
        with torch.no_grad():

            all_gt = torch.cuda.FloatTensor()
            all_est = torch.cuda.FloatTensor()
            for images, labels in face_test_loader:
                images = images.to(device)
                labels = labels.type(torch.FloatTensor).to(device)
                labels[labels == -1] = 0
                all_gt = torch.cat((all_gt, labels), 0)
                outputs = model(images)
                outputs = torch.sigmoid(outputs)
                all_est = torch.cat((all_est, outputs), 0)

            all_gt = all_gt.data.cpu().numpy()
            all_est = all_est.data.cpu().numpy()
            if not os.path.exists(output_path + 'video_mode' + str(video_mode) + '/' + fname):
                os.makedirs(output_path + 'video_mode' + str(video_mode) + '/' + fname)
            sio.savemat(output_path + 'video_mode' + str(video_mode) + '/' + fname + '/' + 'results_meansub' + str(mean_subtract_flag) + '.mat',
                        {'all_est': all_est, 'all_gt': all_gt})

