#include <Wire.h>
#include <RTClib.h>
#include <FiniteStateMachine.h>

#include <Adafruit_MCP23017.h>
#include <Adafruit_RGBLCDShield.h>
#include <Adafruit_NeoPixel.h>

#include "LoopHelpers.h"
#include "TimeHelpers.h"

#define PIR_PIN 3
#define PIR_CALIBRATION_SECONDS 20

#define NEO_HOUR_PIN 6
#define NEO_MINSEC_PIN 5
#define NEO_ANIM_PIN 4
#define NEO_BRIGHTNESS 64

#define OFF 0x0
#define RED 0x1
#define YELLOW 0x3
#define GREEN 0x2
#define TEAL 0x6
#define BLUE 0x4
#define VIOLET 0x5
#define WHITE 0x7

#define ROWS 2
#define COLS 16

#define DATE_STRING_LENGTH 10
#define TIME_STRING_LENGTH 8

#define TRANSITION_DELAY 300

#define AWAKE_TIME_SECONDS 3600

RTC_DS1307 rtc;

Adafruit_RGBLCDShield lcd = Adafruit_RGBLCDShield();

Adafruit_NeoPixel hourStrip = Adafruit_NeoPixel(12, NEO_HOUR_PIN, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel minSecStrip = Adafruit_NeoPixel(60, NEO_MINSEC_PIN, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel animStrip = Adafruit_NeoPixel(24, NEO_ANIM_PIN, NEO_GRB + NEO_KHZ800);

uint32_t neoRed = hourStrip.Color(255, 0, 0);
uint32_t neoGreen = hourStrip.Color(0, 255, 0);
uint32_t neoBlue = hourStrip.Color(0, 0, 255);
uint32_t neoMagenta = hourStrip.Color(255, 0, 255);
uint32_t neoBlack = hourStrip.Color(0, 0, 0);
uint32_t neoYellow = hourStrip.Color(255, 255, 0);

char dateString[DATE_STRING_LENGTH + 1];
char timeString[TIME_STRING_LENGTH + 1];

// FSM Definition
State ShowTime = State(showTimeEnter, showTimeUpdate, showTimeExit);
State SetDate = State(setDateEnter, setDateUpdate, setDateExit);
State SetTime = State(setTimeEnter, setTimeUpdate, setTimeExit);
State Sleeping = State(setSleepingEnter, setSleepingUpdate, setSleepingExit);

FSM clockStateMachine = FSM(ShowTime);

DateTime newDateTime;
short cursorPosition;
short maxCursorPosition;

DateTime now;
DateTime wakeUpTime;
bool  wakeUp = false;

void setup()
{
	Serial.begin(115200);
	Wire.begin();
	rtc.begin();
	lcd.begin(16, 2);
	lcd.setBacklight(WHITE);
	
	hourStrip.begin();
	hourStrip.setBrightness(NEO_BRIGHTNESS);
	hourStrip.show();

	minSecStrip.begin();
	minSecStrip.setBrightness(NEO_BRIGHTNESS);
	minSecStrip.show();

	animStrip.begin();
	animStrip.setBrightness(NEO_BRIGHTNESS);
	animStrip.show();

	if (!rtc.isrunning())
	{
		Serial.write("RTC not running!\n");
		rtc.adjust(DateTime(__DATE__, __TIME__));
	}

	pinMode(PIR_PIN, INPUT);

	lcd.setBacklight(BLUE);

	for (int i = PIR_CALIBRATION_SECONDS; i > 0; i--)
	{
		lcd.clear();
		lcd.setCursor(0, 0);
		lcd.print("CALIBRATING PIR");
		lcd.setCursor(0, 1);
		lcd.print(i);
		delay(1000);
	}
	
	lcd.clear();
	lcd.setBacklight(GREEN);
	lcd.setCursor(0, 0);
	lcd.print("DONE!");

	delay(1000);

	now = rtc.now();
	wakeUpTime = rtc.now();
}

void loop()
{
	uint8_t buttons = lcd.readButtons();

	if (buttons & BUTTON_SELECT) 
	{
		if (clockStateMachine.isInState(ShowTime))
		{
			clockStateMachine.transitionTo(SetDate);
		}
		else if (clockStateMachine.isInState(SetDate) && isDateValid(dateString))
		{
			clockStateMachine.transitionTo(SetTime);
		}
		else if (clockStateMachine.isInState(SetTime) && isTimeValid(timeString))
		{
			clockStateMachine.transitionTo(ShowTime);
		}

		delay(TRANSITION_DELAY);
	}

	if (clockStateMachine.isInState(Sleeping) && wakeUp)
	{
		clockStateMachine.transitionTo(ShowTime);
	}
	else if (clockStateMachine.isInState(ShowTime))
	{
		long secondsDiff = now.unixtime() - wakeUpTime.unixtime();
		if (secondsDiff >= AWAKE_TIME_SECONDS)
		{
			wakeUp = false;
			clockStateMachine.transitionTo(Sleeping);
		}
	}

	clockStateMachine.update();
}

void setNeoPixels(DateTime time)
{
	uint16_t h = time.hour() < 12 ? time.hour() : time.hour() - 12;
	uint16_t m = time.minute();
	uint16_t s = time.second();

        for (uint16_t i = 0; i < time.hour(); i++)
        {
                animStrip.setPixelColor(i, neoYellow);
        }

	for (uint16_t i = 0; i <= h; i++)
	{
		hourStrip.setPixelColor(i, neoGreen);
	}

	if (h != 0)
		hourStrip.setPixelColor(0, neoMagenta);

	if (h != 3)
		hourStrip.setPixelColor(3, neoMagenta);

	if (h != 6)
		hourStrip.setPixelColor(6, neoMagenta);

	if (h != 9)
		hourStrip.setPixelColor(9, neoMagenta);

	for (uint16_t i = 0; i <= m; i++)
	{
		if (i != s && i != 0 && i != 15 && i != 30 && i != 45)
		{
			minSecStrip.setPixelColor(i, neoBlue);
		}
	}

	for (uint16_t i = m + 1; i < 60; i++)
	{
		minSecStrip.setPixelColor(i, neoBlack);
	}

	minSecStrip.setPixelColor(0, neoMagenta);
	minSecStrip.setPixelColor(15, neoMagenta);
	minSecStrip.setPixelColor(30, neoMagenta);
	minSecStrip.setPixelColor(45, neoMagenta);

	minSecStrip.setPixelColor(time.second(), neoRed);

	showStrips();
}

void showStrips()
{
	hourStrip.show();
	minSecStrip.show();
    animStrip.show();
}


void showTimeEnter()
{
	lcd.noCursor();
	lcd.noBlink();
	lcd.setBacklight(WHITE);
}

void showTimeUpdate()
{
	now = rtc.now();

	sprintf(dateString, "%02d/%02d/%d", now.month(), now.day(), now.year());
	sprintf(timeString, "%02d:%02d:%02d", now.hour(), now.minute(), now.second());

	lcd.setCursor(0, 0);
	lcd.print(dateString);

	lcd.setCursor(0, 1);
	lcd.print(timeString);

	setNeoPixels(now);
}

void showTimeExit() 
{

}

void setDateEnter()
{
	lcd.clear();
	lcd.setBacklight(GREEN);
	lcd.setCursor(0, 0);
	lcd.print("SET DATE:");
	lcd.setCursor(0, 1);
	newDateTime = rtc.now();
	sprintf(dateString, "%02d/%02d/%04d", newDateTime.month(), newDateTime.day(), newDateTime.year());
	lcd.print(dateString);

	cursorPosition = 1;
	maxCursorPosition = DATE_STRING_LENGTH - 1;

	lcd.setCursor(1, 1);
	lcd.cursor();
}

void setDateUpdate()
{
	uint8_t buttons = lcd.readButtons();

	char dayString[3] = { dateString[3], dateString[4], '\0' };
	char monthString[3] = { dateString[0], dateString[1], '\0' };
	char yearString[5] = { dateString[6], dateString[7], dateString[8], dateString[9], '\0' };

	int day = atoi(dayString);
	int month = atoi(monthString);
	int year = atoi(yearString);

	bool dateChanged = false;
	bool cursorChanged = false;

	if ((buttons & BUTTON_RIGHT) && (cursorPosition < maxCursorPosition))
	{
		delay(TRANSITION_DELAY);
		Serial.write("right\n");
		if (cursorPosition == 1)
		{
			cursorPosition = 4;
		}
		else if (cursorPosition == 4)
		{
			cursorPosition = 9;
		}
		else
		{
			cursorPosition = 1;
		}

		cursorChanged = true;
	}
	else if ((buttons & BUTTON_LEFT) && (cursorPosition > 0))
	{
		delay(TRANSITION_DELAY);
		Serial.write("left\n");
		if (cursorPosition == 9)
		{
			cursorPosition = 4;
		}
		else if (cursorPosition == 4)
		{
			cursorPosition = 1;
		}
		else
		{
			cursorPosition = 9;
		}

		cursorChanged = true;
	}
	else if (buttons & BUTTON_UP)
	{
		delay(TRANSITION_DELAY);
		Serial.write("up\n");

		switch (cursorPosition)
		{
		case 1:
			month = incrementOrLoop(month, 12, 1);
			break;
		case 4:
			if (month == 2)
			{
				if (year % 4 == 0)
				{
					day = incrementOrLoop(day, 29, 1);
				}
				else
				{
					day = incrementOrLoop(day, 28, 1);
				}
			}
			else if (month == 1
				|| month == 3
				|| month == 5
				|| month == 7
				|| month == 8
				|| month == 10
				|| month == 12)
			{
				day = incrementOrLoop(day, 31, 1);
			}
			else
			{
				day = incrementOrLoop(day, 30, 1);
			}
			break;
		case 9:
			year = incrementOrLoop(year, 9999);
			break;
		default:
			break;
		}

		dateChanged = true;
	}
	else if (buttons & BUTTON_DOWN)
	{
		delay(TRANSITION_DELAY);
		Serial.write("down\n");

		switch (cursorPosition)
		{
		case 1:
			month = decrementOrLoop(month, 12, 1);
			break;
		case 4:
			if (month == 2)
			{
				if (year % 4 == 0)
				{
					day = decrementOrLoop(day, 29, 1);
				}
				else
				{
					day = decrementOrLoop(day, 28, 1);
				}
			}
			else if (month == 1
				|| month == 3
				|| month == 5
				|| month == 7
				|| month == 8
				|| month == 10
				|| month == 12)
			{
				day = decrementOrLoop(day, 31, 1);
			}
			else
			{
				day = decrementOrLoop(day, 30, 1);
			}
			break;
		case 9:
			year = decrementOrLoop(year, 9999);
			break;
		default:
			break;
		}

		dateChanged = true;
	}

	if (dateChanged)
	{
		sprintf(dateString, "%02d/%02d/%04d", month, day, year);

		if (!isDateValid(day, month, year))
		{
			lcd.setBacklight(RED);
		}
		else
		{
			lcd.setBacklight(GREEN);
		}

		lcd.setCursor(0, 1);
		lcd.print(dateString);

		dateChanged = false;
		cursorChanged = true;
	}

	if (cursorChanged == true)
	{
		lcd.setCursor(cursorPosition, 1);
		cursorChanged = false;
	}
}

void setDateExit()
{
	
}

void setTimeEnter()
{
	lcd.clear();
	lcd.setBacklight(GREEN);
	lcd.setCursor(0, 0);
	lcd.print("SET TIME:");
	lcd.setCursor(0, 1);

	newDateTime = rtc.now();
	sprintf(timeString, "%02d:%02d:%02d", newDateTime.hour(), newDateTime.minute(), newDateTime.second());
	lcd.print(timeString);

	cursorPosition = 1;
	maxCursorPosition = TIME_STRING_LENGTH - 1;

	lcd.setCursor(1, 1);
	lcd.cursor();
}

void setTimeUpdate()
{
	char hourString[3] = { timeString[0], timeString[1], '\0' };
	char minuteString[3] = { timeString[3], timeString[4], '\0' };
	char secondString[5] = { timeString[6], timeString[7], '\0' };

	int hour = atoi(hourString);
	int minute = atoi(minuteString);
	int second = atoi(secondString);

	bool timeChanged = false;
	bool cursorChanged = false;

	uint8_t buttons = lcd.readButtons();

	if ((buttons & BUTTON_RIGHT) && (cursorPosition < maxCursorPosition))
	{
		delay(TRANSITION_DELAY);
		Serial.write("right\n");
		if (cursorPosition == 1)
		{
			cursorPosition = 4;
		}
		else if (cursorPosition == 4)
		{
			cursorPosition = 7;
		}
		else
		{
			cursorPosition = 1;
		}

		cursorChanged = true;
	}
	else if ((buttons & BUTTON_LEFT) && (cursorPosition > 0))
	{
		delay(TRANSITION_DELAY);
		Serial.write("left\n");
		if (cursorPosition == 7)
		{
			cursorPosition = 4;
		}
		else if (cursorPosition == 4)
		{
			cursorPosition = 1;
		}
		else
		{
			cursorPosition = 7;
		}

		cursorChanged = true;
	}
	else if (buttons & BUTTON_UP)
	{
		delay(TRANSITION_DELAY);
		Serial.write("up\n");

		switch (cursorPosition)
		{
		case 1:
			hour = incrementOrLoop(hour, 23);
			break;
		case 4:
			minute = incrementOrLoop(minute, 60);
			break;
		case 9:
			second = incrementOrLoop(second, 60);
			break;
		default:
			break;
		}

		timeChanged = true;
	}
	else if (buttons & BUTTON_DOWN)
	{
		delay(TRANSITION_DELAY);
		Serial.write("down\n");

		switch (cursorPosition)
		{
		case 1:
			hour = decrementOrLoop(hour, 23);
			break;
		case 4:
			minute = decrementOrLoop(minute, 60);
			break;
		case 9:
			second = decrementOrLoop(second, 60);
			break;
		default:
			break;
		}

		timeChanged = true;
	}


	if (timeChanged)
	{
		sprintf(timeString, "%02d:%02d:%02d", hour, minute, second);

		if (!isTimeValid(hour, minute, second))
		{
			lcd.setBacklight(RED);
		}
		else
		{
			lcd.setBacklight(GREEN);
		}

		lcd.setCursor(0, 1);
		lcd.print(timeString);

		timeChanged = false;
		cursorChanged = true;
	}

	if (cursorChanged == true)
	{
		lcd.setCursor(cursorPosition, 1);
		cursorChanged = false;
	}
}

void setTimeExit()
{

	char dayString[3] = { dateString[3], dateString[4], '\0' };
	char monthString[3] = { dateString[0], dateString[1], '\0' };
	char yearString[5] = { dateString[6], dateString[7], dateString[8], dateString[9], '\0' };

	char hourString[3] = { timeString[0], timeString[1], '\0' };
	char minuteString[3] = { timeString[3], timeString[4], '\0' };
	char secondString[5] = { timeString[6], timeString[7], '\0' };

	int day = atoi(dayString);
	int month = atoi(monthString);
	int year = atoi(yearString);

	int hour = atoi(hourString);
	int minute = atoi(minuteString);
	int second = atoi(secondString);

	rtc.adjust(DateTime(year, month, day, hour, minute, second));
}

void setSleepingEnter()
{
	lcd.clear();
	lcd.setBacklight(RED);
	lcd.setCursor(0, 0);
	lcd.print("GOING TO SLEEP");
	delay(1000);
	turnOffStrips();
	lcd.setBacklight(OFF);
	lcd.clear();
}

void setSleepingExit()
{
	lcd.clear();
	lcd.setBacklight(RED);
	lcd.setCursor(0, 0);
	lcd.print("WAKING UP...");
	delay(1000);
	turnOnStrips();
}

void setSleepingUpdate()
{
	if (digitalRead(PIR_PIN) == HIGH)
	{
		wakeUpTime = rtc.now();
		wakeUp = true;
	}
}

void turnOffStrips()
{
	animStrip.setBrightness(0);
	hourStrip.setBrightness(0);
	minSecStrip.setBrightness(0);

	showStrips();
}

void turnOnStrips()
{
	animStrip.setBrightness(NEO_BRIGHTNESS);
	hourStrip.setBrightness(NEO_BRIGHTNESS);
	minSecStrip.setBrightness(NEO_BRIGHTNESS);

	showStrips();
}