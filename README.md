LightClock is a simple clock project.

![LightClock Blurry Pic](http://raw.github.com/pierreca/LightClock/master/blurrypic.jpg)

#Hardware#
* [Arduino Uno R3](http://www.adafruit.com/products/50 "Arduino Uno R3")
* [LCD Shield](http://www.adafruit.com/products/714)
* Adafruit NeoPixels Rings ([12](http://www.adafruit.com/products/1643), [24](http://www.adafruit.com/products/1586) and [60](http://www.adafruit.com/products/1768) LEDs)
* [Chronodot](http://www.adafruit.com/products/255)
* [Parallax PIR Sensor](http://www.parallax.com/product/555-28027)
* [Adafruit Weatherproof Pushbutton (Momentary)](https://www.adafruit.com/products/481)
* [Adafruit Weatherproof Pushbutton (On/Off)](https://www.adafruit.com/products/915)

#Chassis#
Made of smoke laser-cut acrylic. It's a very bad design that constantly falls appart and is a pain to assemble.

#Features#
* Displays the time (it's a clock!)
	* Minutes and Seconds on the outer ring
	* Hours (on the inner rings)
	* Date and Time on the LCD screen
* Time can be set with the buttons of the LCD shield.
* Keeps time even when not plugged thanks to the Chronodot battery
* Clock stays on for 30 minutes then turns off. any movement detected by the PIR sensor will wake it up.
* Front button enables/disable wake up from PIR sensor (for night time for example)
* Back button acts as a regular on/off button

#In Progress#
(see other branches)
* PIR sensor to detect movement and light up/down
* Button to override PIR sensor

#Ideas for the future#
* Redesign chassis to be easier to assemble/disassemble and more sturdy.
* Alarm Clock (add a buzzer?)
* On/Off hours (dim or turn off at night)
* Add a potentiometer to control LEDs intensity
* Add some connectivity and a "Control app" to set things like colors and alarms.

#Links#
* <http://www.hackster.io/pierreca/lightclock>
* <https://hackaday.io/project/2330-LightClock>
