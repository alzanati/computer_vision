"""
Purpose: This Library is implemented basic operations of opencv
Author: Alzanati
Data: 10 / 4 / 2016
"""

import cv2
import numpy as np
import math


class cvUtiliy:
    def __init__(self, img):
        self.img = img        # image data
        self.kernel = np.zeros((3, 3), np.float32)  # image kernel
        self.filtered = 0   # filtered image
        self.Gx = 0         # gradient in x
        self.Gy = 0         # gradient in y
        self.Gxy = 0        # magnitude
        self.thetas = 0     # directions

    # blue the image
    def blur_image(self, img, w):
        self.kernel = np.ones((w, w), np.float32) / (w * w)
        self.filtered = cv2.filter2D(img, -1, self.kernel)
        return self.filtered

    # sum pixels in window
    def summ_pixel_window(self, img, window):
        self.kernel = np.ones((window, window), np.float32)
        self.filtered = cv2.filter2D(img, -1, self.kernel)
        return self.filtered

    # calculate changes in  x, y
    def calc_changes(self, axis, weight):

        w = np.int32(weight)
        if axis == 'x':
            self.kernel = np.array([[-1, 0, 1], [-w, 0, w], [-1, 0, 1]])
            print 'Kernel\n', np.array(self.kernel)
        elif axis == 'y':
            self.kernel = np.array([[-1, -w, -1], [0, 0, 0], [1, w, 1]])
            print 'Kernel\n', np.array(self.kernel)
        else:
            self.kernel = np.array([[0, 1, 0], [1, -4, 1], [0, 1, 0]])  # laplacian kernel
            print 'kernel\n', np.array(self.kernel)

        self.filtered = cv2.filter2D(self.img, -1, self.kernel)
        return self.filtered

    # calculate gradient in x, y
    def image_gradient(self, w):
        self.Gx = self.calc_changes('x', w)
        self.Gy = self.calc_changes('y', w)
        self.Gxy = np.sqrt(np.power(self.Gx, 2) + np.power(self.Gy, 2))
        return self.Gxy

    # calculate directions in image
    def image_directions(self, w):
        self.Gx = self.calc_changes('x', w)
        self.Gy = self.calc_changes('y', w)
        rows = len(self.Gx)
        cols = len(self.Gx[0])
        self.thetas = np.zeros((rows, cols), np.float32)

        # for at each pixel
        for i in range(0, rows - 1):
            for j in range(0, cols - 1):
                x_pixel = self.Gx[i][j][0]
                y_pixel = self.Gy[i][j][0]
                if np.int32(x_pixel) == 0:
                    self.thetas[i][j] = 0.0
                else:
                    self.thetas[i][j] = math.atan2(x_pixel, y_pixel)

        return self.thetas