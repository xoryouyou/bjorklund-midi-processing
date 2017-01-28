import controlP5.*;
import themidibus.*;

int STEPWIDTH = 24;
int WIDTH = 800;
int HEIGHT = 600;
int bpm = 120;
int time = 120;

MidiBus mb;
ControlP5 cp5;
Button start_stop_button;
int myColorBackground = color(0,0,0);

Instrument[] instruments;
int  instrument_count = 8;
String[] midi_outputs;
int selected_output = 0;

int stopped = 0;

DropdownList dropdown;

public void BPM(int value){
	bpm = value;
}

public void STOP(int value){	
	if(stopped == 0 )
	{
		start_stop_button.setLabel("START");
	}
	else
	{
		start_stop_button.setLabel("STOP");
	}
	stopped ^= 1;
	println("Stopped", stopped);
}



CallbackListener MidiOutputCallback = new CallbackListener()
{
	public void controlEvent(CallbackEvent theEvent)
	{
		int output = (int)theEvent.getController().getValue();

		// implement output switching
		mb.removeOutput(midi_outputs[selected_output]);
		mb.addOutput(midi_outputs[output]);

		selected_output = output;
	}
};


void init_instruments(int count)
{
	int offset = 100;
	instruments = new Instrument[instrument_count];

	instrument_count = count;

	for(int i=0;i<instrument_count;i++)
	{
		instruments[i] = new Instrument(str(i), cp5, 20, offset + i * 80, i);
	}

	for(int i=0;i<instrument_count;i++)
	{
		instruments[i].init();
	}

}

void setup()
{

	System.out.println("----------Output (from availableOutputs())----------");
	midi_outputs = MidiBus.availableOutputs(); //Returns an array of available output devices
	for (int i = 0;i < midi_outputs.length;i++) System.out.println("["+i+"] \""+midi_outputs[i]+"\"");

	//TODO Select midi channel

	mb = new MidiBus(this, -1, midi_outputs[selected_output]);
	cp5 = new ControlP5(this);

	init_instruments(8);

	cp5.addNumberbox("BPM")
		.setLabel("BPM")
		.setPosition(10, 10)
		.setSize(60,20)
		.setRange(1,320)
		.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
		.setValue(120);

	start_stop_button = cp5.addButton("STOP")
		.setLabel("STOP")
		.setPosition(10, 50);


	dropdown = cp5.addDropdownList("dropdown")
				.setLabel("MIDI OUTPUT")
				.setPosition(120, 10);

	dropdown.addCallback(MidiOutputCallback);
	dropdown.close();

	for (int i = 0;i < midi_outputs.length;i++)
	{
		dropdown.addItem(midi_outputs[i], i);
	}

	size(800, 800, P3D);
	smooth();
	noStroke();

}

void draw()
{
	background(#000000);
	fill(0);

	if(millis() - time >= 60000 / bpm)
	{
		time = millis();
		if(stopped == 0)
		{
			for(int i=0;i<instrument_count;i++)
			{
				instruments[i].update();
			}
		}
	}

	for(int i=0;i<instrument_count;i++)
	{
		instruments[i].draw();
	}
}
