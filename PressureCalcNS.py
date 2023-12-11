import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

file_path = "543 qlab volumes.xlsx"
df = pd.read_excel(file_path, sheet_name="p021")
fps = 32
density = 1.04
area=4
deg_fit=7
EDP=0
# Access the two columns by their names
frame = df['Frame']
frame = np.array(frame) / fps
frame = frame[:9]
volumes = df['Volume(mL)']
volumes = np.array(volumes)[:9]

# Fit a polynomial of degree 5
vol_coeff = np.polyfit(x=frame, y=volumes, deg=deg_fit)
y_fit = np.polyval(vol_coeff, frame)
# Plot

# Calculate the 1st derivative
firstd_function = np.polyder(np.poly1d(vol_coeff))
first_der = firstd_function(frame)
#first_der = firstd_function(np.linspace(0,100,1))
print(first_der)
plt.plot(frame, first_der)

vol_coeff2 = np.polyfit(x=frame, y=first_der, deg=deg_fit-1)
y_fit2 = np.polyval(vol_coeff2, frame)
secd_function = np.polyder(np.poly1d(vol_coeff2))
second_der = secd_function(frame)
print(second_der)



def diff_array(input_array):
    output = [0]
    i=1
    while i<len(input_array):
        output.append(input_array[i-1]+input_array[i])
        i=i+1
    return np.array(output)

def transform_array(input_array):
    output=[]
    output.append(input_array[0])
    i=1
    while i<len(input_array):
        output.append(input_array[i]+output[i-1])
        output[i-1]+=EDP
        i=i+1
    return output

change_in_vol=diff_array(first_der)
my_fun=(density*0.1*diff_array(first_der)*second_der*0.0075)/(fps*area**2)
#plt.plot(EDP, 'k--')
#plt.plot(frame[:7],transform_array(my_fun)[:7], "ro-")
#plt.xlabel("ime(s)")
#plt.ylabel("Pressure(mmHg)")
#print("The mean pressure is", np.mean(transform_array(my_fun)[:7])-EDP, "mmHG")
