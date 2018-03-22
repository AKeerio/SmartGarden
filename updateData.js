
// called when a message arrives
/**
 * [sprinklerON flag to determine whether sprinkler is already on]
 * @type {Boolean}
 */
var sprinklerON = false;
/**
 * [lightArray holds light data so far to calculate percentage]
 * @type {Array}
 */
var lightArray = [];
var lightArrayB = [];
/**
 * [percent holds percentage value of light]
 * @type {Number}
 */
var percent = 100;
var percentB = 100;
/**
 * [count holds how much light data so far]
 * @type {Number}
 */
var count = 0;
var totalCount = 0;
var countB = 0;
var totalCountB = 0;

/**
 * [onMessageArrived Dictates actions once a message is recieved from subscribed topic]
 * @param  {[type]} message [message recieved from client]
 * @return {[type]}         [description]
 */
function onMessageArrived(message) {
  //console.log("Message Arrived: " + message.payloadString);
  //console.log("Topic: " + message.destinationName);
  if (message.destinationName.match("status"))
  {
    console.log("Message Arrived: " + message.payloadString);
    if(message.payloadString.match("On"))
    {
    setSprinkle();
      [].forEach.call(document.querySelectorAll('.button'), function (el) {
        el.style.visibility = "hidden";
      });
    }
    else {
      sprinklerON = false;
      document.getElementById('sprinkerStatus').innerHTML = "Sprinkler is: OFF";
    }
  }
  if (message.destinationName.match("light"))
  {
  	if (message.payloadString.charAt(0) == 'a')
  	{
  	  var trimmed = message.payloadString.substring(1);
  	  var num = parseFloat(trimmed);
      storeLight(trimmed);
  	  if (percent < 75.0)
  	  {
         document.getElementById("light1pic").src ="dark.png"
         if(sprinklerON == false)
         {
           document.getElementById('light1Sprink').style.visibility="visible";
         }
  	     document.getElementById('lightSen1').style.background="#d83920";
  	     document.getElementById('light1').innerHTML = trimmed;
  	  }
  	  else
  	  {
         document.getElementById("light1pic").src ="sunny.png"
         document.getElementById('light1Sprink').style.visibility="hidden";
  	     document.getElementById('lightSen1').style.background="#6bcc3b";
  	     document.getElementById('light1').innerHTML = trimmed;
  	  }

  	}
  	else if (message.payloadString.charAt(0) == 'b')
  	{
      var trimmed = message.payloadString.substring(1);
      var numB = parseFloat(trimmed);
      storeLightB(numB);
      if (percentB < 75.0)
  	  {
         document.getElementById("light2pic").src ="dark.png"
         if(sprinklerON == false)
         {
           document.getElementById('light2Sprink').style.visibility="visible";
         }
  	     document.getElementById('lightSen2').style.background="#d83920";
  	     document.getElementById('light2').innerHTML = trimmed;
  	  }
  	  else
  	  {
         document.getElementById("light2pic").src ="sunny.png"
  	     document.getElementById('lightSen2').style.background="#6bcc3b";
  	     document.getElementById('light2').innerHTML = trimmed;
  	  }

    }
 }
else if (message.destinationName.match("humidity"))
{
  if (message.payloadString.charAt(0) == 'a')
  {
    var trimmed = message.payloadString.substring(1);
    var num = parseFloat(trimmed);
    if (num > 50.0)
    {
      document.getElementById("hum1pic").src ="rain.png"
      if(sprinklerON == false)
      {
        document.getElementById('hum1Sprink').style.visibility="visible";
      }
       document.getElementById('humSen1').style.background="#d83920";
       document.getElementById('hum1').innerHTML = trimmed;
    }
    else
    {
       document.getElementById("hum1pic").src ="healthy.png"
       document.getElementById('humSen1').style.background="#6bcc3b";
       document.getElementById('hum1').innerHTML = trimmed;
    }

  }
  else if (message.payloadString.charAt(0) == 'b')
  {
     var trimmed = message.payloadString.substring(1);
     var num = parseFloat(trimmed);
     if (num > 50.0)
    {
      document.getElementById("hum2pic").src ="rain.png"
      if(sprinklerON == false)
      {
        document.getElementById('hum2Sprink').style.visibility="visible";
      }
       document.getElementById('humSen2').style.background="#d83920";
       document.getElementById('hum2').innerHTML = trimmed;
    }
    else
    {
       document.getElementById("hum2pic").src ="healthy.png"
       document.getElementById('humSen2').style.background="#6bcc3b";
       document.getElementById('hum2').innerHTML = trimmed;
    }
   }
  }
else if (message.destinationName.match("temp"))
  {
    if (message.payloadString.charAt(0) == 'a')
    {
      var trimmed = message.payloadString.substring(1);
      var num = parseFloat(trimmed);
      if (num > 27.0)
      {
        document.getElementById("temp1pic").src ="hot.png"
        if(sprinklerON == false)
        {
          document.getElementById('temp1Sprink').style.visibility="visible";
        }
         document.getElementById('tempSen1').style.background="#d83920";
         document.getElementById('temp1').innerHTML = trimmed;
      }
      else if(num < 10.0)
      {
        document.getElementById("temp1pic").src ="cold.png"
        document.getElementById('tempSen1').style.background="#4286f4";
        document.getElementById('temp1').innerHTML = trimmed;

      }
      else
      {
         document.getElementById("temp1pic").src ="healthy.png"
         document.getElementById('tempSen1').style.background="#6bcc3b";
         document.getElementById('temp1').innerHTML = trimmed;
      }

    }
    else if (message.payloadString.charAt(0) == 'b')
    {
       var trimmed = message.payloadString.substring(1);
       var num = parseFloat(trimmed);
       if (num > 27.0)
      {
        document.getElementById("temp2pic").src ="hot.png"
        if(sprinklerON == false)
        {
          document.getElementById('temp2Sprink').style.visibility="visible";
        }
         document.getElementById('tempSen2').style.background="#d83920";
         document.getElementById('temp2').innerHTML = trimmed;
      }
      else if(num < 10.0)
      {
        document.getElementById("temp2pic").src ="cold.png"
        document.getElementById('tempSen1').style.background="#4286f4";
        document.getElementById('temp1').innerHTML = trimmed;

      }
      else
      {
         document.getElementById("temp2pic").src ="healthy.png"
         document.getElementById('tempSen2').style.background="#6bcc3b";
         document.getElementById('temp2').innerHTML = trimmed;
      }
     }
    }
    else if (message.destinationName.match("moisture"))
    {
      if (message.payloadString.charAt(0) == 'a')
      {
        var trimmed = message.payloadString.substring(1);
        var num = parseFloat(trimmed);
        if (num > 150.0)
        {
           document.getElementById('moistSen1').style.background="#4286f4";
           document.getElementById('moist1').innerHTML = trimmed;
        }
        else if (num < 100)
        {
          if(sprinklerON == false)
          {
            document.getElementById('moist1Sprink').style.visibility="visible";
          }
          document.getElementById('moistSen1').style.background="#d83920";
          document.getElementById('moist1').innerHTML = trimmed;
        }
        else
        {
           document.getElementById('moistSen1').style.background="#6bcc3b";
           document.getElementById('moist1').innerHTML = trimmed;
        }

      }
      else if (message.payloadString.charAt(0) == 'b')
      {
         var trimmed = message.payloadString.substring(1);
         var num = parseFloat(trimmed);
         if (num > 150.0)
        {
           document.getElementById("moist2pic").src ="rain.png"
           document.getElementById('moistSen2').style.background="#4286f4";
           document.getElementById('moist2').innerHTML = trimmed;
        }
        else if (num < 100)
        {
          document.getElementById("moist2pic").src ="dry.png"
          if(sprinklerON == false)
          {
            document.getElementById('moist2Sprink').style.visibility="visible";
          }
          document.getElementById('moistSen2').style.background="#d83920";
          document.getElementById('moist2').innerHTML = trimmed;
        }
        else
        {
           document.getElementById("moist2pic").src ="healthy.png"
           document.getElementById('moistSen2').style.background="#6bcc3b";
           document.getElementById('moist2').innerHTML = trimmed;
        }
       }
    }

}

/**
 * [setSprinkle sets the sprinkle on using MQTT]
 */
function setSprinkle () {
  message = new Paho.MQTT.Message("start");
  message.destinationName = "sprinkler";
  sprinklerON = true;
  [].forEach.call(document.querySelectorAll('.button'), function (el) {
    el.style.visibility = 'hidden';
  });
  document.getElementById('sprinkerStatus').innerHTML = "Sprinkler is: ON";
  mqtt.send(message);
  console.log("sent");
  }

/**
 * [storeLight stores light data over time application is open]
 * @param  {[type]} data [most recent light sensor data]
 * @return {[type]}      [description]
 */
function storeLight(data){
  lightArray.push(data);
  var sum = 0;
  if (lightArray.length > 100)
  {
    lightArray = [];
    storeCookie(lightArray);
  }
  for(var i = 0; i < lightArray.length; i++){
      var value = parseInt(lightArray[i], 10);
      sum+= value;
      totalCount++;
      if(value > 800)
      {
        count++;
      }
  }
  var avg = sum/lightArray.length;
  percent = ((count/totalCount))*100;
  percent = Math.round(percent * 100) / 100
  document.getElementById('percentA').innerHTML = percent;
}

function storeLightB(bData){
  lightArrayB.push(bData);
  //var sum = 0;
  if (lightArrayB.length > 100)
  {
    //storeCookie(lightArrayB);
    lightArrayB = [];
  }
  for(var j = 0; j < lightArrayB.length; j++){
      var valueB = parseInt(lightArrayB[j], 10);
      //sum+= value;
      totalCountB++;
      if(valueB > 800)
      {
        countB++;
      }
  }
  //var avg = sum/lightArrayB.length;
  percentB = ((countB/totalCountB))*100;
  percentB = Math.round(percentB * 100) / 100
  document.getElementById('percentB').innerHTML = percentB;
}

/**
 * [storeCookie store light data in a cookie to avoid database use]
 * @param  {[type]} array [light data in array]
 * @return {[type]}       [description]
 */
function storeCookie(array)
{
  var json_str = JSON.stringify(array);
  setCookie("mycookie", json_str);
  //console.log(json_str);
  var new_str = getCookie("mycookie");

}

/**
 * [setCookie creates cookie]
 * @param {[type]} cname  [description]
 * @param {[type]} cvalue [description]
 * @param {[type]} exdays [description]
 */
function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+ d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}
