import torch
import PyTorchModel as PyTorchModel
import PyTorchData as PyTorchData
import configparser
import torch.nn as nn


class PyTorchMain():
    def __init__(self):
        config = configparser.ConfigParser()
        config.read('./config_hexagon.ini', encoding='UTF-8')

        self.m_Device = 'cuda' if torch.cuda.is_available() else 'cpu'

        self.m_cPytorchModel = PyTorchModel.PillModel(config['PT_model_info'])

        self.m_cPytorchData = PyTorchData.PyTorchData("image", config['PT_model_info'])

        self.m_cMakeModel = PyTorchModel.MakeModel(config['PT_model_info'])


    def main(self):
        print("\n[ Model ]\n")
        model = self.m_cPytorchModel.to(self.m_Device)
        print(model)

        # load dataset 
        print("\n[ Data ]\n")
        trainData = self.m_cPytorchData.ImageTrain()
        valData = self.m_cPytorchData.ImageValidation()
        testData = self.m_cPytorchData.ImageTest()

        # training
        print("\n[ Training ]\n")
        ret = self.m_cMakeModel.Training(_device = self.m_Device,
                                         _model = model,
                                         _trainData = trainData,
                                         _valData = valData)
        if ret == 0 or ret == 1:
            # testing
            print("\n[ Testing ]\n")
            self.m_cMakeModel.Testing(_device = self.m_Device,
                                      _model = model,
                                      _testData = testData)


if __name__ == '__main__':
    mainClass = PyTorchMain()
    mainClass.main()
