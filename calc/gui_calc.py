#!/usr/bin/python

import Tkinter as tk

class Calc(tk.Frame):
  INIT = 0
  EDITNUM = 1
  
  def __init__(self, master):
    self.state = Calc.INIT
    self.answer = 0
    self.binop = ""
    
    tk.Frame.__init__(self, master)
    self.display = tk.Entry(self)
    self.display.grid(row=0, columnspan=3)
    self.display.insert(0, "0")
    buttonDetails = [
      [ ("1", lambda: self.pressNumber("1")), ("2", lambda: self.pressNumber("2")), ("3", lambda: self.pressNumber("3"))],
      [ ("4", lambda: self.pressNumber("4")), ("5", lambda: self.pressNumber("5")), ("6", lambda: self.pressNumber("6"))],
      [ ("7", lambda: self.pressNumber("7")), ("8", lambda: self.pressNumber("8")), ("9", lambda: self.pressNumber("9"))],
      [ ("0", lambda: self.pressNumber("0")), ("+", lambda: self.pressBinOp("+")) , ("=", self.pressEquals)],
      [ ("AC", self.allClear)]
    ]
    for i in range(len(buttonDetails)):
      for j in range(len(buttonDetails[i])):
        label, func = buttonDetails[i][j]
        tk.Button(self, text=label, command=func).grid(row=i+1, column=j)

  def pressNumber(self, n):
    if(self.state == Calc.INIT):
      self.display.delete(0, "end")
      self.display.insert(0, n)
      self.state = Calc.EDITNUM
    else:
      text = self.display.get() + n
      self.display.delete(0, "end")
      self.display.insert(0, text)

  def pressEquals(self):
    if(self.state == Calc.EDITNUM):
      if(self.binop != ""):
        self.processBinOp()
    self.state = Calc.INIT
       
  def pressBinOp(self, binop):
    if(self.state == Calc.EDITNUM):
      if(self.binop != ""):
        self.processBinOp()
      else:
        self.answer = float(self.display.get())

    self.state = Calc.INIT
    self.binop = binop

  def processBinOp(self):
    if(self.binop == "+"):
      self.answer += float(self.display.get())
      self.display.delete(0, "end")
      self.display.insert(0, str(self.answer))
      self.binop = ""

  def allClear(self):
    self.display.delete(0, "end")
    self.display.insert(0, "0")
    self.answer = 0
    self.state = Calc.INIT
    self.binop = ""
    
if __name__ == "__main__":
  root = tk.Tk()
  root.title("Calculator")
  gui = Calc(root)
  gui.pack()
  root.mainloop()
