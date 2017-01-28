import controlP5.*;

class Instrument
{
	private ControlP5 cp5;
	int[] steps;
	int step_count;
	int step;
	int hits;
	String name;
	int xpos;
	int ypos;
	int note;
	int channel;
	int channel_box;
	int velocity;


	CallbackListener NoteCallback = new CallbackListener()
	{
		public void controlEvent(CallbackEvent theEvent)
		{
			note = (int)theEvent.getController().getValue();
		}
	};

	CallbackListener ChannelCallback = new CallbackListener()
	{
		public void controlEvent(CallbackEvent theEvent)
		{
			channel = (int)theEvent.getController().getValue();
		}
	};

	CallbackListener HitCallback = new CallbackListener()
	{
		public void controlEvent(CallbackEvent theEvent)
		{
			int value = (int)theEvent.getController().getValue();
			hits = value;
			steps = bjorklund(hits, step_count);
		}

	};

	CallbackListener StepCallback = new CallbackListener()
	{
		public void controlEvent(CallbackEvent theEvent)
		{
			int value = (int)theEvent.getController().getValue();
			if(value == 0)
			{
				step_count = 1;
			}
			else
			{
				step_count = value;
			}
			steps = bjorklund(hits, step_count);
		}
	};

	CallbackListener ButtonCallback = new CallbackListener()
	{
		public void controlEvent(CallbackEvent theEvent)
		{
			if (theEvent.getAction() == ControlP5.ACTION_PRESSED)
			{
				mb.sendNoteOn(channel, note, velocity);
			}
		}
	};


	Instrument(String _name, ControlP5 _cp5, int _xpos, int _ypos, int _channel)
	{
		name = _name;
		cp5 = _cp5;
		xpos = _xpos;
		ypos = _ypos;
		note = 50;
		channel = _channel;
		velocity = 127;    
		step = 0;
		step_count = 16;
		steps = new int[step_count];
	}

	void init()
	{

	Button peek = cp5.addButton(name)
		.setPosition(xpos, ypos);

	Numberbox note_box = cp5.addNumberbox(name+"Note")
		.setCaptionLabel("Note")
		.setPosition(xpos + 80,  ypos )
		.setRange(1, 127)
		.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
		.setValue(note);

	Numberbox channel_box = cp5.addNumberbox(name+"Channel")
		.setCaptionLabel("Channel")
		.setPosition(xpos + 80 , ypos + 40)               
		.setRange(0,31)
		.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
		.setValue((float)channel);

	Knob hit = cp5.addKnob(name+"Hit")
		.setCaptionLabel(name+" Hits")
		.setRange(0,16)
		.setValue(0)
		.setPosition(xpos + 170 ,ypos + 5)
		.setRadius(25)
		.setNumberOfTickMarks(16)
		.setTickMarkLength(4)
		.snapToTickMarks(true)
		.setColorForeground(color(255))
		.setColorBackground(color(0, 160, 100))
		.setColorActive(color(255,255,0))
		.setDragDirection(Knob.HORIZONTAL);

	 Knob step = cp5.addKnob(name+"Step")
		.setCaptionLabel(name+" Steps")
		.setRange(0,16)
		.setValue(step_count)
		.setPosition(xpos + 240,ypos + 5)
		.setRadius(25)
		.setNumberOfTickMarks(16)
		.setTickMarkLength(4)
		.snapToTickMarks(true)
		.setColorForeground(color(255))
		.setColorBackground(color(0, 160, 100))
		.setColorActive(color(255,255,0))
		.setDragDirection(Knob.HORIZONTAL);

	peek.addCallback(ButtonCallback);
	note_box.addCallback(NoteCallback);
	channel_box.addCallback(ChannelCallback);
	hit.addCallback(HitCallback);
	step.addCallback(StepCallback);
	}

	void update()
	{
		if(step >= step_count)
		{
			step=0;
		}

		if(steps[step] == 1)
		{
			mb.sendNoteOn(channel, note, velocity);
		}
		step++;
	}

	void draw()
	{

		int r = 0;
		int g = 0;
		int b = 0;
		
		int i;
		for(i=0; i<step_count;i++)
		{
			if( steps[i] == 1)
			{
				r = g = b = 150; 
			}
			else
			{
				r = g = b = 50;
			}

			fill(r,g,b);
			rect(320 + i * STEPWIDTH, ypos + 15, STEPWIDTH, STEPWIDTH); 
		}

		fill(r,g+STEPWIDTH,b);
		rect(320 + (step-1) * STEPWIDTH, ypos + 15, STEPWIDTH, STEPWIDTH);
	}
	
}