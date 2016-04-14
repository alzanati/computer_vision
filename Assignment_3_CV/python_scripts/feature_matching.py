"""
Purpose: Implement the feature matching using ssd, cross correlation
Author: Mohamed Hosny Ahmed
Date: 13 / 4 / 2016
"""

import cv2
import numpy as np

class FeatureMatching:
    def __init__(self, vector1, vector2):
        self.vector1 = vector1
        self.vevtot2 = vector2
        self.ssdCompare()

    def ssdCompare(self):
        
