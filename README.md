# Vital-Radar-Sensor-Vital-Sign-Monitoring-Project

- ***"Radar IQ Signal Extraction Code for heart rate and breathing measurement"*** is intended to program the XMC4700 MCU on DEMO Infineon Technologies Sense2GoL Pulse radar board to get I/Q signals from radar transmission and reception signals.

- ***"Raspberry-Pi Code for Advanced Signal Processing"*** is intended to perform advanced signal processing (mainly using VMD) to estimate heart and breathing rate from I/Q signals from the Sense2GoL Puls Radar Board.

- ***"Mobile Application Code"*** is intended to create a flutter application over Android/iOS, to get the heart and breathing rate from raspbery-pi. The communication used is in the form of beacons using BLE.

***Project Overview, architecture, and overall flow:***
The Vital Sign Monitoring Project (Heart and Respiration Rate Monitoring) overvire, archtecture, and overall flow is as follows:

![overview_radar_sensor](https://user-images.githubusercontent.com/60351044/208501403-255fe521-7c6f-473a-b36a-dcfab65e5b4d.png)
<p align="center">
  <em>Fig. 1: Overview of the Radar Sensor based Platform for Vital Sign Monitoring</em>  
</p>

![image](https://user-images.githubusercontent.com/47445756/189482335-ecb69b67-5282-402b-89de-fa624ecdc8cf.png)
<p align="center">
  <em>Fig. 2: Overall Logical Flow of the Vital Sign Monitoring Project</em>  
</p>

![image](https://user-images.githubusercontent.com/47445756/189482345-42dc5205-8873-4c0d-a802-9330b4ee4eac.png)
<p align="center">
  <em>Fig. 3: Sequence Diagram of the Vital Sign Monitoring Project</em>  
</p>

![image](https://user-images.githubusercontent.com/47445756/189482367-0ec0985c-0597-4574-ab69-bfaf3e52761b.png)
<p align="center">
  <em>Fig. 4: Architecture flow of the Vital Sign Monitoring Project (Heart and Respiration Rate Monitoring)</em>  
</p>

The operation of the smartphone is as follows:
![image](https://user-images.githubusercontent.com/47445756/189482452-7cd9d83d-85c6-4413-95ab-1fc5759e92a0.png)


The validation of heart rate measurement with Mi-Band 3 is as follows:
![image](https://user-images.githubusercontent.com/47445756/189482463-cd7ec2db-b2d8-4b48-b2dc-888c21128c6d.png)
