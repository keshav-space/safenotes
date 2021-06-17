# Code to reduce size or change Resolution

from PIL import Image
print("Use python 3.x")
fil = input("Enter Image file / enter full path ")
foo = Image.open(fil)
print("Current image size is: ", foo.size)
print("Enter new resolution ")    
x = int(input("Enter x: "))
y = int(input("Enter y: ")) 
q = int(input("Enter the value of quality btw 1-100: "))
res = fil.rsplit('.', 1)
nfile = res[0]+"_new."+res[1]
foo = foo.resize((x,y),Image.ANTIALIAS)
foo.save(nfile,optimize=True,quality=q)