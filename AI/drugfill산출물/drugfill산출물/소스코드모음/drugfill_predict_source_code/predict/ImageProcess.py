import cv2
import numpy as np


class ImageProcess():
    def __init__(self):
        pass


    def ImageArea(self, input_image):
      rgba = cv2.imread(input_image, cv2.IMREAD_UNCHANGED)
      rgba = cv2.medianBlur(rgba, 55)

      imgray = cv2.cvtColor(rgba, cv2.COLOR_BGRA2GRAY)
      contours, _ = cv2.findContours(imgray, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
      contours_t = contours[0].transpose()

      right_point_x = np.max(contours_t[0])
      left_point_x = np.min(contours_t[0])
      right_point_y = np.max(contours_t[1])
      left_point_y = np.min(contours_t[1])

      return left_point_x, right_point_x, left_point_y, right_point_y
        

    def CropShape(self, input_image):
        left_x, right_x, left_y, right_y = self.ImageArea(input_image)
        crop_img = cv2.imread(input_image, cv2.IMREAD_UNCHANGED)
        crop_img = crop_img[left_y:right_y, left_x:right_x]
  
        trans_mask = crop_img[:,:,3]==0
        crop_img[trans_mask] = [255, 255, 255, 255]
        crop_img = cv2.cvtColor(crop_img, cv2.COLOR_BGRA2BGR)

        return crop_img
    
    
    def max_con_CLAHE(self, img):
        lab = cv2.cvtColor(img, cv2.COLOR_BGR2LAB)
        l, a, b = cv2.split(lab)
        
        clahe = cv2.createCLAHE(clipLimit=3.0, tileGridSize=(8,8))
        cl = clahe.apply(l)
        
        limg = cv2.merge((cl,a,b))
        img = cv2.cvtColor(limg, cv2.COLOR_LAB2BGR)
        
        return img
    
    



