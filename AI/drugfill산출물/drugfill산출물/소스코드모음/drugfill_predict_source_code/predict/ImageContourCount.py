import cv2
import numpy as np
import ImageSideProcess_circle as ImageProcess


class ImageContour():
    def __init__(self):
        self.m_cImageProcess = ImageProcess.ImageProcess()


    def ImageCanny(self, _inputImage, _option = 1):
        inputImage = self.m_cImageProcess.CropShape(_inputImage)
        
        inputImage = cv2.resize(inputImage, (200, 200), interpolation=cv2.INTER_LINEAR)

        if _option == 1: 
            filterImage = cv2.bilateralFilter(inputImage, 9, 75, 75)
            filterImage = cv2.medianBlur(filterImage, 7)
            filterImage = cv2.cvtColor(filterImage, cv2.COLOR_BGRA2BGR)
            clahe = self.m_cImageProcess.max_con_CLAHE(filterImage)
            canny = cv2.Canny(clahe, 50, 200)

        elif _option == 2:
            filterImage = cv2.bilateralFilter(inputImage, 9, 39, 39)
            filterImage = cv2.medianBlur(filterImage, 7)
            filterImage = cv2.cvtColor(filterImage, cv2.COLOR_BGRA2BGR)
            clahe = self.m_cImageProcess.max_con_CLAHE(filterImage)
            canny = cv2.Canny(clahe, 50, 100)

        return inputImage, canny


    def ContourCheck(self, _canny, _proportion):
        contours, _ = cv2.findContours(_canny, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
        canny = cv2.cvtColor(_canny, cv2.COLOR_GRAY2BGR)

        newContours = list()
        overContours = list()
        newContours.append(contours[0])
        maxLine = 0
        total_contour = []

        """ remove noise options """
        for line in range(len(contours)):
            total_contour.append(len(contours[line]))
            if len(contours[maxLine]) < len(contours[line]):
                maxLine = line

            if len(contours[line]) > 50 and len(contours[line]) < 500:
                newContours.append(contours[line])

            if len(contours[line]) > 500:
                overContours.append(contours[line])

        newContours[0] = contours[maxLine]
        
        """ exchange a wrong contour """
        for line in range(len(overContours)):
            if np.array_equal(newContours[0], overContours[line]):
                del overContours[line]
                break

        if self.CompareContours(newContours[0], canny, _proportion): # if True
            for line in range(len(overContours)):
                if self.CompareContours(overContours[line], canny, _proportion) == False:
                    newContours.insert(0, overContours[line])
                    break

        total_coordinate_cnt = self.PillSideCheck(newContours, canny, _proportion)

        return total_coordinate_cnt


    def CompareContours(self, _contour, _inputImage, _proportion):
        height, width, _ = _inputImage.shape
        rectRightX, rectLeftX = int(width - width//_proportion), int(width//_proportion)
        rectRightY, rectLeftY = int(height - height//_proportion), int(height//_proportion)

        coordinateCnt = 0
        contour = (_contour.transpose()).reshape(2, -1) # coordinates[0]: the array of X, coordinates[1]: the array of Y

        for coordinates in range(len(_contour)):
            if contour[0][coordinates] < rectRightX and contour[0][coordinates] > rectLeftX and contour[1][coordinates] < rectRightY and contour[1][coordinates] > rectLeftY:
                coordinateCnt += 1

        if coordinateCnt/len(_contour) > 0.5:
            result = True

        else:
            result = False

        return result


    def PillSideCheck(self, _contours, _inputImage, _proportion):
        contours = _contours[1:]
        total_coordinate_cnt = 0

        height, width, _ = _inputImage.shape
        rectRightX, rectLeftX = int(width - width//_proportion), int(width//_proportion)
        rectRightY, rectLeftY = int(height - height//_proportion), int(height//_proportion)

        for line in range(len(contours)):
            contour = (contours[line].transpose()).reshape(2, -1)
            coordinateCnt = 0

            for coordinates in range(len(contours[line])):
                if contour[0][coordinates] > rectLeftX and contour[0][coordinates] < rectRightX and contour[1][coordinates] > rectLeftY and contour[1][coordinates] < rectRightY:
                    coordinateCnt += 1

            total_coordinate_cnt += coordinateCnt

        return total_coordinate_cnt


    def Process(self, _openPath, _proportion):
        open_image = cv2.imread(_openPath, cv2.IMREAD_UNCHANGED)
        inputImages, canny = self.ImageCanny(open_image)
        total_coordinate_cnt = self.ContourCheck(canny, _proportion)
        
        return total_coordinate_cnt