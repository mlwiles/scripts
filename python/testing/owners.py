# https://app.testdome.com/
# 
# Implement a group_by_owners function that:
# - accepts a dictionary containing the file owner name for each file name.
# - returns a dictionary containing a list of file names for each owner name, in any order.
#
# For example, for dictionary {'Input.txt':'Randy',:'Code.py': 'Stan',:'Output.txt': 'Randy'} the group_by_owners
# function should return {'Randy': ['Input.txt', 'Output.txt'], 'Stan': ['Code.py']}

def group_by_owners(files):
    new_dict = {}   
    for key, value in files.items():
        try:
            new_dict[value] 
            new_dict[value].append(key)
        except KeyError:
            new_dict[value] = [key]
    return new_dict

if __name__ == "__main__":    
    files = {
        'Input.txt': 'Randy',
        'Code.py': 'Stan',
        'Output.txt': 'Randy'
    }   
    print(group_by_owners(files))