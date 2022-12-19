#include <IFXRadarPulsedDoppler.h>
#include <LED.h>
float collector[10];
int flagger=0;
int counter=0;
int size_collect=100;

int global_var=0;

IFXRadarPulsedDoppler radarDev;
#define FRAME_SAMPLES 256
float raw_i[FRAME_SAMPLES];
float raw_q[FRAME_SAMPLES];
void myRawDataCallback(raw_data_context_t context)
{
  uint32_t frameCnt   = radarDev.getRawDataFrameCount(context);
  uint16_t numSamples = radarDev.getNumRawDataSamples(context);
  radarDev.getRawData(context, raw_i, raw_q, FRAME_SAMPLES);
  // use only one sample out of 32, so just one per frame
//  float x=raw_i[5];
  Serial.print(raw_i[0]);
  Serial.print("\t");
  Serial.println(raw_q[0]);
//  Serial.print(raw_i[15]);
//  Serial.print("\t");
//  Serial.println(raw_q[15]);
//  Serial.print(raw_i[31]);
//  Serial.print("\t");
//  Serial.println(raw_q[31]);
//
//  for(int i=0;i<16;i++){
//  Serial.print(raw_i[2*i]);
//  Serial.print("\t");
//  Serial.println(raw_q[2*i]);
//  }


//  Serial.write((byte)x);
//  Serial.println(x);
}


void setup() {
  Serial.begin(500000);
  radarDev.registerRawDataCallback(myRawDataCallback);  // register a handler to receive raw data
  radarDev.enableAlgoProcessing(false); // set to false to disables the lib internal radar algo processing
  // start the radarDevice, to read the default parameter
  radarDev.initHW();
  radarDev.begin();
  
  // Frame rate of 75Hz
  radarDev.setNumSamples(32);   // 32 Samples
  radarDev.setSampleFreq(5000);  
  radarDev.setSkipSamples(2);   // add 8 skip samples, to "burn" 4 msec before, so 40 Samples at 3kHz gives 75Hz
  
  // read minimum possible Frame period (after setting skip count!)
  uint32_t minFramePeriod = radarDev.getMinFramePeriod();
  // stop the device to change parameters
  radarDev.end();
  radarDev.setFramePeriod(minFramePeriod); 
  // Restart the radar device
  radarDev.begin();
}
void loop() {
  // put your main code here, to run repeatedly:
  radarDev.run();
//  float var=raw_i[2]*raw_i[2]+raw_q[2]*raw_q[2];
//  Serial.println(var);
////  Serial.write(b);
//  delay(10);
//
//---------------------------------------------------------------------------
//  if (counter<size_collect){
//      collector[counter]=raw_i[2];
//      delay(10);
//      counter=counter+1;
//    }
//  else
//  {
//      for(int i=0;i<size_collect;i++){
//        Serial.println(collector[i]);
//        delay(20);
//  }
//    counter=0;
//    }
 //--------------------------------------------------------------------------
//  for(int i=0;i<100;i++){
//  Serial.println(raw_i[i]);
//  delay(20);
//  }
//  Serial.write(25);
}
