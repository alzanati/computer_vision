"""
Purpose: be familiar with opencv functions
Author: Mohamed Hosny Ahmed
Data: 8 / 4 / 2016
"""

import sys
import cv2
import numpy as np

filename = '/home/prof/Work_Space/CV/Assignment_3_CV/grad.png'
img = cv2.imread(filename)
gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)

gray = np.float32(gray)
dst = cv2.cornerHarris(gray,2,3,0.04)

#result is dilated for marking the corners, not important
dst = cv2.dilate(dst,None)

# Threshold for an optimal value, it may vary depending on the image.
img[dst > 0.01 * dst.max()] = [0, 0, 255]

cv2.imshow('dst',img)
if cv2.waitKey(0) & 0xff == 27:
    cv2.destroyAllWindows()

# accessing image pixels
# print (img[100, 100, 2])    # BGR : red pixel
# print (img.item(100, 100, 2))   # using indexing nidef shywa :D
# print (img[:, :, 1])   # get all green pixels

# get info about image
# rows, cols, channel = img.shape
# print ('rows: ', rows)
# print ('cols: ', cols)
# print (img.size)
# print (img.dtype)

# select region from image
#roi = img[100:300, 250:400]
#img[200:400, 250:400] = roi

# splitting channels R, G, B, Then merging
# b,g,r = cv2.split(img)
# red = img[:, :, 2]
# green = img[:, :, 1]
# blue = img[:, :, 0]
# img = cv2.merge((blue, green, red))


# create new image
# newImage = np.zeros((rows, cols))
#
# for i in range(0, rows, 1):
#     for j in range(0, cols, 1):
#         red = img[i, j, 2]
#         green = img[i, j, 1]
#         blue = img[i, j, 0]
#         newImage[i, j] = int(red/255 + green/255 + blue/255)

# working with datatypes
# x = np.uint8([34])
# y = np.uint8([50])
#print ( cv2.add(x, y) )

# show image
# cv2.imshow('img',img)
# cv2.waitKey(0)
# cv2.destroyAllWindows()