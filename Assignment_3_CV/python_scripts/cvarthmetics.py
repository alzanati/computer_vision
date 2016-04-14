"""
Purpose: This class is to provide basic arithmetic operations
Author: Mohamed Hosny Ahmed
Date: 12 / 4 / 2016
"""

import numpy as np

class Arthmetics:

    # get biggest number with no reminder in case of divide by modulo
    @staticmethod
    def get_module(num, modulo=3):
        reminder = num % modulo
        print reminder
        if reminder == 2:
            return num + 1
        elif reminder == 1:
            return num + 2
        else:
            return num

    @staticmethod
    def get_vector_max(vector):
        length = len(vector)
        local_max = 0
        for i in range(0, length):
            if vector[i] > local_max:
                local_max = vector[i]
        return local_max

    # get_local_maximal
    @staticmethod
    def get_local_maxima( img ):
        rows = len(img)
        cols = len(img[0])
        tmp_image = np.zeros((rows, cols), np.float32)
        for row in range(0, rows):
            for col in range(0, cols):
                window = img[row:1:row+2][col:1:col+2]
                tmp_image[row][col] = Arthmetics.get_vector_max(window)
        return tmp_image

    # get_local_maximal
    @staticmethod
    def get_local_maxima(img):
        rows = len(img)
        cols = len(img[0])
        tmp_image = np.zeros((rows, cols), np.float32)

        for row in range(1, rows-1):
            for col in range(1, cols-1):
                window = img[(row-1):(row+2), (col-1):(col+2)]
                maxi,loc = Arthmetics.get_matrix2_max(window)
                if maxi == img[row][col] :
                    tmp_image[row][col] = 1
                else:
                    tmp_image[row][col] = 0

        return tmp_image

    # get max in matrix
    @staticmethod
    def get_matrix2_max(matrix):
        rows = len(matrix)
        cols = len(matrix[0])
        local_max = 0
        local_max_location = np.zeros((1,2), np.float32)
        for row in range(0, rows):
            for col in range(0, cols):
                if matrix[row][col] > local_max:
                    local_max = matrix[row][col]
                    local_max_location[0][0] = row
                    local_max_location[0][1] = col
        return local_max, local_max_location
