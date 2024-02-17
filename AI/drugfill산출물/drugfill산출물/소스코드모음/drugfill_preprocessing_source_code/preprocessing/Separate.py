import os
import shutil
from PIL import Image


class Separate():
    def __init__(self, config):
        '''
        filter_folder_path : filter image save path
        folder_save_path : traing/validation/traing separate image folder save path
        '''

        self.open_path = config['rotate_path']
        self.save_path = config['separate_path']


    def FolderList(self):        
        type_list = []
        folder_list = []
        
        for (path, folder, files) in os.walk(self.open_path):
            type_list.append(path)
            folder_list.append(folder)
            
        folders = ','.join(folder_list[0])
        folder_list = folders.split(',')
        type_list.pop(0)

        return folder_list


    def makeSubfolder(self, new_dir_path, folder_list):
        for num in range(len(folder_list)):
            os.makedirs(new_dir_path + folder_list[num])
      
    
    def ml_directory(self, folder_list):        
        if not os.path.exists(self.save_path + 'training'):
            os.makedirs(self.save_path + 'training')
            self.makeSubfolder(self.save_path + 'training/', folder_list)
            
        if not os.path.exists(self.save_path + 'testing'):
            os.makedirs(self.save_path + 'testing')
            self.makeSubfolder(self.save_path + 'testing/', folder_list)
            
        if not os.path.exists(self.save_path + 'validation'):
            os.makedirs(self.save_path + 'validation')
            self.makeSubfolder(self.save_path + 'validation/', folder_list)
    
    
    def separate(self, dir_path, x):
        dirname = self.open_path + x
        filenames = os.listdir(dirname)
        i = 0
        for filename in filenames:
            full_filename = os.path.join(dirname, filename)
    
            with Image.open(full_filename) as image:
                if i % 10 < 7:
                    training_directory = os.path.join(dir_path + 'training/', x)
                    shutil.copyfile(full_filename, os.path.join(training_directory, filename))
                    
                elif i % 10 >= 7 and i % 10 < 8:
                    validation_directory = os.path.join(dir_path + 'testing/', x)
                    shutil.copyfile(full_filename, os.path.join(validation_directory, filename))
                    
                else:
                    testing_directory = os.path.join(dir_path + 'validation/', x)
                    shutil.copyfile(full_filename, os.path.join(testing_directory, filename))
            i = i + 1


    def separateProcess(self):
        folder_list = self.FolderList()
        self.ml_directory(folder_list)
       
        for x in folder_list:
            self.separate(self.save_path, x)
     
