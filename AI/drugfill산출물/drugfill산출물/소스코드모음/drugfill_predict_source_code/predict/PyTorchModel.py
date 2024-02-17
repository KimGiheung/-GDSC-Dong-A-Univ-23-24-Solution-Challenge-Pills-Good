import torch
import torch.nn as nn
import pkbar
import numpy as np
import random


# seed fix
SEED = 3
np.random.seed(SEED)
random.seed(SEED)
torch.cuda.manual_seed(SEED)
torch.cuda.manual_seed_all(SEED)
torch.manual_seed(SEED)


class PillModel(nn.Module):
    # bulid cnn model
    def __init__(self, config):
        super(PillModel, self).__init__()

        '''
        ClassNum : class number
        '''
        self.m_ClassNum = int(config['class_num'])

        channel1 = 16
        channel2 = 32
        channel3 = 64
        conv1Size = 3
        conv2Size = 3
        poolSize = 2

        self.m_Conv1 = nn.Conv2d(in_channels = 3, out_channels = channel1, kernel_size = conv1Size, padding = 1)
        self.m_Pool1 = nn.MaxPool2d(poolSize, poolSize)
        self.m_Conv2 = nn.Conv2d(in_channels = channel1, out_channels = channel2, kernel_size = conv2Size, padding = 1)
        self.m_Pool2 = nn.MaxPool2d(poolSize, poolSize)
        self.m_Conv3 = nn.Conv2d(in_channels = channel2, out_channels = channel3, kernel_size = conv2Size, padding = 1)
        self.m_Pool3 = nn.MaxPool2d(poolSize, poolSize)

        self.m_Linear4 = nn.Linear(40000, 256)
        self.m_Drop4 = nn.Dropout2d(0.5)

        self.m_Linear5 = nn.Linear(256, self.m_ClassNum)
        self.m_Relu = nn.ReLU()


    def forward(self, x):
        x = self.m_Relu(self.m_Conv1(x))
        x = self.m_Pool1(x)

        x = self.m_Relu(self.m_Conv2(x))
        x = self.m_Pool2(x)

        x = self.m_Relu(self.m_Conv3(x))
        x = self.m_Pool3(x)

        x = x.view(x.shape[0],-1)
        x = self.m_Relu(self.m_Linear4(x))
        x = self.m_Drop4(x)

        x = self.m_Linear5(x)
        return x


import torch.optim as optim
import torchbearer
from torchbearer import Trial
import datetime


class MakeModel():
    def __init__(self,config):
        '''
        learning_rate : learning rate
        epochs : epoch
        save_path : save path
        model_name : model save name
        '''
        
        self._epoch = int(config['epochs'])
        self._lr = float(config['learning_rate'])
        self._savePath = config['save_path']
        self._modelName = config['model_name']


    def SaveModel(self, _model, optimizer, _trainData, trainLoss):
        nowdate = datetime.datetime.now().strftime('%y%m%d_%H')
        ret = 0
        try:
            torch.save({'model_state_dict': _model.state_dict(),
                        'epoch': self._epoch,
                        'optimizer_state_dict': optimizer.state_dict(),
                        'loss': trainLoss,
                        'label_name':_trainData.dataset.classes},
                        self._savePath + self._modelName + '_PyTorchModel.pt')
            print("model saved [", self._savePath +  self._modelName + "_PyTorchModel.pt ]")

        except PermissionError:
                torch.save(_model, './' + nowdate + '_' + self._modelName + '_PyTorchModel.pt')
                print('model saved [ ./' + nowdate + '_' + self._modelName + '_PyTorchModel.pt ]')
            
        except IOError as e:
            print("IOError except: ", e.errno)
            ret = 1

        return ret


    def Training(self, _device, _model, _trainData, _valData):
        _model.train()

        optimizer = optim.Adam(_model.parameters(), lr = self._lr)
        criterion = torch.nn.CrossEntropyLoss()
        bestValLoss = float('inf')
        
        for epoch in range(self._epoch):
            trainLoss = 0.0
            trainSize = 0.0
            trainCorrect = 0.0

            print("Epoch {}/{}".format(epoch + 1, self._epoch))
            progress = pkbar.Kbar(target=len(_trainData), width = 25)

            # train 
            for batchIdx, data in enumerate(_trainData):
                images, labels = data
                images, labels = images.to(_device), labels.to(_device)
                
                optimizer.zero_grad()
                outputs = _model(images)

                loss = criterion(outputs, labels)
                loss.backward()
                optimizer.step()
                trainLoss = loss.item()

                _, predicted = outputs.max(1)
                trainSize += labels.shape[0]
                trainCorrect += predicted.eq(labels.view_as(predicted)).sum().item()
                trainAccuracy = 100 * trainCorrect / trainSize

                progress.update(batchIdx, values = [("loss: ", trainLoss), ("acc: ", trainAccuracy)])

                del loss
                del outputs

            # validation
            with torch.no_grad():
                valLoss = 0.0
                valSize = 0.0
                valCorrect = 0.0

                for batchIdx, data in enumerate(_valData):
                    images, labels = data
                    images, labels = images.to(_device), labels.to(_device)
                    
                    outputs = _model(images)
                    valLoss = criterion(outputs, labels).item()

                    _, predicted = outputs.max(1)
                    valSize += labels.shape[0]

                    valCorrect += predicted.eq(labels.view_as(predicted)).sum().item()
                    valAccuracy = 100 * valCorrect / valSize

                progress.add(1, values=[("val loss", valLoss), ("val acc", valAccuracy)])

            # if best loss value, save model
            if valLoss < bestValLoss:
                bestValLoss = valLoss
                ret = self.SaveModel(_model, optimizer, _trainData, trainLoss)
                
        return ret
        

    # test set model test
    def Testing(self, _device, _model, _testData):
        _model.eval()
        criterion = torch.nn.CrossEntropyLoss()

        testLoss = 0.0
        testSize = 0.0
        testCorrect = 0.0

        progress = pkbar.Kbar(target=len(_testData), width = 25)

        with torch.no_grad():
            for batchIdx, data in enumerate(_testData):
                images, labels = data
                images, labels = images.to(_device), labels.to(_device)
                outputs = _model(images)

                testLoss = criterion(outputs, labels).item()

                _, predicted = outputs.data.max(1)
                testSize += labels.shape[0]
                testCorrect += predicted.eq(labels.view_as(predicted)).sum().item()
                accuracy = 100 * testCorrect / testSize
                
                progress.update(batchIdx, values = [("test loss: ", testLoss), ("test acc: ", accuracy)])
            
            testLoss /= len(_testData.dataset)
        progress.add(1)
