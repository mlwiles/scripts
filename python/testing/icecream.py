# https://app.testdome.com/
# 
# Implement the IceCreamMachine's scoops method so that it returns all combinations of one ingredients and one topping.
# if there are no ingredients or toppings, the method should return an empty list.list
# For example,     machine = IceCreamMachine(["vanilla", "chocolate"], ["chocolate sauce"]).scoops() should return
# [['vanilla', 'chocolate sauce'], ['chocolate', 'chocolate sauce']]

class IceCreamMachine:
    
    def __init__(self, ingredients, toppings):
        self.ingredients = ingredients
        self.toppings = toppings
        
    def scoops(self):
        list_new = []
        for ingred in self.ingredients:
            for top in self.toppings:
                list_new2 = [ingred, top]
                list_new.append(list_new2)
        return list_new

if __name__ == "__main__":
    machine = IceCreamMachine(["vanilla", "chocolate"], ["chocolate sauce"])
    print(machine.scoops()) #should print[['vanilla', 'chocolate sauce'], ['chocolate', 'chocolate sauce']]