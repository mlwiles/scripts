# https://leetcode.com/problems/median-of-two-sorted-arrays/submissions/
# 
# Given two sorted arrays nums1 and nums2 of size m and n respectively, return the median of the two sorted arrays.

# The overall run time complexity should be O(log (m+n)).

# Example 1:
# Input: nums1 = [1,3], nums2 = [2]
# Output: 2.00000
# Explanation: merged array = [1,2,3] and median is 2.

# Example 2:
# Input: nums1 = [1,2], nums2 = [3,4]
# Output: 2.50000
# Explanation: merged array = [1,2,3,4] and median is (2 + 3) / 2 = 2.5.
 
# Constraints:
# nums1.length == m
# nums2.length == n
# 0 <= m <= 1000
# 0 <= n <= 1000
# 1 <= m + n <= 2000
# -106 <= nums1[i], nums2[i] <= 106

class Solution(object):
    def medianOfTwoSortedArrays(self, nums1, nums2):
        """
        :type l1: list
        :type l2: list
        :rtype: float            
        """
        median = 0
        list3 = nums1 + nums2
        list3.sort()
        list3len = len(list3)
        print(list3)
        print(list3len)

        if list3len % 2 == 0:
            print("even")
            half = (int)(list3len / 2)
            print(list3[half - 1])
            print(list3[half])
            median = (((int)(list3[half - 1]) + (int)(list3[half])) / 2)
        else:
            print("odd")
            half = (int)(list3len / 2)
            print(list3[half])
            median = list3[half]
        return median

sol = Solution()
nums1 = [1,2]
nums2 = [3,4]
print(sol.medianOfTwoSortedArrays(nums1,nums2)) #2.5