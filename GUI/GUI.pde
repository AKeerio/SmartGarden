import processing.serial.*;

Serial port;

boolean graphsBtnPressed;
boolean historyBtnPressed;
boolean backBtnPressed;
boolean cPanelBtnPressed;
boolean motorON;
boolean paused;
int numOfHumidityVals;
int numOfLightVals;
int numOfSoilVals;
int time;

float[] humidityData = new float[90];
float[] lightIntensityData = new float[90];
float[] soilData = new float[90];

float reading;

void setup()
{
   surface.setTitle("Graphs");
   size(1024,720);
   time = millis();
   graphsBtnPressed=false;
   historyBtnPressed=false;
   backBtnPressed=false;
   cPanelBtnPressed=false;
   paused=false;
   motorON=false;
   numOfHumidityVals=0;
   numOfLightVals=0;
   numOfSoilVals=0;
   
  //port = new Serial(this, Serial.list()[0], 9600); 
  //port.bufferUntil(10); 
}  

void serialEvent(Serial p) { 
  reading = p.read(); 
} 


void draw()
{
    background(255,255,255);
    fill(0);
    textSize(50);
    text("(IoT) Automated Irrigation System", 100, 150);
    drawGraphsBtn(); 
    drawHistoryBtn();
    drawCPanelBtn();
    
    if(graphsBtnPressed  && !backBtnPressed)
    {
      background(255);
      drawBackBtn(graphsBtnPressed);
      drawPauseBtn();
      drawHumidityGraph();
      drawSoilSensorGraph();
      drawLightIntesityGraph();
    }
  
  
    if(historyBtnPressed  && !backBtnPressed)
    {
      background(255);
      drawBackBtn(historyBtnPressed);
    }
    
    
    if(cPanelBtnPressed  && !backBtnPressed)
    {
      background(255);
      drawBackBtn(cPanelBtnPressed);
      drawMotorBtn();

    }
    
}


void drawGraphsBtn()
{
    int rectX=400;
    int rectY=260;
    int rectW = 200;
    int rectH=200;
    if(mouseX>=rectX && mouseX<=rectX+rectW && mouseY>=rectY && mouseY<=rectY+rectH)
    {
      fill(0, 102, 153, 51);
      rect(rectX, rectY, rectW, rectH, 10, 10, 10, 10);
      fill(255);
      textSize(20);
      text(" View \ngraphs", rectX+65, rectY+90);
      if(mousePressed)
      {
          graphsBtnPressed=true;
          backBtnPressed=false;
      }
    }else
    { 
      fill(0, 102, 153);
      rect(rectX, rectY, 200, 200, 10, 10, 10, 10);
      fill(255);
      textSize(20);
      text(" View \ngraphs", rectX+65, rectY+90);
    }
}

void drawHistoryBtn(){
    int rectX=700;
    int rectY=260;
    int rectW = 200;
    int rectH=200;
 if(mouseX>=rectX && mouseX<=rectX+rectW && mouseY>=rectY && mouseY<=rectY+rectH)
    {
      fill(0, 102, 153, 51);
      rect(rectX, rectY, rectW, rectH, 10, 10, 10, 10);
      fill(255);
      textSize(20);
      text(" View \nHistory", rectX+65, rectY+90);
      if(mousePressed)
      {
          historyBtnPressed=true;
          backBtnPressed=false;
      }
    }else
    { 
      fill(0, 102, 153);
      rect(rectX, rectY, 200, 200, 10, 10, 10, 10);
      fill(255);
      textSize(20);
      text(" View \nHistory", rectX+65, rectY+90);
    }
}

void drawCPanelBtn(){
    int rectX=100;
    int rectY=260;
    int rectW = 200;
    int rectH=200;
 if(mouseX>=rectX && mouseX<=rectX+rectW && mouseY>=rectY && mouseY<=rectY+rectH)
    {
      fill(0, 102, 153, 51);
      rect(rectX, rectY, rectW, rectH, 10, 10, 10, 10);
      fill(255);
      textSize(20);
      text("Control \n Panel", rectX+65, rectY+90);
      if(mousePressed)
      {
          cPanelBtnPressed=true;
          backBtnPressed=false;
      }
    }else
    { 
      fill(0, 102, 153);
      rect(rectX, rectY, 200, 200, 10, 10, 10, 10);
      fill(255);
      textSize(20);
      text("Control \n Panel", rectX+65, rectY+90);
    }
}

void drawBackBtn(boolean lastButtonPressed){
    int rectX=870;
    int rectY=10;
    int rectW =100;
    int rectH = 30;
    if(mouseX>=rectX && mouseX<=rectX+rectW && mouseY>=rectY && mouseY<=rectY+rectH)
    {
      fill(0, 102, 153, 51);
      rect(rectX,rectY, rectW, rectH, 10, 10, 10, 10);
      fill(255);
      textSize(18);
      text("Back", rectX+30, rectY+20);
      if(mousePressed)
      {
        backBtnPressed=true;
        if(lastButtonPressed==graphsBtnPressed)
              graphsBtnPressed=false;
        else if(lastButtonPressed==historyBtnPressed)
              historyBtnPressed=false;
        else if(lastButtonPressed==cPanelBtnPressed)
              cPanelBtnPressed=false;
      }
    }
    else
    {
      fill(0, 102, 153);
      rect(rectX,rectY, rectW, rectH, 10, 10, 10, 10);
      fill(255);
      textSize(18);
      text("Back", rectX+30, rectY+20);
    }
}

void drawPauseBtn(){
    int rectX=750;
    int rectY=10;
    int rectW =100;
    int rectH = 30;
    if(mouseX>=rectX && mouseX<=rectX+rectW && mouseY>=rectY && mouseY<=rectY+rectH)
    {
      fill(0, 102, 153, 51);
      rect(rectX,rectY, rectW, rectH, 10, 10, 10, 10);
      fill(255);
      textSize(18);
      text("Pause", rectX+25, rectY+20);
      if(mousePressed)
      {
        if(paused)
        paused=false;
        else
        paused=true;
      }
    }
    else
    {
      fill(0, 102, 153);
      rect(rectX,rectY, rectW, rectH, 10, 10, 10, 10);
      fill(255);
      textSize(18);
      text("Pause", rectX+25, rectY+20);
    }
}

void drawHumidityGraph(){
  int rectX =50;
  int rectY = 50;
  int rectW =920;
  int rectH=200;
  fill(0);
  textSize(15);
  text("Humidity", rectX, rectY-10);
  fill(255);
  rect(rectX, rectY, rectW, rectH);
  //line(rectX+rectW/2, rectY, rectX+rectW/2,rectY+rectH);
  line(rectX, rectY+rectH/2,rectX+rectW, rectY+rectH/2);
  
  fill(0);
  textSize(15);
  text("4 \n3 \n2 \n1 \n0", rectX-10, rectY+8);
  text("\n-1 \n-2 \n-3 \n-4", rectX-18, rectH-48);

  
  if (millis() > time + 100 && !paused)
  {  
      if(numOfHumidityVals<90)
      {
        humidityData[numOfHumidityVals]=random(-100,100);
        numOfHumidityVals++;
      }else
      {
        float temp[]=new float[90];
        for(int i=0;i<89;i++)
        {
          temp[i]=humidityData[i+1];
        }
        humidityData=temp;
        humidityData[numOfLightVals-1]=random(-100,100);
      }
      time = millis();
  }
  
  float lineWidth = (float) width/(100);
    for (int i=0; i<numOfHumidityVals-1; i++) {
      line(i*lineWidth+rectX, humidityData[i]+rectY+rectH/2, (i+1)*lineWidth+rectX, humidityData[i+1]+rectY+rectH/2);
    }
}

void drawLightIntesityGraph(){
  int rectX =50;
  int rectY = 280;
  int rectW =920;
  int rectH=200;
  fill(0);
  textSize(15);
  text("Soil moisture", rectX, rectY-10);
  fill(255);
  rect(rectX, rectY, rectW, rectH);
  //line(rectX+rectW/2, rectY, rectX+rectW/2,rectY+rectH);
  line(rectX, rectY+rectH/2,rectX+rectW, rectY+rectH/2);
  
  fill(0);
  textSize(15);
  text("4 \n3 \n2 \n1 \n0", rectX-10, rectY+8);
  text("\n-1 \n-2 \n-3 \n-4", rectX-18, rectY+rectH/2);
   
   if(!paused)
   {
    if(numOfLightVals<90)
    {
      lightIntensityData[numOfLightVals]=random(-100,100);
      numOfLightVals++;
    }else
    {
      float temp[]=new float[90];
      for(int i=0;i<89;i++)
      {
        temp[i]=lightIntensityData[i+1];
      }
      lightIntensityData=temp;
      lightIntensityData[numOfLightVals-1]=random(-100,100);
    }
   }
  float lineWidth = (float) width/(100);
  for (int i=0; i<numOfLightVals-1; i++) {
    line(i*lineWidth+rectX, lightIntensityData[i]+rectY+rectH/2, (i+1)*lineWidth+rectX, lightIntensityData[i+1]+rectY+rectH/2);
  }
}

void drawSoilSensorGraph(){  
  int rectX =50;
  int rectY = 510;
  int rectW =920;
  int rectH=200;
  fill(0);
  textSize(15);
  text("Light intensity", rectX, rectY-10);
  fill(255);
  rect(rectX, rectY, rectW, rectH);
  //line(rectX+rectW/2, rectY, rectX+rectW/2,rectY+rectH);
  line(rectX, rectY+rectH/2,rectX+rectW, rectY+rectH/2);  
   
  fill(0);
  textSize(15);
  text("4 \n3 \n2 \n1 \n0", rectX-10, rectY+8);
  text("\n-1 \n-2 \n-3 \n-4", rectX-18, rectY+rectH/2);
  
if(!paused)
{
    if(numOfSoilVals<90)
    {
      soilData[numOfSoilVals]=random(-100,100);
      numOfSoilVals++;
    }else
    {
      float temp[]=new float[90];
      for(int i=0;i<89;i++)
      {
        temp[i]=soilData[i+1];
      }
      soilData=temp;
      soilData[numOfLightVals-1]=random(-100,100);
    }

}
  float lineWidth = (float) width/(100);
  for (int i=0; i<numOfSoilVals-1; i++) {
    line(i*lineWidth+rectX, soilData[i]+rectY+rectH/2, (i+1)*lineWidth+rectX, soilData[i+1]+rectY+rectH/2);
  }
}

void drawMotorBtn()
{

    int rectX=100;
    int rectY=110;
    int rectW = 100;
    int rectH=50;
    if(!motorON)
      fill(0, 80, 0);
    else
      fill(0, 255, 0);
    rect(rectX, rectY, rectW, rectH, 10, 0, 0, 10);
    fill(255);
    textSize(20);
    text("ON", rectX+30, rectY+30);
    if(mouseX>=rectX && mouseX<=rectX+rectW && mouseY>=rectY && mouseY<=rectY+rectH)
      {    
        if(mousePressed)
        {
          motorON=true;
          fill(0, 255, 0);
          rect(rectX, rectY, rectW, rectH, 10, 0, 0, 10);
          fill(255);
          textSize(20);
          text("ON", rectX+30, rectY+30);

          //////////serial code here
        }
      }
    
    int rectX2=rectX+rectW;
    int rectY2=rectY;
    int rectW2 = 100;
    int rectH2=50;
    if(!motorON)
      fill(255, 0, 0);
    else
      fill(100, 0, 0);
    rect(rectX2, rectY2, rectW2, rectH2, 0, 10, 10, 0);
    fill(255);
    textSize(20);
    text("OFF", rectX2+30, rectY+30);
    if(mouseX>=rectX2 && mouseX<=rectX2+rectW2 && mouseY>=rectY2 && mouseY<=rectY2+rectH2)
      {
        
        if(mousePressed)
        {
          motorON=false;
          fill(255, 0, 0);
          rect(rectX2, rectY2, rectW2, rectH2, 0, 10, 10, 0);
          fill(255);
          textSize(20);
          text("OFF", rectX2+30, rectY+30);
          
          //////////serial code here
        }
      }
      
      if(motorON)
      {
          fill(0);
          textSize(20);
          text("Motor is On", 100, 100);
      }else
      {
        fill(0);
          textSize(20);
          text("Motor is Off", 100, 100);
      }
}