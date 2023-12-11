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


filePath = "21.csv"
volumes = createVolumeArr(filePath)

fps = int(input("FPS?"))
area=int(input("aortic area?"))
method = int(input("method? 1 = olaf, 0 = ours"))
dt = 1/fps
density = 1.04
deg=5
EDP=80


dVolumes = [0]*(len(volumes)-1)
for i in range(len(dVolumes)):
    dVolumes[i] = volumes[i+1]-volumes[i]

numFrames = len(dVolumes)


t = np.arange(0, numFrames*dt, dt)

# Polyfit dVolumes 

volumesFitFunction = np.polyfit(t, volumes[:-1], deg)

if method == 1:
    dVolumesFitFunction = np.polyfit(t, dVolumes, deg-1)
else:
    dVolumesFitFunction = np.polyder(volumesFitFunction, 1)

newDt = dt/100
newT = np.arange(0, numFrames*dt, newDt)
dVolumesFit = np.polyval(dVolumesFitFunction, newT)


# Second derivative

dd_VolumesFitFunction = np.polyder(dVolumesFitFunction, 1)
dd_VolumesFit = np.polyval(dd_VolumesFitFunction, newT)

plt.plot(t, dVolumes, label='discrete')
plt.plot(newT, dVolumesFit, label=str(deg)+" degree polyfit")
plt.plot(newT, dd_VolumesFit, label='derivative')
plt.legend()
plt.show()


# Obtaining deltaP

numPoints = len(dVolumesFit)
deltaP = [0]*(numPoints-1)

CONSTANT = density/(area**2)*0.1*0.0075
# Change this scaler to scale P(t)
SCALER = 50000
# Keep this 0 for now
M = 0

for i in range(numPoints-1):
    deltaP[i] = SCALER*(CONSTANT*newDt*(dVolumesFit[i]+dVolumesFit[i+1])*dd_VolumesFit[i])+M

# plt.plot(newT[:-1], deltaP)
# plt.show()

# Plotting P

P = sp.cumtrapz(deltaP, dx=newDt)

P = [x+EDP for x in P]

plt.plot(newT[:-2], P)
plt.xlabel("Time (s)")
plt.ylabel("Pressure (mmHg)")
plt.show()





