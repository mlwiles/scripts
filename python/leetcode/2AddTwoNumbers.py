# https://leetcode.com/problems/add-two-numbers/
# 
# # You are given two non-empty linked lists representing two non-negative integers. The digits are stored in reverse order, and each of their nodes contains a single digit. 
# Add the two numbers and return the sum as a linked list.

# You may assume the two numbers do not contain any leading zero, except the number 0 itself.

# Example 1:
# 2 -> 4 -> 3
# 5 -> 6 -> 4
# -----------
# 7 -> 0 -> 8
# Input: l1 = [2,4,3], l2 = [5,6,4]
# Output: [7,0,8]
# Explanation: 342 + 465 = 807.

# Example 2:
# Input: l1 = [0], l2 = [0]
# Output: [0]

# Example 3:
# Input: l1 = [9,9,9,9,9,9,9], l2 = [9,9,9,9]
# Output: [8,9,9,9,0,0,0,1]

# Constraints:
# The number of nodes in each linked list is in the range [1, 100].

# 0 <= Node.val <= 9
# It is guaranteed that the list represents a number that does not have leading zeros.

# Definition for singly-linked list.
class ListNode(object):
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next
# Definition for singly-linked list.
# class ListNode(object):
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
def getSize(l1):
    """
    :type l1: ListNode
    """
    size = 0
    currentln = l1
    while currentln:
        size += 1
        currentln = currentln.next
    return size
    
class Solution(object):
    
    def addTwoNumbers(self, l1, l2):
        """
        :type l1: ListNode
        :type l2: ListNode
        :rtype: ListNode
        """
        ln1 = l1
        ln2 = l2
        size1 = getSize(l1)
        size2 = getSize(l2)
        if size1 < size2:
            ln1 = l2
            ln2 = l1
            
        retln = ln1
        currentl1 = retln
        currentl2 = ln2
        
        while currentl1:
            if currentl2:
                currentl1.val = currentl1.val + currentl2.val
            if currentl1.val > 9:
                if currentl1.next:
                    currentl1.val = currentl1.val % 10
                    currentl1.next.val += 1
            if currentl1.next == None:
                if currentl1.val > 9:
                    currentl1.next = ListNode(1)
                    currentl1.val = currentl1.val % 10
            currentl1 = currentl1.next
            if currentl2:
                currentl2 = currentl2.next
        return retln

sol = Solution()
print(sol.addTwoNumbers([2,4,3,1],[5,6,4]))
print(sol.addTwoNumbers([9,9,9,9,9,9,9],[9,9,9,9]))