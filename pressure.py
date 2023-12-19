import numpy as np
import scipy.integrate as sp
import matplotlib.pyplot as plt
import csv

def createVolumeArr(filePath):
    columnIndex = 1
    with open(filePath, 'r') as file:
        reader = csv.reader(file)
        volumes = [row[columnIndex] for row in reader]

    # Processing

    volumes.pop(0)
    volumes = [int(x) for x in volumes]

    # Only want decreasing values

    index = len(volumes)//4
    for i in range(len(volumes)//4, len(volumes)-1):
        if volumes[i+1]>volumes[i]:
            break
        index += 1
    return volumes[:index+1]    


filePath = "2.csv"
volumes = createVolumeArr(filePath)
print(volumes)

# fps = int(input("FPS?"))
# area=float(input("aortic area?"))
# method = int(input("method? 1 = olaf, 0 = ours"))

fps = 15
area = 3.5
method = 1
dt = 1/fps
density = 1.04
deg=5
EDP=80


dVolumes = [0]*(len(volumes)-1)
for i in range(len(dVolumes)):
    dVolumes[i] = volumes[i+1]-volumes[i]


numFrames = len(dVolumes)
t = np.arange(0, numFrames*dt, dt)

volumesT = np.arange(0, (numFrames+1)*dt, dt)

# Polyfit dVolumes 

tail = 3
volumesLast = volumes[-1]
volumesFirst = volumes[0]
temp = volumes[:]
for i in range(tail):
    
    temp.append(volumesLast)
    temp.insert(0, volumesFirst)

tempT = np.arange(-tail*dt, (numFrames+tail)*dt, dt)

volumesFitFunction = np.polyfit(tempT, temp[:-1], deg)
newDt = dt/100
newT = np.arange(0, numFrames*dt, newDt)
VolumesFit = np.polyval(volumesFitFunction, newT)

if method == 1:
    tail = 3
    volumesLast = dVolumes[-1]
    volumesFirst = dVolumes[0]
    temp = dVolumes[:]
    # for i in range(tail):
    #     temp.append(volumesLast)
    #     temp.insert(0, volumesFirst)

    # print(len(temp))
    # print(len(tempT))

    tempT = np.arange(-tail*dt, (numFrames+tail)*dt, dt)
    print(len(temp))
    print(len(tempT))
    dVolumesFitFunction = np.polyfit(t, temp, deg-2)
else:
    dVolumesFitFunction = np.polyder(volumesFitFunction, 1)



dVolumesFit = np.polyval(dVolumesFitFunction, newT)

# Second derivative
dd_VolumesFitFunction = np.polyder(dVolumesFitFunction, 1)
dd_VolumesFit = np.polyval(dd_VolumesFitFunction, newT)

if method == 1:
    # Plot for discrete dVolumes
    plt.figure(figsize=(6, 5))
    plt.scatter(t, dVolumes, label='Data', color='red')
    plt.plot(newT, dVolumesFit, label=str(deg-2) + 'rd degree polynomial interpolation')
    plt.title("LV Volumetric Flow Rate")
    plt.xlabel('Time after end diastole (s)')
    plt.xlim([0, max(newT)])
    plt.ylabel('Volumetric flow rate (mL/s)')
    plt.legend(prop={'size': 6})
    plt.grid(True)
    plt.show()
    
    # # Plot for polynomial fit of dVolumes
    # plt.figure(figsize=(6, 5))
    # plt.plot(newT, dVolumesFit, label=f'{deg}-degree Polynomial Fit of dV/dt')
    # plt.title(f'{deg}-degree Polynomial Fit of dV/dt')
    # plt.xlabel('Time after end diastole (s)')
    # plt.ylabel('Change in Volume')
    # plt.legend()
    # plt.grid(True)
    # plt.show()

    # Plot for the derivative of the polynomial fit
    plt.figure(figsize=(6, 5))
    plt.plot(newT, dd_VolumesFit, label='Interpolated second derivative')
    plt.title('LV Volumetric Flow Acceleration')
    plt.xlabel('Time after end diastole (s)')
    plt.xlim([0, max(newT)])
    plt.ylabel('Volumetric flow acceleration (mL/s^2)')
    plt.legend(prop={'size': 8})
    plt.grid(True)
    plt.show()
    
    
else:
    # Plot for discrete dVolumes
    plt.figure(figsize=(6, 5))
    plt.scatter(volumesT, volumes, label='Data', color='red')
    plt.plot(newT, VolumesFit, label=str(deg) + 'th degree polynomial interpolation')
    plt.title('LV Volumes During Systole')
    plt.xlabel('Time after end diastole (s)')
    plt.xlim([0, max(newT)])
    plt.ylabel('Volume (mL)')
    plt.legend()
    plt.grid(True)
    plt.show()
    
    # Plot for discrete dVolumes
    # plt.figure(figsize=(10, 4))
    # plt.plot(newT, VolumesFit, label='Continuous')
    # plt.title(f'{deg}-degree Polynomial Fit of Volumes')
    # plt.xlabel('Time (s)')
    # plt.ylabel('Polyfit of Absolute Volumes')
    # plt.legend()
    # plt.grid(True)
    # plt.show()
    
    # Plot for polynomial fit of dVolumes
    plt.figure(figsize=(6, 5))
    plt.plot(newT, dVolumesFit, label="Interpolated dV/dt")
    plt.title("LV Volumetric Flow Rate")
    plt.xlabel('Time after end diastole (s)')
    plt.xlim([0, max(newT)])
    plt.ylabel('Volumetric flow rate (mL/s)')
    plt.legend()
    plt.grid(True)
    plt.show()
    
    # Plot for the derivative of the polynomial fit
    plt.figure(figsize=(6, 5))
    plt.plot(newT, dd_VolumesFit, label='Interpolated second derivative')
    plt.title('LV Volumetric Flow Acceleration')
    plt.xlabel('Time after end diastole (s)')
    plt.xlim([0, max(newT)])
    plt.ylabel('Volumetric flow acceleration (mL/s^2)')
    plt.legend()
    plt.grid(True)
    plt.show()
    print()
    

    

# Obtaining deltaP

numPoints = len(dVolumesFit)
deltaP = [0]*(numPoints-1)

CONSTANT = density/(area**2)*0.1*0.0075
# Change this scaler to scale P(t)
SCALER = 3500000
# Keep this 0 for now
M = 0

for i in range(numPoints-1):
    deltaP[i] = CONSTANT*(newDt*(2*dVolumesFit[i]+dVolumesFit[i+1])*dd_VolumesFit[i])+M

plt.plot(newT[:-1], deltaP)
plt.title("Aorta Rate of Change of Pressure")
plt.xlabel("Time after end diastole (s)")
plt.xlim([0, max(newT)])
plt.ylabel("Rate of change of pressure (mmHg/s)")
plt.grid(True)
plt.show()

P = sp.cumtrapz(deltaP, dx=newDt)

plt.plot(newT[:-2], P)
plt.title("Aortic Pressures")
plt.xlabel("Time after end diastole (s)")
plt.xlim([0, max(newT)])
plt.ylabel("Pressure (mmHg)")
plt.grid(True)
plt.show()

P = [SCALER*x for x in P]

plt.plot(newT[:-2], P)
plt.title("Scaled Aortic Pressures (x3500000)")
plt.xlabel("Time after end diastole (s)")
plt.xlim([0, max(newT)])
plt.ylabel("Pressure (mmHg)")
plt.grid(True)
plt.show()

P = [x+EDP for x in P]

plt.plot(newT[:-2], P)
plt.title("Scaled Aortic Pressures With EDP")
plt.xlabel("Time (s)")
plt.xlim([0, max(newT)])
plt.ylabel("Pressure (mmHg)")
plt.grid(True)
plt.show()

