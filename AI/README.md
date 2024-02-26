# AI-based pill identification system
##How to run
1. Download the data from the following link. https://aihub.or.kr/aihubdata/data/view.do?currMenu=115&topMenu=100&aihubDataSe=data&dataSetSn=576
2. Refer to the comments in ai_maain.py, train.py, and preprocessing.py and adjust them to your environment.
  - At this time, you need the firebase key.
  - You must set the directory path to load and save data.
3. 1.-2. Once you're done, run ai_main.py. You will be able to see the classification results.
4. If you would like additional statistical data for each artificial intelligence model (CNN+KNN, EficientNet, CNN+SVM, ResNet-50) required for the ResNet-50 selection process, please refer to AI_v6.ipynb.
## abstract

Inappropriate medication administration is a significant health problem worldwide, resulting in significant morbidity and mortality. This project develops an AI-based system to identify oral medications through image recognition, with the goal of mitigating risks associated with polypharmacy and adverse drug reactions. Leveraging advanced machine learning algorithms and image processing techniques, this system provides an approach to improve drug safety and patient care.



## introduction

Medication errors and adverse drug reactions pose serious problems to healthcare systems around the world. The complexity of drug interactions and difficulties in pill identification increase the risk of inappropriate drug use. This project introduces an AI-based solution designed to recognize oral medications from user-uploaded images, leveraging OpenCV for image preprocessing and combining TensorFlow's ResNet-50 and scikit-learn's k-NN for pill classification. Utilize a hybrid model.

## Materials and Methods

### Data collection

To train this model, we used oral drug image data hosted at Boramae Hospital in Seoul. This dataset contains images of pills with different shapes, colors, and markings, as well as labeling data in json format for the images.

### Image preprocessing

We perform image preprocessing using OpenCV and focus on improving features related to pill identification, such as shape, color, and imprint. Techniques such as edge detection, color normalization, and contour detection are used to prepare images for classification.

### AI model architecture

The system utilizes a hybrid AI model that integrates the advantages of convolutional neural networks (CNN) and k-Nearest Neighbors (k-NN) for effective pill classification. The model architecture is inspired by the integration features discussed in “Polymers, MDPI, Volume 10, Issue 1, Article number 4”, which highlights the potential of combining CNNs and k-NNs for improved classification performance.

#### Convolutional Neural Network (CNN)

This model uses TensorFlow's ResNet-50 as the backbone for feature extraction. ResNet-50, a renowned deep residual learning framework, facilitates learning complex patterns in image data, which are essential for accurate pill identification.

#### k-Nearest Neighbor (k-NN)

Following feature extraction, scikit-learn's k-NN algorithm is applied for classification. k-NN was chosen for its ability to effectively handle multi-class classification problems and generate more nuanced decision boundaries, thereby improving the precision of the model to identify various oral drugs.

## result

An AI-based pill identification system recognizes oral medications from images with high accuracy, demonstrating the effectiveness of the integrated CNN and k-NN approach. System performance is evaluated using various metrics, including precision, recall, and F1 score, across test datasets representing a variety of oral medications. Detailed statistical data related to model evaluation has been completed in AI_v6.ipynb.

## Argument

The integration of CNN and k-NN in a hybrid model combines the deep learning capabilities of CNN with the subtle classification potential of k-NN to provide a powerful solution for pill identification. This approach provides a tool to solve the pill identification problem in clinical settings and significantly reduce the risks associated with medication errors and adverse drug reactions.

## conclusion

This project contributes to the field of healthcare AI by introducing an innovative system to identify oral medications through pill photo recognition. By utilizing cutting-edge AI technology and new model architecture, we contribute to SDGs Goal 3. “Health and Well-being”.

## References

- "Polymers, MDPI, Volume 10, Issue 1, Article No. 4." Available online: https://www.mdpi.com/2227-9040/10/1/4. This reference provides fundamental insights into the integration of CNNs and k-NNs for classification tasks and provides key inspiration for the project model architecture.