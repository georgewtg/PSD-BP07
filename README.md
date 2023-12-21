# Graph Plotter - FINAL PROJECT PSD-BP07
Proyek Akhir Praktikum PSD - Kelompok BP07

## BACKGROUND
Graph Plotter is a device used to plot graphs as seen in calculators and other similar devices. Graph Plotter aims to take inputs from user and transform it into a readable graph that roughly tells the user what the graph looks like. This is especially helpful for a quick visualization to help user understand an equation.

## HOW IT WORKS
User will be prompted with an instruction and 3 integer inputs. The instruction will tell the device which type of equation the graph is for. The other 3 inputs are for operands to determine the position and properties of the graph. The inputs will then be processed by an alu and a 2-dimentional bit array will be created containing 0 for coordinates where the line pixels exist and 1 for the rest. This array will then be passed on to the graph plotter where it will be turned into a bitmap file containing the image of the graph.

## TESTING & RESULT
We tested our results on all instructions, each with different sets of operands, and received these results:
- Linear Graphs  
  ![text](https://github.com/georgewtg/PSD-BP07/blob/main/Images/graph1_1.bmp)
  ![text](https://github.com/georgewtg/PSD-BP07/blob/main/Images/graph1_2.bmp)
  ![text](https://github.com/georgewtg/PSD-BP07/blob/main/Images/graph1_3.bmp)
  
- Absolute Graphs  
  ![text](https://github.com/georgewtg/PSD-BP07/blob/main/Images/graph2_1.bmp)
  ![text](https://github.com/georgewtg/PSD-BP07/blob/main/Images/graph2_2.bmp)
  
- Quadratic Graphs  
  ![text](https://github.com/georgewtg/PSD-BP07/blob/main/Images/graph3_1.bmp)
  ![text](https://github.com/georgewtg/PSD-BP07/blob/main/Images/graph3_2.bmp)
  ![text](https://github.com/georgewtg/PSD-BP07/blob/main/Images/graph3_3.bmp)
  
- Cubic Graphs  
  ![text](https://github.com/georgewtg/PSD-BP07/blob/main/Images/graph4_1.bmp)
  ![text](https://github.com/georgewtg/PSD-BP07/blob/main/Images/graph4_2.bmp)
  ![text](https://github.com/georgewtg/PSD-BP07/blob/main/Images/graph4_3.bmp)
