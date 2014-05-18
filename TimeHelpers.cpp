#include <stdlib.h>
#include "TimeHelpers.h"

bool isDateValid(const char *dateString)
{
	char dayString[3] = { dateString[3], dateString[4], '\0' };
	char monthString[3] = { dateString[0], dateString[1], '\0' };
	char yearString[5] = { dateString[6], dateString[7], dateString[8], dateString[9], '\0' };

	int day = atoi(dayString);
	int month = atoi(monthString);
	int year = atoi(yearString);

	return isDateValid(day, month, year);
}

bool isDateValid(int day, int month, int year)
{
	bool result = false;

	if (month == 2)
	{
		if ((year % 4 == 0 && day <= 29 && day > 0)
			|| (year % 4 != 0 && day <= 28 && day > 0))
		{
			result = true;
		}
	}
	if (month == 1
		|| month == 3
		|| month == 5
		|| month == 7
		|| month == 8
		|| month == 10
		|| month == 12)
	{
		if (day <= 31 && day > 0)
		{
			result = true;
		}
	}
	else if (month == 4
		|| month == 6
		|| month == 9
		|| month == 11)
	{
		if (day <= 30 && day > 0)
		{
			result = true;
		}
	}

	return result;
}

bool isTimeValid(int hour, int minute, int second)
{
	bool result = false;

	if (hour < 24 || hour >= 0)
	{
		result = true;
	}

	if (minute < 60 || minute >= 0)
	{
		result = true;
	}

	if (second < 60 || minute >= 0)
	{
		result = true;
	}

	return result;
}

bool isTimeValid(const char *timeString)
{
	char hourString[3] = { timeString[0], timeString[1], '\0' };
	char minuteString[3] = { timeString[3], timeString[4], '\0' };
	char secondString[5] = { timeString[6], timeString[7], '\0' };

	int hour = atoi(hourString);
	int minute = atoi(minuteString);
	int second = atoi(secondString);

	return isTimeValid(hour, minute, second);
}

