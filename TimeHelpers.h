#pragma once

bool isDateValid(const char *dateString);
bool isDateValid(int day, int month, int year);
bool isTimeValid(int hour, int minute, int second);
bool isTimeValid(const char *timeString);
