import os
def Kill_Excel():
    os.system("taskkill /f /im Excel.exe")

def DeleteObject(myObject):
    del   myObject
