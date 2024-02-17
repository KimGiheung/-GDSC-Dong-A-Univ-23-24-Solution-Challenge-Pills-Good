import cv2 
import numpy as np
import os 


class ImageCrop():
    def __init__(self, config):
        '''
        open_path : original image open path
        save_path : crop image save path
        rotate_path : rotate image save path
        rotation_angle_circle : circle rotation angle
        rotation_angle_ellipse : ellipse rotation angle
        '''
        
        self.open_path = config['open_path']
        self.save_path = config['save_path']
        self.rotate_path = config['rotate_path']
        self.rotate_angle_circle = int(config['rotation_angle_circle'])
        self.rotate_angle_ellipse = int(config['rotation_angle_ellipse'])
        
        # Permission Error retry another path
        self.error_path_crop = './crop'
        self.error_path_rotation = './rotation'
        
        # dir index setting
        self.start_dir = config['start_dir_idx']
        self.end_dir = config['end_dir_idx']

        
    # square four point return 
    def ImageArea(self, input_image):
        rgba = cv2.medianBlur(input_image, 55)
    
        imgray = cv2.cvtColor(rgba, cv2.COLOR_BGRA2GRAY)
        contours, _ = cv2.findContours(imgray, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)

        contours_t = contours[0].transpose()
    
        right_point_x = np.max(contours_t[0])
        left_point_x = np.min(contours_t[0])
        right_point_y = np.max(contours_t[1])
        left_point_y = np.min(contours_t[1])
    
        return left_point_x, right_point_x, left_point_y, right_point_y
    
    
    # image crop
    def CropShape(self, input_image):
        left_x, right_x, left_y, right_y = self.ImageArea(input_image)
        crop_img = input_image[left_y:right_y, left_x:right_x]
            
        return crop_img
        
        
    # circle image rotation
    def rotate_image_circle(self, save_rotate_img, input_image):
        i = 0
        height, width, channel = input_image.shape
    
        while i < 360:
            f_path = save_rotate_img + '_' + str(i) + '.png'
            if not os.path.isfile(f_path):
                matrix = cv2.getRotationMatrix2D((width/2, height/2), i, 1)
                dst = cv2.warpAffine(input_image, matrix, (width, height))
                dst = self.CropShape(dst)
 
                cv2.imwrite(f_path, dst)
            else:
                print('rotate file exits : ', f_path)
            
            i = i + self.rotate_angle_circle
    
    
    # ellipse image rotation
    def rotate_image_ellipse(self, save_rotate_img, input_image):
        i = 0
        height, width, channel = input_image.shape
    
        while i < 360:
            if (i < 30) or (150 < i and i < 210) or (330 < i):
                f_path = save_rotate_img + '_' + str(i) + '.png'
                if not os.path.isfile(f_path):
                    matrix = cv2.getRotationMatrix2D((width/2, height/2), i, 1)
                    dst = cv2.warpAffine(input_image, matrix, (width, height))
                    dst = self.CropShape(dst)

                    cv2.imwrite(f_path, dst)
                else:
                    print('rotate file exits : ', f_path)

            i = i + self.rotate_angle_ellipse
    
    
    # image crop and rotation process
    def ImageProcess(self, shape):
        or_dirnames = os.listdir(self.open_path)

        if( int(self.start_dir) == -1 ):
            dirnames = or_dirnames
        else:
            dirnames = or_dirnames[int(self.start_dir):int(self.end_dir)]

        for dir in dirnames:
            try_num = 0            
            # try
            try:
                # not exists folder in path, make folder
                if not os.path.exists(self.save_path + dir):
                    os.makedirs(self.save_path + '/' + dir)
    
                if not os.path.exists(self.rotate_path + dir):
                    os.makedirs(self.rotate_path + '/' + dir)
                try_num = 1
                    
            except PermissionError:
                if not os.path.exists(self.error_path_crop + dir):
                    os.makedirs(self.error_path_crop + '/' + dir)
                    print("PermissionError except, image save path: ", self.error_path_crop)
    
                if not os.path.exists(self.error_path_rotation + dir):
                    os.makedirs(self.error_path_rotation + '/' + dir)
                    print("PermissionError except, image save path: ", self.error_path_rotation)
                try_num = 2
            
            except IOError as e:
                print("IOError except: ", e.errno)
                
            open_folder_path = os.path.join(self.open_path, dir)
            if try_num == 1:    
                save_folder_path = os.path.join(self.save_path, dir)
                rotate_folder_path = os.path.join(self.rotate_path, dir)
            elif try_num == 2:
                save_folder_path = os.path.join(self.error_path_crop, dir)
                rotate_folder_path = os.path.join(self.error_path_rotation, dir)
    
            for path, folder, files in os.walk(open_folder_path):
    
                for file in files:
                    input_image = open_folder_path + '/' + file
    
                    print(input_image)
    
                    save_image = save_folder_path + '/' + file[0:len(file)-3] + 'png'
                    input_image = cv2.imread(input_image, cv2.IMREAD_UNCHANGED)
                    
                    '''image crop'''
                    if not os.path.isfile(save_image):
                        crop_img = self.CropShape(input_image)
                        cv2.imwrite(save_image, crop_img)
                    else:
                        print( 'crop image file exits : ', save_image)
    
                    '''rotation'''
                    save_rotate_img = rotate_folder_path + '/' + file[0:len(file)-4]
                    
                    if shape == 'circle':
                        self.rotate_image_circle(save_rotate_img, input_image)
                    elif shape == 'ellipse':
                        self.rotate_image_ellipse(save_rotate_img, input_image)
