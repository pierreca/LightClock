#include "LoopHelpers.h"


char incrementOrLoop(char current, char max, char min)
{
	if (current < max)
	{
		return ++current;
	}
	else
	{
		return min;
	}
}

char decrementOrLoop(char current, char max, char min)
{
	if (current > min)
	{
		return --current;
	}
	else
	{
		return max;
	}
}

int incrementOrLoop(int current, int max, int min)
{
	if (current < max)
	{
		return ++current;
	}
	else
	{
		return min;
	}
}

int decrementOrLoop(int current, int max, int min)
{
	if (current > min)
	{
		return --current;
	}
	else
	{
		return max;
	}
}