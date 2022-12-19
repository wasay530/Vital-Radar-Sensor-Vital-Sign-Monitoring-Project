# vital_signs_instrument_project

-"sennse2gol_code" is intended to program the XMC4700 MCU on DEMO Sense2Gol Pulse board to get I/Q signals from radar transmission and reception signals.

-"raspberryPi_code" is intended to perform advanced signal processing (mainly using VMD) to estimate heart and breathing rate from I/Q signals from the Pulse board.

-"smartphone_code" is intended to create a flutter application over Android/iOS OS, to get the heart and breathing rate from raspbery pi. The communication used is in the form of beacons using BLE.

The overall logical flow of the project is as follows:

![image](https://user-images.githubusercontent.com/47445756/189482335-ecb69b67-5282-402b-89de-fa624ecdc8cf.png)


The sequence diagram of the project is as follows:
![image](https://user-images.githubusercontent.com/47445756/189482345-42dc5205-8873-4c0d-a802-9330b4ee4eac.png)


The architecture flow of the project is as follows:
![image](https://user-images.githubusercontent.com/47445756/189482367-0ec0985c-0597-4574-ab69-bfaf3e52761b.png)


The operation of the smartphone is as follows:
![image](https://user-images.githubusercontent.com/47445756/189482452-7cd9d83d-85c6-4413-95ab-1fc5759e92a0.png)


The validation of heart rate measurement with Mi-Band 3 is as follows:
![image](https://user-images.githubusercontent.com/47445756/189482463-cd7ec2db-b2d8-4b48-b2dc-888c21128c6d.png)
