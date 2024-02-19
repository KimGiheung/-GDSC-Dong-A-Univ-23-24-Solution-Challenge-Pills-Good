import numpy as np
import cv2

def get_lbp_image(image, radius, points):
    lbp_image = np.zeros_like(image, dtype=np.uint8)
    for y in range(radius, image.shape[0] - radius):
        for x in range(radius, image.shape[1] - radius):
            center = image[y, x]
            binary_string = ''
            for point in range(points):
                r = int(y + radius * np.sin(2 * np.pi * point / points))
                c = int(x + radius * np.cos(2 * np.pi * point / points))
                binary_string += '1' if image[r, c] >= center else '0'
            lbp_image[y, x] = int(binary_string, 2)
    return lbp_image

def ms_lbp(image, radii, points):
    if image.ndim == 3 and image.shape[2] == 3:
        image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    ms_lbp_images = []
    for radius in radii:
        lbp_image = get_lbp_image(image, radius, points)
        ms_lbp_images.append(lbp_image)
    return ms_lbp_images

if __name__ == '__main__':
    # Example usage
    image = cv2.imread('path_to_your_image.jpg')  # Load your image here
    radii = [1, 2, 3]  # Example radii for multi-scale
    points = 8  # Number of points to consider around the center pixel
    ms_lbp_images = ms_lbp(image, radii, points)   
    # Display or process your MS-LBP images
