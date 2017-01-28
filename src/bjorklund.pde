/* The Euclidean Algorithm Generates Traditional Musical Rhythms
	~ Godfried Toussaint


*/

int[] bjorklund(int beats, int steps)
{

	if(beats > steps)
	{
		beats = steps;
	}

	String x = new String();
	x = "1";
	String y = new String();
	y = "0";

	int x_amount = beats;
	int y_amount = steps - beats;

	do
	{
		int x_temp = x_amount;
		int y_temp = y_amount;
		String y_copy = new String();
		y_copy = y;

		if(x_temp >= y_temp)
		{
			x_amount = y_temp;
			y_amount = x_temp - y_temp;
			y = x;
		}
		else
		{
			x_amount = x_temp;
			y_amount = y_temp - x_temp;
		}
		x = x + y_copy;
	}
	while(x_amount > 1 && y_amount > 1);

	String rythm = new String();
	for (int i = 1; i <= x_amount; i++)
	{
	rythm += x;
	}

	for (int i = 1; i <= y_amount; i++)
	{
		rythm += y;
	}

	int[] pattern = new int[steps];

	int i;
	for(i=0;i<rythm.length();i++)
	{
		pattern[i] = rythm.charAt(i) == '1' ?1 : 0;
	}
	return pattern;
}