//Global variables. Change here for new broker details

		/**
		 * [reconnectTimeout time before it times out trying to connect]
		 * @type {Number}
		 */
		var mqtt;
		var reconnectTimeout = 2000;
		/**
		 * [host ip address of the broker]
		 * @type {String}
		 */
		var host="10.65.192.114"; //change this
		/**
		 * [port port to access broker IP (websocket)]
		 * @type {Number}
		 */
		var port=9008;
/**
 * [onConnect Once connected to the Mosquitto Broker, automatically subscribe
 * required networks]
 * @param mqtt [the Paho client variable]
 * @return {[type]} [description]
 */
	 	function onConnect() {
	  // Once a connection has been made, make a subscription and send a message.
		console.log("Connected ");
		mqtt.subscribe("light");
		console.log("subbed ");
		mqtt.subscribe("moisture");
		mqtt.subscribe("humidity");
		mqtt.subscribe("temp");
		mqtt.subscribe("app");
		mqtt.subscribe("status");
		/**
		 * [message a published message to tell Admin Dashboard that there is a connection]
		 * @type {Paho}
		 */
		message = new Paho.MQTT.Message("Connected");
		message.destinationName = "app";
		mqtt.send(message);
		console.log("sent ");
	  }

		/**
		 * [MQTTconnect connects to the broker]
		 * @constructor
		 */
	  function MQTTconnect() {
		console.log("connecting to "+ host +" "+ port);
		mqtt = new Paho.MQTT.Client(host,port,"clientjs");
		//document.write("connecting to "+ host);
		var options = {
			timeout: 3,
			onSuccess: onConnect,

		 };
		//retrieves any messages from topics subscribed to
		mqtt.onMessageArrived = onMessageArrived;
		mqtt.connect(options); //connect

		}
