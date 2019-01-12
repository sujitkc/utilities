#!/usr/bin/python

# Given two numbers x and y, return the sum of x and y.
# number, number --> number
# Example:
#  add(1,2) = 3
#  add(0,2) = 2
def add(x, y):
  return x + y

# Given two numbers x and y, return the product of x and y.
# number, number --> number
# Example:
#  multiply(1,2) = 2
#  multiply(4,2) = 8
#  multiply(4,0) = 0
def multiply(x,y):
  return x * y

def showUI():
  operation = input("Choose your operation (1 - add; 2 - multiply): ")
  print("Input the two numbers")
  x = input("x = ")
  y = input("y = ")
  if(operation == 1):
    print "sum = " + str(add(x,y))
  elif(operation == 2):
    print "product = " + str(multiply(x, y))

if __name__ == "__main__":
  showUI()
