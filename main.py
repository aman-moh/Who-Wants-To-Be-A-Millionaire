from tkinter import*
from PIL import ImageTk, Image
import pygame

pygame.init()
root = Tk()
root.title("Who wants to be a millionaire")
root.geometry('1352x652+0+0')
root.configure(background = 'black')

ABC = Frame(root, bg = 'black')
ABC.grid()

ABC1 = Frame(root, bg = 'black', bd = 20, width = 900, height = 600)
ABC1.grid(row = 0, column = 0)
ABC2 = Frame(root, bg = 'black', bd = 20, width = 452, height = 600)
ABC2.grid(row = 0, column = 1)

ABC1a = Frame(ABC1, bg = 'green', bd = 20, width = 900, height = 200)
ABC1a.grid(row = 0, column = 0)
ABC1b = Frame(ABC1, bg = 'green', bd = 20, width = 900, height = 200)
ABC1b.grid(row = 1, column = 0)
ABC1c = Frame(ABC1, bg = 'green', bd = 20, width = 900, height = 200)
ABC1c.grid(row = 2, column = 0)

CentreImage = ImageTk.PhotoImage(Image.open("million_pics/Centre.png"))
LogoCentre = Button(ABC1b, image = CentreImage, bg = 'black', width = 300, height = 200)
LogoCentre.grid()
