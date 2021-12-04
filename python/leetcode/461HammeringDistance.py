# https://leetcode.com/problems/maximal-rectangle/
# 
# The Hamming distance between two integers is the number of positions at which the corresponding bits are different.
# Given two integers x and y, return the Hamming distance between them.

# Example 1:
# Input: x = 1, y = 4
# Output: 2
# Explanation:
# 1   (0 0 0 1)
# 4   (0 1 0 0)
#       ↑   ↑
# The above arrows point to positions where the corresponding bits are different.

# Example 2:
# Input: x = 3, y = 1
# Output: 1
 
# Constraints:
# 0 <= x, y <= 231 - 1

class Solution(object):
    def hammingDistance(self, x, y):
        """
        :type x: int
        :type y: int
        :rtype: int
        """   
        dist = 0
        xor = x ^ y
        while xor:
            dist += 1
            xor &= xor - 1
        return dist

    # https://shareablecode.com/snippets/hamming-distance-python-solution-leetcode-PyTc-W7YS
    def hammingDistance2(self, x, y):
        """
        :type x: int
        :type y: int
        :rtype: int
        """
        return bin(x ^ y).count('1')
    
    # https://leetcode.com/problems/hamming-distance/discuss/721326/hamming-distance-python-3-solution
    def hammingDistance3(self, x: int, y: int) -> int:
        # x ^ y return 0 1 0 1
        result, count = x ^ y, 0
        while result > 0:
            # plus 1 if the right most num is 1
            count += result & 1
            # shift 1 position to the right
            result >>= 1
        return count


sol = Solution()
print(sol.hammingDistance(1, 4))
print(sol.hammingDistance(3, 1))