import ImageCrop as ImageCrop
import ImageFiltering as ImageFiltering
import Separate as Separate
import configparser
import sys


class PreprocessingMain():
    def __init__(self):
        self.config_file = 'C:\\Users\\ewqds\\Documents\\GitHub\\GDSC-2024-solution-challenge\\AI\\drugfill산출물\\drugfill산출물\\소스코드모음\\drugfill_preprocessing_source_code\\preprocessing\\config.ini'
            
    def main(self, argv):
        # ex) python3 PreProcessing.py circle config.ini
        if len(argv) == 3:
            self.config_file = argv[2]
            
        shape = argv[1]

        config = configparser.ConfigParser()
        config.read(self.config_file, encoding='UTF-8')

        self.ImgCrop = ImageCrop.ImageCrop(config['img_processing'])
        self.ImgFilter = ImageFiltering.ImageFiltering(config['img_processing'])
        self.Separate = Separate.Separate(config['img_processing'])
    

        """ Image Crop """
        self.ImgCrop.ImageProcess(shape)

        """ Image Filtering """
        self.ImgFilter.imgFiltering()
        
        """ Image Separte"""
        self.Separate.separateProcess()
	
        print('####### finish #######')


if __name__ == '__main__':
    main_class = PreprocessingMain()
    main_class.main(sys.argv)
        
