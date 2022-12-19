
import os
import sys
import struct
import bluetooth._bluetooth as bluez
from scapy.layers import bluetooth
from scapy.contrib import eddystone
from scapy.contrib import ibeacon 
from scapy import compat
import serial
import numpy as np
from scipy.optimize import minimize
from numpy.random import rand
from scipy.signal import savgol_filter
from vmdpy import VMD
from scipy.signal import find_peaks
from scipy import signal
from numpy import array, sign, zeros
from scipy.interpolate import interp1d

LE_META_EVENT = 0x3e
OGF_LE_CTL=0x08
OCF_LE_SET_SCAN_ENABLE=0x000C

# these are actually subevents of LE_META_EVENT
EVT_LE_CONN_COMPLETE=0x01
EVT_LE_ADVERTISING_REPORT=0x02

def getBLESocket(devID):
    return bluez.hci_open_dev(devID)

def returnnumberpacket(pkt):
    myInteger = 0
    multiple = 256
    for i in range(len(pkt)):
        myInteger += struct.unpack("B",pkt[i:i+1])[0] * multiple
        multiple = 1
    return myInteger

def returnstringpacket(pkt):
    myString = "";
    for i in range(len(pkt)):
        myString += "%02x" %struct.unpack("B",pkt[i:i+1])[0]
    return myString

#def printpacket(pkt):
#    for i in range(len(pkt)):
#        sys.stdout.write("%02x " % struct.unpack("B",pkt[i:i+1])[0])

def get_packed_bdaddr(bdaddr_string):
    packable_addr = []
    addr = bdaddr_string.split(':')
    addr.reverse()
    for b in addr:
        packable_addr.append(int(b, 16))
    return struct.pack("<BBBBBB", *packable_addr)

def packed_bdaddr_to_string(bdaddr_packed):
    return ':'.join('%02x'%i for i in struct.unpack("<BBBBBB", bdaddr_packed[::-1]))

def hci_enable_le_scan(sock):
    hci_toggle_le_scan(sock, 0x01)

def hci_disable_le_scan(sock):
    hci_toggle_le_scan(sock, 0x00)

def hci_toggle_le_scan(sock, enable):
    cmd_pkt = struct.pack("<BB", enable, 0x00)
    bluez.hci_send_cmd(sock, OGF_LE_CTL, OCF_LE_SET_SCAN_ENABLE, cmd_pkt)

def hci_le_set_scan_parameters(sock):
    old_filter = sock.getsockopt( bluez.SOL_HCI, bluez.HCI_FILTER, 14)

def parse_events(sock, loop_count=100):
    old_filter = sock.getsockopt( bluez.SOL_HCI, bluez.HCI_FILTER, 14)
    flt = bluez.hci_filter_new()
    bluez.hci_filter_all_events(flt)
    bluez.hci_filter_set_ptype(flt, bluez.HCI_EVENT_PKT)
    sock.setsockopt( bluez.SOL_HCI, bluez.HCI_FILTER, flt )
    myFullList = []
    for i in range(0, loop_count):
        pkt = sock.recv(255)
        ptype, event, plen = struct.unpack("BBB", pkt[:3])
        if event == bluez.EVT_INQUIRY_RESULT_WITH_RSSI:
            i = 0
        elif event == bluez.EVT_NUM_COMP_PKTS:
            i = 0
        elif event == bluez.EVT_DISCONN_COMPLETE:
            i = 0
        elif event == LE_META_EVENT:
            subevent, = struct.unpack("B", pkt[3:4])
            pkt = pkt[4:]
            if subevent == EVT_LE_CONN_COMPLETE:
                le_handle_connection_complete(pkt)
            elif subevent == EVT_LE_ADVERTISING_REPORT:
                num_reports = struct.unpack("B", pkt[0:1])[0]
                report_pkt_offset = 0
                for i in range(0, num_reports):
                    # build the return string
                    Adstring = packed_bdaddr_to_string(pkt[report_pkt_offset + 3:report_pkt_offset + 9])
                    Adstring += ',' + returnstringpacket(pkt[report_pkt_offset -22: report_pkt_offset - 6])
                    #Adstring += ',' + "%i" % returnnumberpacket(pkt[report_pkt_offset -6: report_pkt_offset - 4])
                    Adstring += ',' + returnstringpacket(pkt[report_pkt_offset -6: report_pkt_offset - 4])
                    #Adstring += ',' + "%i" % returnnumberpacket(pkt[report_pkt_offset -4: report_pkt_offset - 2])
                    Adstring += ',' + returnstringpacket(pkt[report_pkt_offset -4: report_pkt_offset - 2])
                    try:
                        #Adstring += ',' + "%i" % struct.unpack("b", pkt[report_pkt_offset -2:report_pkt_offset -1])
                        Adstring += ',' + returnstringpacket(pkt[report_pkt_offset -2:report_pkt_offset -1])
                        #The last byte is always 00; we don't really need it
                        #Adstring += ',' + "%i" % struct.unpack("b", pkt[report_pkt_offset -1:report_pkt_offset])
                        #Adstring += ',' + returnstringpacket(pkt[report_pkt_offset -1:report_pkt_offset])
                    except: 1
                    #Prevent duplicates in results
                    if Adstring not in myFullList: myFullList.append(Adstring)
    sock.setsockopt( bluez.SOL_HCI, bluez.HCI_FILTER, old_filter )
    return myFullList

if __name__ == '__main__':
    dev_id = 0
    try:
        sock = bluez.hci_open_dev(dev_id)
        print("ble thread started")
    except:
        print("error accessing bluetooth device...")
        sys.exit(1)

    hci_le_set_scan_parameters(sock)
    hci_enable_le_scan(sock)
    indicator=0
    while True:
        returnedList = parse_events(sock, 10)
        print("----------")
        for beacon in returnedList:
            if(str(beacon[18:50])=='39ed98ff2900441a802f9c398fc199d2'):
                indicator=1;
                print("Hi")
                bt=bluetooth.BluetoothHCISocket(0)
                #-------------------------------------------------------------
                ser=serial.Serial('/dev/ttyACM0',500000,timeout=1)
                ser.flush()

                I_collector=[]
                Q_collector=[]
                indexer=0

                collect_limit=3200
                Fs=147 #Hz
                cauchy=0
                while indexer<=collect_limit+1:
                    if ser.in_waiting>0:
                        line=ser.readline().decode('utf-8').rstrip()
                        vec=line.split('\t')
                        I_temp=float(vec[0])
                        Q_temp=float(vec[1])

                        I_collector.append(I_temp)
                        Q_collector.append(Q_temp)
                        indexer+=1
                        if len(I_collector)==collect_limit:
                            I_n=I_collector
                            Q_n=Q_collector
                            
                            
                            def objective(x):
                                return np.sum((np.abs(I_n-x[0])**2.00+np.abs(Q_n-x[1])**2-x[2])**2.00)
                            
                            #Removing DC offset
                            r_min,r_max=-10.0,10.0
                            pt=r_min+rand(3)*(r_max-r_min)
                            result=minimize(objective,pt,method='Nelder-Mead',tol=1e-6)
                            solution=result['x']
                            I_n=I_n-solution[0]
                            Q_n=Q_n-solution[1]
                            
                            
                            #Smoothing
                            wind_len=41
                            order=2
                            I=savgol_filter(I_n,wind_len,order)
                            Q=savgol_filter(Q_n,wind_len,order)
                            N=len(I)
                            t=np.linspace(0,N/Fs,N)
                            
                            I=I[200:-1]
                            Q=Q[200:-1]
                            t=t[0:len(I)]

                            #VMD for heart rate
                            f_sig=I**2.0+Q**2.0
                            
                            alpha=1000
                            tau=0.0
                            K=4
                            DC=0
                            init=1
                            tol=1e-7
                            print("Hello")
                            
                            
                            u,u_hat,omega=VMD(f_sig,alpha,tau,K,DC,init,tol)
                            child=u[1,:]
                            child=child-np.mean(child)
                            print("Hello")
                            # Finding peaks of chosen IMF
                            max_hr_freq=130/60
                            max_hr_index=np.argmin(np.abs(t-1/max_hr_freq))
                            peaks,_=find_peaks(child,height=0,distance=max_hr_index)
                            
                            peak=0
                            for i in range(1,len(peaks)):
                                peak=peak+t[peaks[i]]-t[peaks[i-1]]
                                
                            heart_rate=((len(peaks)-1)/peak)*60
                            print("Heart Rate: ",heart_rate)                
                            
                            # Finding peaks of chosen IMF
                            max_hr_freq=130/60
                            max_hr_index=np.argmin(np.abs(t-1/max_hr_freq))
                            peaks,_=find_peaks(child,height=0,distance=max_hr_index)
                            
                            peak=0
                            for i in range(1,len(peaks)):
                                peak=peak+t[peaks[i]]-t[peaks[i-1]]
                                
                            heart_rate=((len(peaks)-1)/peak)*60
                            print("Heart Rate: ",heart_rate)
                            
                            # VMF for breathing rate
                            childer=u[2,:]
                            childer=childer-np.mean(childer)
                            
                            q_u = zeros(childer.shape)

                            u_x = [0,]
                            u_y = [childer[0],]


                            for k in range(1,len(childer)-1):
                                if (sign(childer[k]-childer[k-1])==1) and (sign(childer[k]-childer[k+1])==1):
                                    u_x.append(k)
                                    u_y.append(childer[k])


                            u_x.append(len(childer)-1)
                            u_y.append(childer[-1])

                            u_p = interp1d(u_x,u_y, kind = 'cubic',bounds_error = False, fill_value=0.0)

                            #Evaluate each model over the domain of (s)
                            for k in range(0,len(childer)):
                                q_u[k] = u_p(k)

                            q_u = savgol_filter(q_u,167,2)

                            # Finding peaks of chosen IMF
                            max_br_freq=20/60
                            max_br_index=np.argmin(np.abs(t-1/max_br_freq))
                            peaks,_=find_peaks(q_u,height=1*np.mean(q_u),distance=max_br_index)

                            peak=0
                            for i in range(1,len(peaks)):
                                peak=peak+t[peaks[i]]-t[peaks[i-1]]
                                
                            breathing_rate=((len(peaks)-1)/peak)*60
                            print("Breathing Rate: ",breathing_rate)
                            
                            cauchy=1
                    
                    if cauchy==1:
                        ser.close()
                        I_collector=[]
                        Q_collector=[]
                        indexer=0
                        break
            
            
        
                
                
                #-------------------------------------------------------------
                hr=heart_rate
                br=resp_rate
                hr_f=int(hr)
                hr_s=int(str(hr-int(hr))[2:4])
                br_f=int(br)
                br_s=int(str(br-int(br))[2:4])

                hr_f_h=str(hex(hr_f)[2:])
                if (len(hr_f_h))==1:
                    hr_f_h='0'+hr_f_h
                    
                hr_s_h=str(hex(hr_s)[2:])
                if (len(hr_s_h))==1:
                    hr_s_h='0'+hr_s_h
                    
                br_f_h=str(hex(br_f)[2:])
                if (len(br_f_h))==1:
                    br_f_h='0'+br_f_h
                    
                br_s_h=str(hex(br_s)[2:])
                if (len(br_s_h))==1:
                    br_s_h='0'+br_s_h
                    
                master_s=hr_f_h+hr_s_h+br_f_h+br_s_h


                ns=compat.hex_bytes('aabbccddeeff'+master_s)
                ins=compat.hex_bytes('112233445566')
                edy_UID=eddystone.Eddystone_UID(tx_power=0,namespace=ns,instance=ins,)
                edy_frame=eddystone.Eddystone_Frame()/edy_UID

                bt.sr(edy_frame.build_set_advertising_data())

                while 1==1:
                    #start advertising
                    bt.sr(bluetooth.HCI_Hdr()/
                          bluetooth.HCI_Command_Hdr()/
                          bluetooth.HCI_Cmd_LE_Set_Advertise_Enable(enable=True)
                        )
                    
        if (indicator==1):
            break;
