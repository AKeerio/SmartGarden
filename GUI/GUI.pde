import processing.serial.*;
import org.gicentre.utils.stat.*;
import mqtt.*;

Serial port;
MQTTClient client;

boolean atMainMenu;
boolean graphsBtnPressed;
boolean historyBtnPressed;
boolean cPanelBtnPressed;
boolean device1BtnPressed;
boolean device2BtnPressed;
boolean motorON;
boolean paused;

boolean flag1;
boolean flag2;
boolean flag3;
boolean flag4;
boolean flag5;
boolean flag6;
boolean flag7;
boolean flag8;

int numOfHumidityVals;
int numOfLightVals;
int numOfTempVals;

int numOfHumidityVals2;
int numOfLightVals2;
int numOfTempVals2;
int numOfSoilVals2;

double delayPause;

float[] axisX;
float[] humidityData        = new float[100];
float[] lightIntensityData  = new float[100];
float[] tempData            = new float[100];

float[] humidityData2       = new float[100];
float[] lightIntensityData2 = new float[100];
float[] tempData2           = new float[100];
float[] soilData2           = new float[100];

ArrayList<String> humidityList;
ArrayList<String> lightIntensityList;
ArrayList<String> tempList;
ArrayList<String> humidityList2;
ArrayList<String> lightIntensityList2;
ArrayList<String> soilList2;
ArrayList<String> tempList2;

String lightReading1;
String humidityReading1;
String tempReading1;

String moistureReading2;
String lightReading2;
String humidityReading2;
String tempReading2;


XYChart lightIntensityChart;
XYChart humidityChart;
XYChart soilChart;
XYChart tempChart;

void setup()
{
  surface.setTitle("Graphs");
  size(1024, 720);
  smooth();

  //MQTT Setup
  client = new MQTTClient(this);
  client.connect("mqtt://10.65.192.114:9003", "Sensor1");
  client.subscribe("sprinkler");

  lightIntensityList = new ArrayList<String>();
  humidityList = new ArrayList<String>();
  tempList = new ArrayList<String>();
  lightIntensityList2 = new ArrayList<String>();
  humidityList2 = new ArrayList<String>();
  tempList2 = new ArrayList<String>();
  soilList2 = new ArrayList<String>();

  delayPause    = millis();

  atMainMenu        = true;
  graphsBtnPressed  = false;
  historyBtnPressed = false;
  cPanelBtnPressed  = false;
  device1BtnPressed = false;
  device2BtnPressed = false;
  paused   = false;
  motorON  = false;

  flag2 = true;
  flag3 = false;
  flag4 = false;
  flag5 = true;
  flag6 = false;
  flag7 = false;
  flag8 = false;

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
  numOfTempVals  = 0;
  numOfHumidityVals2 = 0;
  numOfLightVals2 = 0;
  numOfTempVals2  = 0;
  numOfSoilVals2  = 0; 

  axisX=new float[100];

  for (int i=0; i<axisX.length; i++)
  {
    axisX[i]=i*1;
  }


  //printArray(Serial.list());
  String portName = Serial.list()[2]; // Needs to be whatever the Xbee port is
  port = new Serial(this, portName, 9600);
}  

void messageReceived(String topic, byte[] payload)
{
  //println("New message: "+topic+" - "+new String(payload));
  println(new String (payload));
}

void draw()
{
  background(255, 255, 255);
  fill(0);
  textSize(50);
  text("(IoT) Automated Irrigation System", 100, 150);
  button(400, 260, 200, 200, 65, 90, " View \ngraphs", "graph");
  button(700, 260, 200, 200, 65, 90, " View \nHistory", "history");
  button(100, 260, 200, 200, 65, 90, "Control \n Panel", "cpanel");

  if (graphsBtnPressed && !device1BtnPressed && !device2BtnPressed)
  {
    background(255);
    drawBackBtn();
    drawDeviceBtns();
  }

  if (historyBtnPressed && !device1BtnPressed && !device2BtnPressed)
  {
    background(255);
    drawBackBtn();
    drawDeviceBtns();
  }

  if (cPanelBtnPressed && !device1BtnPressed && !device2BtnPressed)
  {
    background(255);
    drawBackBtn();
    drawMotorBtn();
  }

  if (device1BtnPressed && historyBtnPressed)
  {
    background(255);    
    drawBackBtn();
    drawSensorHistory();
  } else

    if (device2BtnPressed )
    {
      background(255);    
      drawBackBtn();
      drawSensorHistory2();
    }

  if (device1BtnPressed && graphsBtnPressed)
  {
    background(255);
    drawBackBtn();
    drawPauseBtn();
    stroke(200);
    line(width/2, 50, width/2, height);
    stroke(200);
    line(0, height/2, width, height/2);
    drawHumidityGraph(humidityData);
    drawLightIntesityGraph(lightIntensityData);
    drawTempSensorGraph(tempData);
  }

  if (device2BtnPressed && graphsBtnPressed)
  {
    background(255);
    drawBackBtn();
    drawPauseBtn();
    stroke(200);
    line(width/2, 50, width/2, height);
    stroke(200);
    line(0, height/2, width, height/2);
    drawHumidityGraph(humidityData2);
    drawSoilSensorGraph(soilData2);
    drawLightIntesityGraph(lightIntensityData2);
    drawTempSensorGraph(tempData2);
  }
}

void serialEvent(Serial p) { 
  boolean isAdded = false;
  String valueRead = p.readStringUntil('\n');
  if (valueRead == null)
  {
    isAdded = true;
  } else if (valueRead.charAt(0) == 'a')
  {
    if (flag2 == true && isAdded == false)
    {
      isAdded = true;
     // lightReading1 = valueRead;
      client.publish("light", valueRead);
      lightReading1 = valueRead.substring(1);      
      lightIntensityList.add(0, lightReading1);
      //print("Flag 2 is: ");
      //println(valueRead);
      if (numOfLightVals<100)
      {
        lightIntensityData[numOfLightVals]=Float.parseFloat(lightReading1);
        numOfLightVals++;
      } else
      {
        arrayCopy(lightIntensityData, 1, lightIntensityData, 0, lightIntensityData.length-1);
        lightIntensityData[numOfLightVals-1]=Float.parseFloat(lightReading1);
      }
      flag2 = false;
      flag3 = true;
    } else if (flag3 == true && isAdded == false)
    {
      isAdded = true;
     // humidityReading1 = valueRead;
      client.publish("humidity", valueRead);
      humidityReading1 = valueRead.substring(1);
      humidityList.add(0, humidityReading1);
      //print("Flag 3 is: ");
      //println(humidityReading1);
      if (numOfHumidityVals<100)
      {
        humidityData2[numOfHumidityVals]=Float.parseFloat(humidityReading1);
        numOfHumidityVals++;
      } else
      {
        arrayCopy(humidityData, 1, humidityData, 0, humidityData.length-1);
        humidityData[numOfHumidityVals-1]=Float.parseFloat(humidityReading1);
      }
      flag3 = false;
      flag4 = true;
    } else if (flag4 == true && isAdded == false)
    {
      isAdded = true;
  //    tempReading1 = valueRead;
      client.publish("temp", valueRead);
      tempReading1 = valueRead.substring(1);      
      tempList.add(0, tempReading1);
      //print("Flag 4 is: ");
      //println(tempReading1);
      if (numOfTempVals<100)
      {
        tempData[numOfTempVals]=Float.parseFloat(tempReading1);
        numOfTempVals++;
      } else
      {
        arrayCopy(tempData, 1, tempData, 0, tempData.length-1);
        tempData[numOfTempVals-1]=Float.parseFloat(tempReading1);
      }
      flag4 = false;
      flag2 = true;
    }
  } else if (valueRead.charAt(0) == 'b')
  {
    if (flag5 == true && isAdded == false)
    {
      isAdded = true;
      moistureReading2 = valueRead.substring(1); 
      soilList2.add(0, moistureReading2);
      client.publish("moisture", valueRead);
      //print("Flag 5 is: ");
      //println(moistureReading2);
      if (numOfSoilVals2<100)
      {
        soilData2[numOfSoilVals2]=Float.parseFloat(moistureReading2);
        numOfSoilVals2++;
      } else
      {
        arrayCopy(soilData2, 1, soilData2, 0, humidityData2.length-1);
        soilData2[numOfSoilVals2-1]=Float.parseFloat(moistureReading2);
      }
      flag5 = false;
      flag6 = true;
    } else if (flag6 == true && isAdded == false)
    {
      isAdded = true;
      lightReading2 = valueRead.substring(1);
      lightIntensityList2.add(0, lightReading2);
      client.publish("light", valueRead);
      //print("Flag 6 is: ");
      //println(lightReading2);
      if (numOfLightVals2<100)
      {
        lightIntensityData2[numOfLightVals2]=Float.parseFloat(lightReading2);
        numOfLightVals2++;
      } else
      {
        arrayCopy(lightIntensityData2, 1, lightIntensityData2, 0, lightIntensityData2.length-1);
        lightIntensityData2[numOfLightVals2-1]=Float.parseFloat(lightReading2);
      }
      flag6 = false;
      flag7 = true;
    } else if (flag7 == true && isAdded == false)
    {
      isAdded = true;
      humidityReading2 = valueRead.substring(1);
      humidityList2.add(0, humidityReading2);
      client.publish("humidity", valueRead);
      //print("Flag 7 is: ");
      //println(humidityReading2);
      if (numOfSoilVals2<100)
      {
        soilData2[numOfSoilVals2]=Float.parseFloat(moistureReading2);
        numOfSoilVals2++;
      } else
      {
        arrayCopy(soilData2, 1, soilData2, 0, soilData2.length-1);
        soilData2[numOfSoilVals2-1]=Float.parseFloat(moistureReading2);
      }
      flag7 = false;
      flag8 = true;
    } else if (flag8 == true && isAdded == false)
    {
      isAdded = true;
      tempReading2 = valueRead.substring(1);
      tempList2.add(0, tempReading2);
      client.publish("temp", valueRead);
     // print("Flag 8 is: ");
      //println(tempReading2);
      if (numOfTempVals2<100)
      {
        tempData2[numOfTempVals2]=Float.parseFloat(tempReading2);
        numOfTempVals2++;
      } else
      {
        arrayCopy(tempData2, 1, tempData2, 0, soilData2.length-1);
        tempData2[numOfTempVals2-1]=Float.parseFloat(tempReading2);
      }
      // addToArray(tempData2,tempReading2,numOfTempVals2);

      flag8 = false;
      flag5 = true;
    }
  }
} 

void addToArray(float[] data, String reading, int index)
{
  if (index<100)
  {
    data[index]=Float.parseFloat(reading);
    index++;
  } else
  {
    arrayCopy(data, 1, data, 0, data.length-1);
    data[index-1]=Float.parseFloat(reading);
  }
}

void button(int rectX, int rectY, int rectW, int rectH, int txtOffsetX, int txtOffsetY, String name, String id)
{
  if (mouseX>=rectX && mouseX<=rectX+rectW && mouseY>=rectY && mouseY<=rectY+rectH)
  {
    fill(0, 102, 153, 51);
    rect(rectX, rectY, rectW, rectH, 10, 10, 10, 10);
    fill(255);
    textSize(20);
    text(name, rectX+txtOffsetX, rectY+txtOffsetY);
    if (mousePressed&&atMainMenu)
    {       
      if (id=="graph")
      {
        graphsBtnPressed=true; 
        historyBtnPressed=false;
        cPanelBtnPressed=false;
        device1BtnPressed=false;
        device2BtnPressed=false;
      }

      if (id=="history")
      {
        graphsBtnPressed=false; 
        historyBtnPressed=true;
        cPanelBtnPressed=false;
        device1BtnPressed=false;
        device2BtnPressed=false;
      }

      if (id=="cpanel")
      {
        graphsBtnPressed=false; 
        historyBtnPressed=false;
        cPanelBtnPressed=true; 
        device1BtnPressed=false;
        device2BtnPressed=false;
      }

      atMainMenu=false;
    } else if (mousePressed && graphsBtnPressed)
    {
      if (id=="deviceA") {
        graphsBtnPressed=true; 
        historyBtnPressed=false;
        cPanelBtnPressed=false; 
        device1BtnPressed=true;
        device2BtnPressed=false;
      }

      if (id=="deviceB")
      {
        graphsBtnPressed=true; 
        historyBtnPressed=false;
        cPanelBtnPressed=false; 
        device1BtnPressed=false;
        device2BtnPressed=true;
      }
    } else if (mousePressed && historyBtnPressed)
    {
      if (id=="deviceA") {
        graphsBtnPressed=false; 
        historyBtnPressed=true;
        cPanelBtnPressed=false; 
        device1BtnPressed=true;
        device2BtnPressed=false;
      }

      if (id=="deviceB")
      {
        graphsBtnPressed=false; 
        historyBtnPressed=true;
        cPanelBtnPressed=false; 
        device1BtnPressed=false;
        device2BtnPressed=true;
      }
    }
  } else
  { 
    fill(0, 102, 153);
    rect(rectX, rectY, 200, 200, 10, 10, 10, 10);
    fill(255);
    textSize(20);
    text(name, rectX+txtOffsetX, rectY+txtOffsetY);
  }
}

void drawBackBtn() {
  int rectX=905;
  int rectY=10;
  int rectW =110;
  int rectH = 30;
  if (mouseX>=rectX && mouseX<=rectX+rectW && mouseY>=rectY && mouseY<=rectY+rectH)
  {
    fill(0, 102, 153, 51);
    rect(rectX, rectY, rectW, rectH, 10, 10, 10, 10);
    fill(255);
    textSize(18);
    text("Main Menu", rectX+10, rectY+20);
    if (mousePressed)
    {
      graphsBtnPressed=false;
      historyBtnPressed=false;
      cPanelBtnPressed=false;
      device1BtnPressed=false;
      device2BtnPressed=false;

      atMainMenu=true;
    }
  } else
  {
    fill(0, 102, 153);
    rect(rectX, rectY, rectW, rectH, 10, 10, 10, 10);
    fill(255);
    textSize(18);
    text("Main Menu", rectX+10, rectY+20);
  }
}

void drawPauseBtn() {
  int rectX=800;
  int rectY=10;
  int rectW =100;
  int rectH = 30;
  if (mouseX>=rectX && mouseX<=rectX+rectW && mouseY>=rectY && mouseY<=rectY+rectH)
  {
    fill(0, 102, 153, 51);
    rect(rectX, rectY, rectW, rectH, 10, 10, 10, 10);
    fill(255);
    textSize(18);
    text("Pause", rectX+25, rectY+20);
    if (mousePressed&&millis()-delayPause>200)
    {
      if (paused)
        paused=false;
      else
        paused=true;

      delayPause=millis();
    }
  } else
  {
    fill(0, 102, 153);
    rect(rectX, rectY, rectW, rectH, 10, 10, 10, 10);
    fill(255);
    textSize(18);
    text("Pause", rectX+25, rectY+20);
  }
}

void drawDeviceBtns()
{
  device1BtnPressed=false;
  device2BtnPressed=false;
  stroke(200);
  button(200, height/2-100, 200, 200, 60, 100, "Device 1", "deviceA");
  button(600, height/2-100, 200, 200, 60, 100, "Device 2", "deviceB");
}

void drawHumidityGraph(float[] humidityData) {
  int rectX =20;
  int rectY = 50;
  fill(0);
  textSize(15);
  text("Humidity", rectX, rectY);
  fill(255);
  if (!paused)
  {
    humidityChart.setData(axisX, humidityData);
  }

  humidityChart.showYAxis(true); 
  humidityChart.setMinY(0);

  // Symbol colours
  humidityChart.setPointColour(color(180, 50, 50, 100));
  humidityChart.setPointSize(5);
  humidityChart.setLineWidth(2);
  humidityChart.draw(rectX, rectY, width/2-30, height/2-70);
}


void drawLightIntesityGraph(float[] lightIntensityData) {
  int rectX =width/2+15;
  int rectY = 50;
  fill(0);
  textSize(15);
  text("Light Intensity", rectX, rectY);
  fill(255);
  if (!paused)
  {
    lightIntensityChart.setData(axisX, lightIntensityData);
  }

  lightIntensityChart.showYAxis(true); 
  lightIntensityChart.setMinY(0);

  // Symbol colours
  lightIntensityChart.setPointColour(color(180, 50, 50, 100));
  lightIntensityChart.setPointSize(5);
  lightIntensityChart.setLineWidth(2);
  lightIntensityChart.draw(rectX, rectY, width/2-30, height/2-70);
}

void drawSoilSensorGraph(float[] soilData) {  
  int rectX =20;
  int rectY = height/2+20;

  fill(0);
  textSize(15);
  text("Soil Moisture", rectX, rectY);
  fill(255);

  if (!paused)
  {
    soilChart.setData(axisX, soilData);
  }

  soilChart.showYAxis(true); 
  soilChart.setMinY(0);

  // Symbol colours
  soilChart.setPointColour(color(180, 50, 50, 100));
  soilChart.setPointSize(5);
  soilChart.setLineWidth(2);
  soilChart.draw(rectX, rectY, width/2-30, height/2-70);
}

void drawTempSensorGraph(float[] tempData) {  
  int rectX =width/2+20;
  int rectY = height/2+20;

  fill(0);
  textSize(15);
  text("Temperature", rectX, rectY);
  fill(255);

  if (!paused)
  {
    tempChart.setData(axisX, tempData);
  }

  tempChart.showYAxis(true); 
  tempChart.setMinY(0);

  // Symbol colours
  tempChart.setPointColour(color(180, 50, 50, 100));
  tempChart.setPointSize(5);
  tempChart.setLineWidth(2);
  tempChart.draw(rectX, rectY, width/2-30, height/2-70);
}

void drawSensorHistory()
{
  rect(15, 50, width/2+100, height-60, 10);
  rect(width/2+130, 50, 370, height-60, 10);
  line(15, 85, width/2+115, 85);
  line(width/2+130, 85, 1011, 85);
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
  if (tempList.size()>40)
    tempList.remove(40);
  for (int i=0; i<tempList.size(); i++)
  {
    text(tempList.get(i), 50, 100+(i*15));
  }    

  if (lightIntensityList.size()>40)
    lightIntensityList.remove(40);
  for (int i=0; i<lightIntensityList.size(); i++)
  {
    text(lightIntensityList.get(i), 200, 100+(i*15));
  }

  if (humidityList.size()>40)
    humidityList.remove(40);
  for (int i=0; i<humidityList.size(); i++)
  {
    text(humidityList.get(i), 390, 100+(i*15));
  }

  if (soilList2.size()>40)
    soilList2.remove(40); 

  for (int i=0; i<soilList2.size(); i++)
  {
    text(soilList2.get(i), 530, 100+(i*15));
  }
}

void drawSensorHistory2()
{
  rect(15, 50, width/2+100, height-60, 10);
  rect(width/2+130, 50, 370, height-60, 10);
  line(15, 85, width/2+115, 85);
  line(width/2+130, 85, 1011, 85);
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
  if (tempList2.size()>40)
    tempList2.remove(40);
  for (int i=0; i<tempList2.size(); i++)
  {
    text(tempList2.get(i), 50, 100+(i*15));
  }    

  if (lightIntensityList2.size()>40)
    lightIntensityList2.remove(40);
  for (int i=0; i<lightIntensityList2.size(); i++)
  {
    text(lightIntensityList2.get(i), 200, 100+(i*15));
  }

  if (humidityList2.size()>40)
    humidityList2.remove(40);
  for (int i=0; i<humidityList2.size(); i++)
  {
    text(humidityList2.get(i), 390, 100+(i*15));
  }

  if (soilList2.size()>40)
    soilList2.remove(40); 

  for (int i=0; i<soilList2.size(); i++)
  {
    text(soilList2.get(i), 530, 100+(i*15));
  }
}


void drawMotorBtn()
{
  int rectX=100;
  int rectY=110;
  int rectW = 100;
  int rectH=50;
  if (!motorON)
    fill(0, 80, 0);
  else
    fill(0, 255, 0);
  rect(rectX, rectY, rectW, rectH, 10, 0, 0, 10);
  fill(255);
  textSize(20);
  text("ON", rectX+30, rectY+30);
  if (mouseX>=rectX && mouseX<=rectX+rectW && mouseY>=rectY && mouseY<=rectY+rectH)
  {    
    if (mousePressed)
    {
      motorON=true;
      fill(0, 255, 0);
      rect(rectX, rectY, rectW, rectH, 10, 0, 0, 10);
      fill(255);
      textSize(20);
      text("ON", rectX+30, rectY+30);

      //////////send to serial port here
      port.write('o');   
    }
  }

  int rectX2=rectX+rectW-1;
  int rectY2=rectY;
  int rectW2 = 100;
  int rectH2=50;
  if (!motorON)
    fill(255, 0, 0);
  else
    fill(100, 0, 0);
  rect(rectX2, rectY2, rectW2, rectH2, 0, 10, 10, 0);
  fill(255);
  textSize(20);
  text("OFF", rectX2+30, rectY+30);
  if (mouseX>=rectX2 && mouseX<=rectX2+rectW2 && mouseY>=rectY2 && mouseY<=rectY2+rectH2)
  {

    if (mousePressed)
    {
      motorON=false;
      fill(255, 0, 0);
      rect(rectX2, rectY2, rectW2, rectH2, 0, 10, 10, 0);
      fill(255);
      textSize(20);
      text("OFF", rectX2+30, rectY+30);
      port.write('s');      
    }
  }

  if (motorON)
  {
    fill(0);
    textSize(20);
    text("Motor is On", 100, 100);
  } else
  {
    fill(0);
    textSize(20);
    text("Motor is Off", 100, 100);
  }
}
