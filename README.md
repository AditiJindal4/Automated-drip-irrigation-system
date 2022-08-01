Components used in this project:

·       Arduino UNO

·       Soil Moisture Sensor (I have used LM393, you can also use SparkFun SEN-13322)

·       5V Relay Module

·       Water Motor (I have demonstrated it using a light bulb in the prototype) 

The LM393 Moisture Sensor reads the moisture content present in the soil. Incase the moisture level is below a certain threshold, the Arduino UNO powers the relay that completes the circuit for water pump to function and water the plant. The sensor keep tracking the water content in the soil and sending the data back to the board. Once the moisture content is enough for the plant, the board instructs to stop the relay, consequently stopping the water pump. Github Link

In the future I wish to research on this project so it can help farmers across the globe. I hope to work on a self-made moisture sensor which utilises minimal plastic, reducing the risk for contamination of soil. I also wish to broaden the reach of the project by studying different kinds of plants and soil types and adding adjustable settings.
