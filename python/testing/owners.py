#https://app.testdome.com/
# 
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