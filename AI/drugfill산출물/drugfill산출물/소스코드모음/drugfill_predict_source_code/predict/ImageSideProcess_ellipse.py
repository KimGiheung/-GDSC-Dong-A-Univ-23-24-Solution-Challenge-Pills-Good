import cv2
import numpy as np
import math


class ImageProcess():
    def __init__(self):
        pass


    def ImageArea(self, _inputImage):
        rgba = cv2.medianBlur(_inputImage, 55)
        
        imgray = cv2.cvtColor(rgba, cv2.COLOR_BGRA2GRAY)
        contours, _ = cv2.findContours(imgray, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
        contoursT = contours[0].transpose()

        rightX = np.max(contoursT[0]) + 5
        leftX = np.min(contoursT[0]) - 5
        rigntY = np.max(contoursT[1]) + 5
        leftY = np.min(contoursT[1]) - 5

        return leftX, rightX, leftY, rigntY


    def CropShape(self, _inputImage):
        leftX, rightX, leftY, rightY = self.ImageArea(_inputImage)
        cropImage = _inputImage[leftY:rightY, leftX:rightX]

        return cropImage


    def CheckHorizontal(self, _inputImage):
        height, width, _ = _inputImage.shape

        matrix = cv2.getRotationMatrix2D((width/2, height/2), 90, 1)
        horizontalImage = cv2.warpAffine(_inputImage, matrix, (width, height))

        return horizontalImage


    def ChangeFlatten(self, _inputImage):
        rgba = cv2.medianBlur(_inputImage, 55)
        
        imgray = cv2.cvtColor(rgba, cv2.COLOR_BGRA2GRAY)
        contours, _ = cv2.findContours(imgray, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
        
        contoursT = contours[0].transpose()
        contoursT[0] = contoursT[0].flatten()
        contoursT[1] = contoursT[1].flatten()

        rightX = np.max(contoursT[0])
        leftX = np.min(contoursT[0])

        rightY = (contoursT[1].flatten())[(np.where(contoursT[0][0] == rightX))[0][0]]
        leftY = (contoursT[1].flatten())[(np.where(contoursT[0][0] == leftX))[0][0]]

        axisX = rightX - leftX
        axisY = rightY - leftY if rightX < leftX else leftY - rightY

        angle = math.degrees(math.atan(axisY/axisX))

        height, width, _ = _inputImage.shape
        matrix = cv2.getRotationMatrix2D((width/2, height/2), -angle, 1)
        flatten = cv2.warpAffine(_inputImage, matrix, (width, height))

        return flatten

    
    def max_con_CLAHE(self, img):
        lab = cv2.cvtColor(img, cv2.COLOR_BGR2LAB)
        l, a, b = cv2.split(lab)
        
        clahe = cv2.createCLAHE(clipLimit=3.0, tileGridSize=(8,8))
        cl = clahe.apply(l)

        limg = cv2.merge((cl,a,b))
        img = cv2.cvtColor(limg, cv2.COLOR_LAB2BGR)

        return img
