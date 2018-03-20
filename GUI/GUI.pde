import processing.serial.*;
import org.gicentre.utils.stat.*;
import mqtt.*;

Serial port;
MQTTClient client;

boolean atMainMenu;
boolean graphsBtnPressed;
boolean historyBtnPressed;
boolean cPanelBtnPressed;
boolean motorON;
boolean paused;

boolean flag1;
boolean flag2;
boolean flag3;
boolean flag4;

int numOfHumidityVals;
int numOfLightVals;
int numOfSoilVals;
int numOfTempVals;

double delayPause;

float[] axisX;
float[] humidityData       = new float[100];
float[] lightIntensityData = new float[100];
float[] soilData           = new float[100];
float[] tempData           = new float[100];

  
ArrayList<String> humidityList;
ArrayList<String> lightIntensityList;
ArrayList<String> soilList;
ArrayList<String> tempList;

String moistureReading;
String lightReading;
String humidityReading;
String tempReading;

XYChart lightIntensityChart;
XYChart humidityChart;
XYChart soilChart;
XYChart tempChart;

void setup()
{
   surface.setTitle("Graphs");
   size(1024,720);
   smooth();
   
   //MQTT Setup
   client = new MQTTClient(this);
   client.connect("mqtt://10.65.194.51:9003", "Sensor1");
   
   lightIntensityList = new ArrayList<String>();
   humidityList = new ArrayList<String>();
   soilList = new ArrayList<String>();
   tempList = new ArrayList<String>();
      
   delayPause    = millis();
   
   atMainMenu        = true;
   graphsBtnPressed  = false;
   historyBtnPressed = false;
   cPanelBtnPressed  = false;
   paused   = false;
   motorON  = false;
   
   flag1 = true;
   flag2 = false;
   flag3 = false;
   flag4 = false;
      
   lightIntensityChart = new XYChart(this);
   humidityChart       = new XYChart(this);
   soilChart = new XYChart(this);
   tempChart = new XYChart(this);
   
   lightIntensityChart.setMaxY(1000);
   humidityChart.setMaxY(500);
   soilChart.setMaxY(250);
   tempChart.setMaxY(30);
   
   
   numOfHumidityVals = 0;
   numOfLightVals = 0;
   numOfSoilVals  = 0; 
   
   axisX=new float[100];
   
   for(int i=0;i<axisX.length;i++)
   {
     axisX[i]=i*1;
   }
   
   moistureReading="";
   lightReading="";
   humidityReading="";
   tempReading="";
   
   printArray(Serial.list());
   //String portName = Serial.list()[0];
  // port = new Serial(this, portName, 9600); 
}  

void serialEvent(Serial p) { 
  boolean isAdded = false;
  String valueRead = p.readStringUntil('\n');
  if (valueRead == null)
  {
     isAdded = true;
  }  
  else if (flag1 == true && isAdded == false)
  {
    isAdded = true;
    moistureReading = valueRead; 
    
    if(!moistureReading.equals(soilList.get(0))&&!paused);
      soilList.add(0,moistureReading);
    
    client.publish("moisture", moistureReading);
    print("Flag 1 is: ");
    println(moistureReading);
    flag1 = false;
    flag2 = true;
  }
   else if (flag2 == true && isAdded == false)
  {
    isAdded = true;
   lightReading = valueRead;
   
   if(!lightReading.equals(lightIntensityList.get(0))&&!paused)
     lightIntensityList.add(0,lightReading);
     
   client.publish("light", lightReading);
   print("Flag 2 is: ");
   println(lightReading);
    flag2 = false;
    flag3 = true;
  }
   else if (flag3 == true && isAdded == false)
  {
    isAdded = true;
    humidityReading = valueRead;
    
    if(!humidityReading.equals(humidityList.get(0))&&!paused)
      humidityList.add(0,humidityReading);
    
    client.publish("humidity", humidityReading);
    print("Flag 3 is: ");
     println(humidityReading);
    flag3 = false;
    flag4 = true;
  }
  else if (flag4 == true && isAdded == false)
  {
    isAdded = true;
    tempReading = valueRead;
    
    if(!tempReading.equals(tempList.get(0))&&!paused);
      tempList.add(0,tempReading);
    
    client.publish("temp", tempReading);
    print("Flag 4 is: ");
    println(tempReading);
    flag4 = false;
    flag1 = true;
  }
  
}  

void draw()
{
    background(255,255,255);
    fill(0);
    textSize(50);
    text("(IoT) Automated Irrigation System", 100, 150);
    button(400,260,200,200,65,90," View \ngraphs","graph");
    button(700,260,200,200,65,90," View \nHistory","history");
    button(100,260,200,200,65,90,"Control \n Panel","cpanel");

    if(graphsBtnPressed  && !atMainMenu)
    {
      background(255);
      drawBackBtn(graphsBtnPressed);
      drawPauseBtn();
      stroke(200);
      line(width/2,50,width/2,height);
      stroke(200);
      line(0,height/2,width,height/2);
      drawHumidityGraph();
      drawSoilSensorGraph();
      drawLightIntesityGraph();
      drawTempSensorGraph();
    }

    if(historyBtnPressed  && !atMainMenu)
    {
      background(255);
      drawBackBtn(historyBtnPressed);
      drawPauseBtn();
      drawSensorHistory();
    }
     
    if(cPanelBtnPressed  && !atMainMenu)
    {
      background(255);
      drawBackBtn(cPanelBtnPressed);
      drawMotorBtn();
    }    
}

void button(int rectX,int rectY, int rectW,int rectH, int txtOffsetX, int txtOffsetY, String name, String id)
{
  if(mouseX>=rectX && mouseX<=rectX+rectW && mouseY>=rectY && mouseY<=rectY+rectH)
    {
      fill(0, 102, 153, 51);
      rect(rectX, rectY, rectW, rectH, 10, 10, 10, 10);
      fill(255);
      textSize(20);
      text(name, rectX+txtOffsetX, rectY+txtOffsetY);
      if(mousePressed&&atMainMenu)
      {       
        if(id=="graph")
        {
            graphsBtnPressed=true; 
            historyBtnPressed=false;
            cPanelBtnPressed=false;
        }
        
        if(id=="history")
        {
          graphsBtnPressed=false; 
            historyBtnPressed=true;
            cPanelBtnPressed=false;
        }
        
        if(id=="cpanel")
        {
          graphsBtnPressed=false; 
            historyBtnPressed=false;
            cPanelBtnPressed=true;
        }
          atMainMenu=false;
          atMainMenu=false;
       }
    }else
    { 
      fill(0, 102, 153);
      rect(rectX, rectY, 200, 200, 10, 10, 10, 10);
      fill(255);
      textSize(20);
      text(name, rectX+65, rectY+90);
    }
  
}

void drawBackBtn(boolean lastButtonPressed){
    int rectX=910;
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
        if(lastButtonPressed==graphsBtnPressed)
              graphsBtnPressed=false;
        else if(lastButtonPressed==historyBtnPressed)
              historyBtnPressed=false;
        else if(lastButtonPressed==cPanelBtnPressed)
              cPanelBtnPressed=false;
              atMainMenu=true;
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
    int rectX=800;
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
      if(mousePressed&&millis()-delayPause>200)
      {
        if(paused)
        paused=false;
        else
        paused=true;
        
        delayPause=millis();
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
  int rectX =20;
  int rectY = 50;
  fill(0);
  textSize(15);
  text("Humidity", rectX, rectY);
  fill(255);
  if(!paused)
   {
    if(numOfHumidityVals<100)
    {
      humidityData[numOfHumidityVals]=Float.parseFloat(humidityReading);
      numOfHumidityVals++;
    }else
    {
      arrayCopy(humidityData, 1, humidityData, 0, humidityData.length-1);
      humidityData[numOfHumidityVals-1]=Float.parseFloat(humidityReading);
    }
    
     humidityChart.setData(axisX, humidityData); 
   }
   
  humidityChart.showYAxis(true); 
  humidityChart.setMinY(0);
  
  // Symbol colours
  humidityChart.setPointColour(color(180,50,50,100));
  humidityChart.setPointSize(5);
  humidityChart.setLineWidth(2);
  humidityChart.draw(rectX,rectY,width/2-30,height/2-70);
}


void drawLightIntesityGraph(){
  int rectX =width/2+15;
  int rectY = 50;
  fill(0);
  textSize(15);
  text("Light Intensity", rectX, rectY);
  fill(255);
  if(!paused)
   {
    if(numOfLightVals<100)
    {
      lightIntensityData[numOfLightVals]=Float.parseFloat(lightReading);
      numOfLightVals++;
    }else
    {
      arrayCopy(lightIntensityData, 1, lightIntensityData, 0, lightIntensityData.length-1);
      lightIntensityData[numOfLightVals-1]=Float.parseFloat(lightReading);
    }
    
     lightIntensityChart.setData(axisX, lightIntensityData); 
   }
    
  lightIntensityChart.showYAxis(true); 
  lightIntensityChart.setMinY(0);
  
  // Symbol colours
  lightIntensityChart.setPointColour(color(180,50,50,100));
  lightIntensityChart.setPointSize(5);
  lightIntensityChart.setLineWidth(2);
  lightIntensityChart.draw(rectX,rectY,width/2-30,height/2-70);
}

void drawSoilSensorGraph(){  
  int rectX =20;
  int rectY = height/2+20;

  fill(0);
  textSize(15);
  text("Soil Moisture", rectX, rectY);
  fill(255);

  if(!paused)
   {
    if(numOfSoilVals<100)
    {
      soilData[numOfSoilVals]=Float.parseFloat(moistureReading);
      numOfSoilVals++;
    }else
    {
      arrayCopy(soilData, 1, soilData, 0, soilData.length-1);
      soilData[numOfSoilVals-1]=Float.parseFloat(moistureReading);
    }
    
     soilChart.setData(axisX, soilData); 
   }
   
  soilChart.showYAxis(true); 
  soilChart.setMinY(0);
  
  // Symbol colours
  soilChart.setPointColour(color(180,50,50,100));
  soilChart.setPointSize(5);
  soilChart.setLineWidth(2);
  soilChart.draw(rectX,rectY,width/2-30,height/2-70);
}

void drawTempSensorGraph(){  
  int rectX =width/2+20;
  int rectY = height/2+20;

  fill(0);
  textSize(15);
  text("Temperature", rectX, rectY);
  fill(255);

  if(!paused)
   {
    if(numOfTempVals<100)
    {
      tempData[numOfTempVals]=Float.parseFloat(tempReading);
      numOfTempVals++;
    }else
    {
      arrayCopy(tempData, 1, tempData, 0, tempData.length-1);
      tempData[numOfTempVals-1]=Float.parseFloat(tempReading);
    }
    
     tempChart.setData(axisX, tempData); 
   }
   
  tempChart.showYAxis(true); 
  tempChart.setMinY(0);
  
  // Symbol colours
  tempChart.setPointColour(color(180,50,50,100));
  tempChart.setPointSize(5);
  tempChart.setLineWidth(2);
  tempChart.draw(rectX,rectY,width/2-30,height/2-70);
}

void drawSensorHistory()
{
      rect(15,50,width/2+100,height-60,10);
      rect(width/2+130,50,370,height-60,10);
      line(15,85,width/2+115,85);
      line(width/2+130,85,1011,85);
      fill(0);
      textSize(15);
      text("Temperature", 50, 75); 
      text("Light Intensity", 200, 75); 
      text("Humidity", 390, 75); 
      text("Moisture", 530, 75); 
      text("Device", 680, 75);       
      text("Duration", 800, 75); 
      text("Time", 930, 75); 
      
      //For testing history window
      /*if(!paused)
      {
      humidityList.add(0,random(0,500)+"");
      lightIntensityList.add(0,random(0,1000)+"");
      soilList.add(0,random(0,100)+"");
      tempList.add(0,random(0,30)+"");
      }
  */
      if(tempList.size()>40)
      tempList.remove(40);
      for(int i=0;i<tempList.size();i++)
      {
        text(tempList.get(i), 50, 100+(i*15)); 
      }    
      
      if(lightIntensityList.size()>40)
      lightIntensityList.remove(40);
      for(int i=0;i<lightIntensityList.size();i++)
      {
        text(lightIntensityList.get(i), 200, 100+(i*15)); 
      }
      
      if(humidityList.size()>40)
      humidityList.remove(40);
      for(int i=0;i<humidityList.size();i++)
      {
        text(humidityList.get(i), 390, 100+(i*15)); 
      }
      
      if(soilList.size()>40)
      soilList.remove(40); 
      
      for(int i=0;i<soilList.size();i++)
      {
        text(soilList.get(i), 530, 100+(i*15)); 
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

          //////////send to serial port here
        }
      }
    
    int rectX2=rectX+rectW-1;
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
          
          //////////send to serial port here
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