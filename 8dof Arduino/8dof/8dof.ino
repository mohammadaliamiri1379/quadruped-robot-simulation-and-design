#define FREE 0
#define CONTROL 1

#include <Encoder.h>
int mode = 0;
double miliSecendTimeSampling = 2;
struct MMotor{
  
  int pwm_pin_RL; 
  int pwm_pin;
  int enc1_pin;
  int enc2_pin;
  Encoder *encoder;
  double enc_data , enc_data_past;
  double v_motor;
  double val;
  int bias_deadband =  0;
  double error;
  double p_err;
  double s_err;
  double Ki;
  double Kp;
  double Kd;
  double Ku;
  double Kv;
  double sat_err;
  double output;
  const int s_err_threshold = 200;
  const int max_val_motor = 200 - 15;
  bool auto_set_k  = 0;
  double readEncoder(){
    enc_data = encoder->read()/4.0;
    return enc_data;
  }
  
  double findVal(double setpoint){

    
      p_err = error; 
     error = setpoint - enc_data;
     if(auto_set_k == 1){ 
     if(error < 10){

        Kp = 39;
        Ki = 1950;
        Kd = 0.195;
      }
      else{
        Kp = 15;
        Ki = 10;
        Kd = 0.195;
      }
     }

     s_err = s_err + (error * Ki  + sat_err * Ku) * miliSecendTimeSampling/1000 ;
     
     if(abs(s_err) > s_err_threshold) 
       s_err = abs(s_err)/s_err  * s_err_threshold;
     
     double ud = (error - p_err) * 1000 /  miliSecendTimeSampling; 
      
     double control_withoutsat_val = error * Kp + s_err - Kv * v_motor + ud * Kd ;  
     val = max(min(control_withoutsat_val,max_val_motor),-max_val_motor);
     
     sat_err =  val - control_withoutsat_val;
    
    return val;
  
  }
  
 void pwmWrite(){
    if(mode == CONTROL){
        if(val <= 0){
          if(val < -2){
            output = val - bias_deadband;
            analogWrite(pwm_pin, -val + bias_deadband);  
            digitalWrite(pwm_pin_RL, LOW);
          }
          else{
            output = val;
            analogWrite(pwm_pin, -val );  
            digitalWrite(pwm_pin_RL, LOW);
            
          }
        }
        else if(val > 0)
        {
          if(val > 2){
          output = val + bias_deadband;
          
          analogWrite(pwm_pin, 255 - val - bias_deadband);
          digitalWrite(pwm_pin_RL, HIGH);
          }
          else {
            output = val;
          
            analogWrite(pwm_pin, 255 - val );
            digitalWrite(pwm_pin_RL, HIGH);
          }
        
        }
        
        
    }
    else if(mode == FREE){
             output = 0;
   
        analogWrite(pwm_pin, 0);
          digitalWrite(pwm_pin_RL, LOW);
        
    }
      
  }
  
  void initial(int _pwm_pin , int _pwm_pin_RL , int _enc1_pin , int _enc2_pin ){
    pwm_pin_RL = _pwm_pin_RL; 
    pwm_pin = _pwm_pin;
    enc1_pin = _enc1_pin;
    enc2_pin = _enc2_pin;
    enc_data = 0;
    enc_data_past = 0;
    v_motor = 0;
    val = 0;
    error = 0;
    s_err = 0;
    p_err = 0;
    Ki = 0;
    Kp = 0;
    Ku = 0;
    Kv = 0;
    Kd = 0;
    sat_err = 0;
    
    pinMode(enc1_pin , INPUT);
    pinMode(enc2_pin , INPUT);
    pinMode(pwm_pin_RL,OUTPUT);
    pinMode(pwm_pin_RL,OUTPUT);

    encoder = new Encoder(enc1_pin , enc2_pin);
   encoder->write(0);
      
  }
  
  void reset(){
    enc_data = 0;
    enc_data_past = 0;
    v_motor = 0;
    val = 0;
    error = 0;
    s_err = 0;
    p_err = 0;
    Ki = 0;
    Kp = 0;
    Ku = 0;
    Kv = 0;
    Kd = 0;
    sat_err = 0;
    encoder->write(0);
  }
  
  
};






struct BAZO2dof{
  MMotor *m1;
  MMotor *m2;
  
};

int ledPin = 13; // LED connected to digital pin 13

double vtime1 = 0, time1=0 , time2=0 , setPointTime =0;
double printTime1 =0 , printTime2 = 0;
double dtime;

int setPoint1 = 0 , setPoint2=0 , setPoint3 = 0 , setPoint4 = 0 ,setPoint5 = 0 , setPoint6 = 0 , setPoint7 = 0 , setPoint8 = 0  ;

MMotor m1 , m2 , m3 , m4 , m5 , m6 , m7 , m8;


 
///
char myBuf[1000] ,  len = 0;
void serialEvent(){
  
  if(Serial.available()>1 ){
     len = Serial.readBytes(myBuf ,1 );
     if(myBuf[0] == 'S' ){
        len = Serial.readBytes(myBuf ,17 );
        if(len >= 17){
          setPoint1 = ((int)(myBuf[0]) + ((int)myBuf[1])*64)-768;
          setPoint2 = ((int)(myBuf[2]) + ((int)myBuf[3])*64)-768;
          setPoint3 = ((int)(myBuf[4]) + ((int)myBuf[5])*64)-768;
          setPoint4 = ((int)(myBuf[6]) + ((int)myBuf[7])*64)-768;
          setPoint5 = ((int)(myBuf[8]) + ((int)myBuf[9])*64)-768;
          setPoint6 = ((int)(myBuf[10]) + ((int)myBuf[11])*64)-768;
          setPoint7 = ((int)(myBuf[12]) + ((int)myBuf[13])*64)-768;
          setPoint8 = ((int)(myBuf[14]) + ((int)myBuf[15])*64)-768;
          
          mode = 1;
          setPointTime = micros();
          Serial.print('A');
          //EncoderMotor1.write(0);
          //EncoderMotor2.write(0);
      
        }
     }
     
     else if(myBuf[0] == 'O'){
       setPoint1 = 0;
       setPoint2 = 0;
       setPoint3 = 0;
       setPoint4 = 0;
       setPoint5 = 0;
       setPoint6 = 0;
       setPoint7 = 0;
       setPoint8 = 0;
       
       m1.reset();
       m2.reset();
       m3.reset();
       m4.reset();
       m5.reset();
       m6.reset();
       m7.reset();
       m8.reset();
          
     }
  }
}


void setup()
{
  
  Serial.begin(115200);

  m1.initial(3,53,48, 49);//pwm1 , pwmRL1 , enc1_intrupt , enc2
  m2.initial(2,52,50, 51);//pwm2 , pwmRL2 , enc3_intrupt , enc4
  m3.initial(5,47,22, 23);//pwm1 , pwmRL1 , enc1_intrupt , enc2
  m4.initial(4,46,44, 45);//pwm2 , pwmRL2 , enc3_intrupt , enc4
  m5.initial(10,25,36, 37);//pwm1 , pwmRL1 , enc1_intrupt , enc2
  m6.initial(6,24,38, 39);//pwm2 , pwmRL2 , enc3_intrupt , enc4
  m7.initial(9,35,30, 31);//pwm1 , pwmRL1 , enc1_intrupt , enc2
  m8.initial(11,34,32, 33);//pwm2 , pwmRL2 , enc3_intrupt , enc4

  //pinMode(interruptPin1, INPUT);
  double myP = 21;
  m1.Ki = 466; m1.Kp = 21; m1.Kv = 0; m1.Ku = 0.0; m1.Kd = 0.5;
  m2.Ki = 1950; m2.Kp = 39; m2.Kv = 0; m2.Ku = 0.0; m2.Kd = 0.195;
 //m2.auto_set_k = 1; 
  
  
  m3.Ki = 466; m3.Kp = myP; m3.Kv = 0; m3.Ku = 0.0; m3.Kd = 0.7;
  m4.Ki = 466; m4.Kp = myP; m4.Kv = 0; m4.Ku = 0.0; m4.Kd = 0.7;
  m5.Ki = 466; m5.Kp = myP; m5.Kv = 0; m5.Ku = 0.0; m5.Kd = 0.7;
  m6.Ki = 466; m6.Kp = myP; m6.Kv = 0; m6.Ku = 0.0; m6.Kd = 0.7;
  m7.Ki = 466; m7.Kp = myP; m7.Kv = 0; m7.Ku = 0.0; m7.Kd = 0.7;
  m8.Ki = 466; m8.Kp = myP; m8.Kv = 0; m8.Ku = 0.0; m8.Kd = 0.7;
  
  //m5.Ki = 0.2; m5.Kp = 7; m5.Kv = 0; m5.Ku = 0.0; m5.Kd = 0.2;
  //m6.Ki = 0.5; m6.Kp = 15; m6.Kv = 0; m6.Ku = 0.0; m6.Kd = 0.2;//0.3;
  //m7.Ki = 0.2; m7.Kp = 7; m7.Kv = 0; m7.Ku = 0.0; m7.Kd = 0.2;
  //m8.Ki = 0.5; m8.Kp = 15; m8.Kv = 0; m8.Ku = 0.0; m8.Kd = 0.2;
  
  
  setPoint1 = 0;
  setPoint2 = 0;
  setPoint3 = 0;
  setPoint4 = 0;
  setPoint5 = 0;
  setPoint6 = 0;
  setPoint7 = 0;
  setPoint8 = 0;
  
  delay(500);
}




void loop()
{
 time2 = micros();
 if(time2-time1>=1000*miliSecendTimeSampling){
    dtime = time2-time1;
    time1 = time2;
  
   /// motors set control signal
    m1.findVal(setPoint1);
    m2.findVal(setPoint2);
    m3.findVal(setPoint3);
    m4.findVal(setPoint4);
    m5.findVal(setPoint5);
    m6.findVal(setPoint6);
    m7.findVal(setPoint7);
    m8.findVal(setPoint8);
   //m5.val = 0;
   //m6.val = 0; 
  /// motors write pwm
    m1.pwmWrite();
    m2.pwmWrite();
    m3.pwmWrite();
    m4.pwmWrite();
    m5.pwmWrite();
    m6.pwmWrite();
    m7.pwmWrite();
    m8.pwmWrite();
  
    
   if(time2 - setPointTime >= 600*1000 * 1000)
      mode = FREE;
   if(setPoint1 == -1 && setPoint2 == -1 &&setPoint3 == -1 && setPoint4 == -1 && setPoint5 == -1 && setPoint6 == -1 && setPoint7 == -1 && setPoint8 == -1)
      mode = FREE;
  
  /// read encoders
    m1.readEncoder();
    m2.readEncoder();
    m3.readEncoder();
    m4.readEncoder();
    m5.readEncoder();
    m6.readEncoder();
    m7.readEncoder();
    m8.readEncoder();
    
  
    
    //if(time2-time1>=miliSecendTimeSampling*10){
    //  dtime = time2-time1;
    //  time1 = time2;
    //  time2 = millis();
    
    m1.v_motor = max(min((m1.enc_data - m1.enc_data_past) / dtime , 10) , -10) ;
    m2.v_motor = max(min((m2.enc_data - m2.enc_data_past) / dtime, 10) , -10);
    m3.v_motor = max(min((m3.enc_data - m3.enc_data_past) / dtime , 10) , -10) ;
    m4.v_motor = max(min((m4.enc_data - m4.enc_data_past) / dtime, 10) , -10);
    m5.v_motor = max(min((m5.enc_data - m5.enc_data_past) / dtime , 10) , -10) ;
    m6.v_motor = max(min((m6.enc_data - m6.enc_data_past) / dtime, 10) , -10);
    m7.v_motor = max(min((m7.enc_data - m7.enc_data_past) / dtime, 10) , -10);
    m8.v_motor = max(min((m8.enc_data - m8.enc_data_past) / dtime, 10) , -10);

    m1.enc_data_past = m1.enc_data;
    m2.enc_data_past = m2.enc_data;
    m3.enc_data_past = m3.enc_data;
    m4.enc_data_past = m4.enc_data;
    m5.enc_data_past = m5.enc_data;
    m6.enc_data_past = m6.enc_data;
    m7.enc_data_past = m7.enc_data;
    m8.enc_data_past = m8.enc_data;
    

    if(time2-printTime1>=miliSecendTimeSampling*5*1000){
      printTime1 = time2;
      time2 = micros();
    
      /// - 12*64 <Tsum < 12 * 64 =768
      /// -768 <enc_data<768 (-360 to 360 degree)          
      char c1[8],c2[8];
      c1[0] = ((int)m1.enc_data+ 768) % 64 ;
      c2[0] = ((int)m1.enc_data+ 768)/64;
      c1[1] = ((int)m2.enc_data + 768) % 64 ;
      c2[1] = ((int)m2.enc_data  + 768)/64;
      
      c1[2] = ((int)m1.output+ 768) % 64 ;
      c2[2] = ((int)m1.output+ 768)/64;
      c1[3] = ((int)m2.output+ 768) % 64 ;
      c2[3] = ((int)m2.output  + 768)/64;
  
      c1[4] = ((int)m5.enc_data + 768) % 64 ;
      c2[4] = ((int)m5.enc_data + 768)/64;
      c1[5] = ((int)m6.enc_data + 768) % 64 ;
      c2[5] = ((int)m6.enc_data  + 768)/64;


      c1[6] = ((int)m7.enc_data + 768) % 64 ;
      c2[6] = ((int)m7.enc_data + 768)/64;
      c1[7] = ((int)m8.enc_data + 768) % 64 ;
      c2[7] = ((int)m8.enc_data + 768)/64;
  
  /*    c1[0] = ((int)setPoint1 + 768) % 64 ;
      c2[0] = ((int)setPoint1 + 768)/64;
      c1[1] = ((int)setPoint2  + 768) % 64 ;
      c2[1] = ((int)setPoint2  + 768)/64;
      
      c1[2] = ((int)setPoint3 + 768) % 64 ;
      c2[2] = ((int)setPoint3 + 768)/64;
      c1[3] = ((int)setPoint4  + 768) % 64 ;
      c2[3] = ((int)setPoint4  + 768)/64;
  */
      Serial.print('S');
      Serial.print(c1[0]);
      Serial.print(c2[0]);
      Serial.print(c1[1]);
      Serial.print(c2[1]);
      Serial.print(c1[2]);
      Serial.print(c2[2]);
      Serial.print(c1[3]);
      Serial.print(c2[3]);
      Serial.print(c1[4]);
      Serial.print(c2[4]);
      Serial.print(c1[5]);
      Serial.print(c2[5]);
      Serial.print(c1[6]);
      Serial.print(c2[6]);
      Serial.print(c1[7]);
      Serial.print(c2[7]);
      
      Serial.print('E');
      
    }
 }
}
