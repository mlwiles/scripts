#https://app.testdome.com/
#

def unique_names(names1, names2):
    names = []
    for name in names1:
        names.append(name)
    for name in names2:
        names.append(name)
    unique = []

    for name in names:
        if name in unique:
            continue
        else:
            unique.append(name)
    return unique

if __name__ == "__main__":
    names1 = ["Ava", "Emma", "Olivia"]
    names2 = ["Olivia", "Sophia", "Emma"]
    print(unique_names(names1, names2)) # should print Ava, Emma, Olivia, Sophi
