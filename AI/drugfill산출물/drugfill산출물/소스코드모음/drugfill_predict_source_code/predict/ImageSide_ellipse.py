import cv2
import numpy as np
import ImageSideProcess_ellipse as ImageProcess


class ImageContour():
    def __init__(self):
        self.m_cImageProcess = ImageProcess.ImageProcess()


    def ImageCanny(self, _inputImage, _option = 1):
        inputImage = cv2.cvtColor(_inputImage, cv2.COLOR_BGRA2BGR)
        inputImage = cv2.resize(inputImage, dsize=(0, 0), fx=0.5, fy=0.5, interpolation=cv2.INTER_LINEAR)

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

        return canny, filterImage


    def ContourCheck(self, _canny, _proportion):
        _proportion = int(_proportion)
        height, width = _canny.shape
        try:
            contours, _ = cv2.findContours(_canny, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
            canny = cv2.cvtColor(_canny, cv2.COLOR_GRAY2BGR)

            newContours = list()
            overContours = list()
            newContours.append(contours[0])
            maxLine = 0
            aSide = width//2
            bSide = height//2
            
            circumference = 2*np.pi*np.sqrt((np.square(aSide) + np.square(bSide))/2)
            largeRange = round(circumference*0.7)
            smallRange = round(circumference*0.08)
            
            for line in range(len(contours)):
                if len(contours[maxLine]) < len(contours[line]):
                    maxLine = line
        
                if len(contours[line]) > smallRange:
                    newContours.append(contours[line])
        
                if len(contours[line]) > largeRange:
                    overContours.append(contours[line])
        
            newContours[0] = contours[maxLine]
            
            for line in range(len(overContours)):
                if np.array_equal(newContours[0], overContours[line]):
                    del overContours[line]
                    break
        
            if self.CompareContours(newContours[0], canny, _proportion):
                for line in range(len(overContours)):
                    if self.CompareContours(overContours[line], canny, _proportion) == False:
                        newContours.insert(0, overContours[line])
                        break
        
            imageContours = cv2.drawContours(canny, newContours[1:], -1, (0, 255, 0), 2) # drew contour with green

            height, width, _ = imageContours.shape
            yellowColor = (0, 255, 255)
            blueColor = (255, 100, 0)
            imageContours = cv2.rectangle(imageContours, (width//_proportion, height//_proportion), (width-width//_proportion, height-height//_proportion), yellowColor, 2)
            imageContours = cv2.rectangle(imageContours, (int(width/2.4), height), (int(width-width/2.4), height-height), blueColor, 2)
            
            imageContours = cv2.drawContours(imageContours, newContours[0], -1, (0, 0, 255), 2) # draw shape with red
            
            sideInfo, new_contours, total_coordinate_cnt = self.PillSideCheck(newContours, imageContours, _proportion)
        
        except IndexError as e:
            imageContours = np.zeros(1)
            sideInfo = 'IndexError'
            new_contours = np.zeros(1)
            total_coordinate_cnt = 0
    
        return imageContours, sideInfo, new_contours, total_coordinate_cnt


    def CompareContours(self, _contour, _inputImage, _proportion):
        height, width, _ = _inputImage.shape
        
        rectRightX, rectLeftX = width-width//_proportion, width//_proportion
        rectRightY, rectLeftY = height-height//_proportion, height//_proportion
        
        coordinateCnt = 0
        contour = (_contour.transpose()).reshape(2, -1)

        for coordinates in range(len(_contour)):
            if contour[0][coordinates] < rectRightX and contour[0][coordinates] > rectLeftX and contour[1][coordinates] < rectRightY and contour[1][coordinates] > rectLeftY:
                coordinateCnt += 1

        if coordinateCnt/len(_contour) > 0.5:
            result = True

        else:
            result = False

        return result


    def FindVertical(self, imageContours, contours, _proportion):
        height, width, _ = imageContours.shape

        mid_rectRightX, mid_rectLeftX = int(width-width/2.4), int(width/2.4)
        mid_rectRightY, mid_rectLeftY = height, height - height

        new_contours = list()

        for line in contours:
            contour = (line.transpose()).reshape(2, -1)

            v_contour = [[],[]]
            for coordinate in range(len(line)):
                if contour[0][coordinate] > mid_rectLeftX and contour[0][coordinate] < mid_rectRightX and contour[1][coordinate] > mid_rectLeftY and contour[1][coordinate] < mid_rectRightY:
                    v_contour[0].append(contour[0][coordinate])
                    v_contour[1].append(contour[1][coordinate])

            if len(v_contour[0]) == 0:
                new_contours.append(line)
                
        return new_contours


    def PillSideCheck(self, _contours, _inputImage, _proportion):
        oneside = "ONESIDE" 
        both = "BOTH"

        contours = _contours[1:]
        total_coordinate_cnt = 0

        if len(contours) == 0:
            sideInfo = oneside
            coordinateCnt = 0
            new_contours = contours
            
        else:
            sideInfo = oneside
        
            height, width, _ = _inputImage.shape
            rectRightX, rectLeftX = width - width//_proportion, width//_proportion
            rectRightY, rectLeftY = height - height//_proportion, height//_proportion
            
            new_contours = self.FindVertical(_inputImage, contours, _proportion)

            fin_contour = []
            result_list = []
            for line in range(len(new_contours)):
                contour = (new_contours[line].transpose()).reshape(2, -1)
                coordinateCnt = 0
                coordinateCnt_total = len(contour[0])
                
                for coordinate in range(len(new_contours[line])):
                    if contour[0][coordinate] > rectLeftX and contour[0][coordinate] < rectRightX and contour[1][coordinate] > rectLeftY and contour[1][coordinate] < rectRightY:
                        coordinateCnt += 1    
                    
                total_coordinate_cnt += coordinateCnt

                if coordinateCnt/coordinateCnt_total == 1.0:
                    fin_contour.append(new_contours[line])
                    result_list.append('both')
                else:
                    result_list.append('oneside')
                
            if 'both' in result_list:
                sideInfo = both

        return sideInfo, fin_contour, total_coordinate_cnt


    def Process(self, _openPath, _proportion):
        inputImage = cv2.imread(_openPath, cv2.IMREAD_UNCHANGED)
        '''make flatten'''
        cropImage = self.m_cImageProcess.CropShape(inputImage)

        '''check horizontal'''
        height, width, _ = cropImage.shape
        if height > width:
            inputImage = self.m_cImageProcess.CheckHorizontal(inputImage)

        flatten = self.m_cImageProcess.ChangeFlatten(inputImage)
        flatten = self.m_cImageProcess.ChangeFlatten(flatten)
        cropImage = self.m_cImageProcess.CropShape(flatten)

        '''get ellipse contour routine'''
        canny, _ = self.ImageCanny(cropImage)
        imageContours, sideInfo, new_contours, total_coordinate_cnt = self.ContourCheck(canny, _proportion)

        '''if sideInfo is ONESIDE, try option2'''
        if sideInfo == 'ONESIDE':
            canny, _ = self.ImageCanny(cropImage, 2)
            imageContours, sideInfo, new_contours, total_coordinate_cnt = self.ContourCheck(canny, _proportion)

        return imageContours, sideInfo, total_coordinate_cnt
