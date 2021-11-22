#https://pythonprinciples.com/challenges/

# Solution validation
# The aim of this challenge is to write code that can analyze code submissions. 
# We'll simplify things a lot to not make this too hard.

# Write a function named validate that takes code represented as a string as its only parameter.

# Your function should check a few things:

# the code must contain the def keyword
# otherwise return "missing def"
# the code must contain the : symbol
# otherwise return "missing :"
# the code must contain ( and ) for the parameter list
# otherwise return "missing paren"
# the code must not contain ()
# otherwise return "missing param"
# the code must contain four spaces for indentation
# otherwise return "missing indent"
# the code must contain validate
# otherwise return "wrong name"
# the code must contain a return statement
# otherwise return "missing return"
# If all these conditions are satisfied, your code should return True.

# Here comes the twist: your solution must return True when validating itself.

#def validate(code):
#    if "def" not in code:
#        return "missing def"
#    if ":" not in code:
#        return "missing :"
#    if "(" and ")" not in code:
#        return "missing paren"
#    if "validate()" in code:
#        return "missing param"
#    if "    " not in code:
#        return "missing indent"
#    if "validate" not in code:
#        return "wrong name"
#    if "return" not in code:
#        return "missing return"
#    return True
#print(validate('def validate(code):\n if "def" not in code:\n return "missing def"\n if ":" not in code:\n return "missing :"\n if "(" and ")" not in code:\n return "missing paren"\n if "()" in code:\n return "missing param"\n if " " not in code:\n return "missing indent"\n if "validate" not in code:\n return "wrong name"\n if "return" not in code:\n return "missing return"\n return True'))


def validate(f):
    if not 'def' in f:
        return "missing def"
    if not ':' in f:
        return "missing :"
    if not ('('in f and ')' in f):
        return "missing paren"
    if '()' in f:
        a = f.replace("'()'",'')
        if '()' in a:
            return "missing param"
    if not '    ' in f:
        return "missing indent"
    if not 'validate' in f:
        return "wrong name"
    if not 'return' in f:
        return "missing return"

    return True

#def validate(code):
#    if "def" not in code:
#        return "missing def"
#    if ":" not in code:
#        return "missing :"
#    if "(" not in code or ")" not in code:
#        return "missing paren"
#    if "(" + ")" in code:
#        return "missing param"
#    if "    " not in code:
#        return "missing indent"
#    if "validate" not in code:
#        return "wrong name"
#    if "return" not in code:
#        return "missing return"
#    return True