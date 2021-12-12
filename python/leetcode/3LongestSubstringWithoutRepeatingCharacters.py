# https://leetcode.com/problems/longest-substring-without-repeating-characters/
#
# 3. Longest Substring Without Repeating Characters
# Medium
# Given a string s, find the length of the longest substring without repeating characters.
# 
# Example 1:
# Input: s = "abcabcbb"
# Output: 3
# Explanation: The answer is "abc", with the length of 3.
# 
# Example 2:
# Input: s = "bbbbb"
# Output: 1
# Explanation: The answer is "b", with the length of 1.
# 
# Example 3:
# Input: s = "pwwkew"
# Output: 3
# Explanation: The answer is "wke", with the length of 3.
# Notice that the answer must be a substring, "pwke" is a subsequence and not a substring.
# 
# Example 4:
# Input: s = ""
# Output: 0
# 
# Constraints:
# 0 <= s.length <= 5 * 104
# s consists of English letters, digits, symbols and spaces.

class Solution(object):
    def lengthOfLongestSubstring(self, s):
        """
        :type s: str
        :rtype: int
        """
        index = 0
        longest = 0
        templongest = 0
        starter = 0
        tempstr = ""
        while starter < len(s):
            while index < len(s):
                letter = s[index]
                if tempstr and tempstr.find(letter) > -1:
                    if templongest > longest:
                        longest = templongest
                    templongest = 0
                    tempstr = letter
                else:
                    tempstr =  tempstr + letter
                    templongest = len(tempstr)
                index += 1   
                if templongest > longest:
                        longest = templongest
            starter += 1
            index = starter
            tempstr = ""
        return longest

sol = Solution()
print(sol.lengthOfLongestSubstring("abcabcbb")) #3
print(sol.lengthOfLongestSubstring("bbbbb")) #1
print(sol.lengthOfLongestSubstring("pwwkew")) #3
print(sol.lengthOfLongestSubstring("")) #0
print(sol.lengthOfLongestSubstring("aba")) #2
print(sol.lengthOfLongestSubstring("dvdf")) #3
print(sol.lengthOfLongestSubstring("asjrgapa")) #6
print(sol.lengthOfLongestSubstring(" ")) #1

