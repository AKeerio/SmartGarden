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

int delayHumidity;
int delayLight;
int delaySoil;
int delayTemp;
int delayPause;

float[] axisX;
float[] humidityData       = new float[100];
float[] lightIntensityData = new float[100];
float[] soilData           = new float[100];
float[] tempData           = new float[100];

String moistureReading;
String lightReading;
String humidityReading;
String tempReading;

XYChart lightIntensityChart;
XYChart humidityChart;
XYChart soilChart;
XYChart tempChart;

  
Table historyTable;

void setup()
{
   //MQTT Setup
   client = new MQTTClient(this);
   client.connect("mqtt://10.65.194.51:9003", "Sensor1");

   surface.setTitle("Graphs");
   size(1024,720);
   smooth();
   delayHumidity = millis();
   delayLight    = millis();
   delaySoil     = millis();
   delayTemp     = millis();
   delayPause    = millis();
   
   atMainMenu        = true;
   graphsBtnPressed  = false;
   historyBtnPressed = false;
   cPanelBtnPressed  = false;
   paused            = false;
   motorON           = false;
   
   flag1 = true;
   flag2 = false;
   flag3 = false;
   flag4 = false;
      
   lightIntensityChart = new XYChart(this);
   humidityChart       = new XYChart(this);
   soilChart           = new XYChart(this);
   tempChart           = new XYChart(this);
   
   numOfHumidityVals = 0;
   numOfLightVals    = 0;
   numOfSoilVals     = 0; 
   
   axisX=new float[100];
   for(int i=0;i<axisX.length;i++)
   {
     axisX[i]=i*1;
   }
   
   historyTable=new Table();
   printArray(Serial.list());
   String portName = Serial.list()[0];
   port = new Serial(this, portName, 9600); 
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
      drawTable();
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
        atMainMenu=true;
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
      delayPause=millis()-delayPause;
      if(mousePressed&&delayPause>100)
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
  delayHumidity=millis()-delayHumidity;
  if(!paused && delayHumidity>100)
   {
    if(numOfHumidityVals<100)
    {
      humidityData[numOfHumidityVals]=Float.parseFloat(humidityReading);
      numOfHumidityVals++;
    }else
    {
      float temp[]=new float[100];
      for(int i=0;i<99;i++)
      {
        temp[i]=humidityData[i+1];
      }
      humidityData=temp;
      humidityData[numOfHumidityVals-1]=Float.parseFloat(humidityReading);
    }
    
     humidityChart.setData(axisX, humidityData); 
     delayHumidity=millis();
   }
   
 // lineChart.showXAxis(true); 
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
      float temp[]=new float[100];
      for(int i=0;i<99;i++)
      {
        temp[i]=lightIntensityData[i+1];
      }
      lightIntensityData=temp;
      lightIntensityData[numOfLightVals-1]=Float.parseFloat(lightReading);
    }
    
     lightIntensityChart.setData(axisX, lightIntensityData); 
   }
   
 // lineChart.showXAxis(true); 
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
      float temp[]=new float[100];
      for(int i=0;i<99;i++)
      {
        temp[i]=soilData[i+1];
      }
      soilData=temp;
      soilData[numOfSoilVals-1]=Float.parseFloat(moistureReading);
    }
    
     soilChart.setData(axisX, soilData); 
   }
   
 // lineChart.showXAxis(true); 
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
      float temp[]=new float[100];
      for(int i=0;i<99;i++)
      {
        temp[i]=tempData[i+1];
      }
      tempData=temp;
      tempData[numOfTempVals-1]=Float.parseFloat(tempReading);
    }
    
     tempChart.setData(axisX, tempData); 
   }
   
 // lineChart.showXAxis(true); 
  tempChart.showYAxis(true); 
  tempChart.setMinY(0);
  
  // Symbol colours
  tempChart.setPointColour(color(180,50,50,100));
  tempChart.setPointSize(5);
  tempChart.setLineWidth(2);
  tempChart.draw(rectX,rectY,width/2-30,height/2-70);
}

void drawTable()
{
  historyTable.addColumn("Ref#");
  historyTable.addColumn("Date/Time");
  historyTable.addColumn("Device");
  historyTable.addColumn("Duration");
  
  TableRow newRow = historyTable.addRow();
  newRow.setInt("Ref#", historyTable.lastRowIndex());
  newRow.setString("Date/Time", "Today");
  newRow.setString("Device", "Motor 1");
  newRow.setString("Duration", "60");
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