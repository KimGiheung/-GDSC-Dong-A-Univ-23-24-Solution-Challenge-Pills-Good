import torchvision
from torch.utils.data import Dataset, DataLoader
from torchvision import transforms, utils

# image file truncated error prevention
from PIL import ImageFile
ImageFile.LOAD_TRUNCATED_IMAGES = True

class PyTorchData():
    def __init__(self, _dataType, config):
        '''
        input_dim : image size
        data_path : training data path
        batch_size : batch size
        '''
        
        if _dataType == "data":
            self.m_DataDim = int(config['input_dim'])
        elif _dataType == "image":
            self.m_ImageDim = int(config['input_dim'])
            self.m_DataPath = config['data_path']
            self.m_BatchSize = int(config['batch_size'])


    def ImageTrain(self):
        transDatagen = transforms.Compose([transforms.Resize((self.m_ImageDim, self.m_ImageDim)),
                                           transforms.ToTensor()])

        trainPath = self.m_DataPath + '/training'
        trainFolder = torchvision.datasets.ImageFolder(root = trainPath,
                                                       transform = transDatagen)

        trainLoader = DataLoader(trainFolder,
                                batch_size = self.m_BatchSize,
                                shuffle = True)

        print("Train Class [", trainLoader.dataset.class_to_idx, "]")
        print("Train Numbers [", len(trainLoader.dataset.imgs), "]")
        print("Train Batch Size [", trainLoader.batch_size, "]")

        return trainLoader


    def ImageValidation(self):
        transDatagen = transforms.Compose([transforms.Resize((self.m_ImageDim, self.m_ImageDim)),
                                           transforms.ToTensor()])

        validationPath = self.m_DataPath + '/validation'
        validationSet = torchvision.datasets.ImageFolder(root = validationPath,
                                                         transform = transDatagen)

        validationLoader = DataLoader(validationSet,
                                      batch_size = self.m_BatchSize,
                                      shuffle = False)

        print("Validation Class [", validationLoader.dataset.class_to_idx, "]")
        print("Validation Numbers [", len(validationLoader.dataset.imgs),"]")
        print("Validation Batch Size [", validationLoader.batch_size,"]")

        return validationLoader

        
    def ImageTest(self):
        transDatagen = transforms.Compose([transforms.Resize((self.m_ImageDim, self.m_ImageDim)),
                                           transforms.ToTensor()])

        testDirectory = self.m_DataPath + '/testing'
        testSet = torchvision.datasets.ImageFolder(root = testDirectory,
                                                   transform = transDatagen)

        testLoader = DataLoader(testSet,
                                batch_size = self.m_BatchSize,
                                shuffle = False)

        print("Test Class [", testLoader.dataset.class_to_idx, "]")
        print("Test Numbers [", len(testLoader.dataset.imgs), "]")
        print("Test Batch Size [", testLoader.batch_size,"]")

        return testLoader