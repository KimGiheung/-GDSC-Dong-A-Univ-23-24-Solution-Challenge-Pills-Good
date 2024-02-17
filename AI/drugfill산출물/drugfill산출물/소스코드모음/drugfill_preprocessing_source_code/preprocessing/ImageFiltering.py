import cv2
import os
import errno


class ImageFiltering():
    def __init__(self, config):
        '''
        rotate_path : rotate image save path
        filter_path : filter image save path
        '''
        
        self.origin_folder_path = config['rotate_path']
        self.filter_folder_path = config['filter_path']
        
        # Permission Error retry another path
        self.error_path_filter = './filter'


    # make white background
    def white_Background(self, img):
        trans_mask = img[:,:,3]==0
        img[trans_mask] = [255, 255, 255, 255]
        img = cv2.cvtColor(img, cv2.COLOR_BGRA2BGR)
    
        return img


    # filter
    def max_con_CLAHE(self, img):
        # Converting image to LAB Color model
        lab = cv2.cvtColor(img, cv2.COLOR_BGR2LAB)
        l, a, b = cv2.split(lab)
    
        # Applying CLAHE to L-channel
        clahe = cv2.createCLAHE(clipLimit=3.0, tileGridSize=(8,8))
        cl = clahe.apply(l)
    
        # Merge the CLAHE enhanced L-channel with the a and b channel
        limg = cv2.merge((cl,a,b))
    
        # Converting image from LAB Color model to RGB model
        img = cv2.cvtColor(limg, cv2.COLOR_LAB2BGR)
    
        return img
   
    # if image open fail, write log of fail image full path
    def tracelog(self, text):
        if text != "":
            text += "\n"
            f = open("tracelog.log","a") 
            f.write(text)
            f.close()

    
    # filtering processing
    def imgFiltering(self):   
        dirnames = os.listdir(self.origin_folder_path)
        
        for filename in dirnames:
            try_num = 0
            try:
                if not os.path.exists(self.filter_folder_path + filename):
                    os.makedirs(self.filter_folder_path + filename)
                try_num = 1
                
            except PermissionError:
                if not os.path.exists(self.error_path_filter + filename):
                    os.makedirs(self.error_path_filter + filename)
                    print("PermissionError except, image save path: ", self.error_path_filter)
                try_num = 2
            
            except IOError as e:
                print("IOError except: ", e.errno)
            
            origin_file_path = os.path.join(self.origin_folder_path, filename)
            if try_num == 1:
                filter_file_path = os.path.join(self.filter_folder_path, filename)
            elif try_num == 2:
                filter_file_path = os.path.join(self.error_path_filter, filename)
                
            for path, folder, files in os.walk(origin_file_path):
    
                for file in files:
                    print(filter_file_path+'/' + file)
                    print("origin path : ", origin_file_path +'/'+ file)
                    
                    # file check
                    save_path = filter_file_path + '/' + file[0:len(file)-4] + '.jpg'
                    if os.path.isfile(save_path):
                        print("filter file exists : {}".format(save_path))
                        continue

                    img = cv2.imread(origin_file_path +'/'+ file, cv2.IMREAD_UNCHANGED)

                    # image check
                    if img is None:
                        self.tracelog(origin_file_path +'/'+ file)
                        print('typecheck ', type(img))
                        continue
                    
                    ''' white background '''
                    img = self.white_Background(img)
                    
                    ''' default filter '''
                    img = self.max_con_CLAHE(img)
                    img = self.max_con_CLAHE(img)
                    
                    ''' filtering image save '''
                    cv2.imwrite(save_path , img)
