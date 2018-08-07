# AirTrafficControl
Processing project. Visualizing looping notes from Track 2 of Brian Eno's Music for Airports
** This program will not produce sound on it's own. Outgoing MIDI events need to be processed by a synthesizer. **


This project uses two libraries to respectively support it's two main features:

1) TheMidiBus http://www.smallbutdigital.com/projects/themidibus/
allows the application to send MIDI events to an external DAW (such as Garageband, Logic) by using a virtual bus. There is a Java MIDI library, but TheMidiBus was much easier and simpler to use because I was only concerned with sending simple note events. Apple's OSX has a built in virtual MIDI network wizard for inter application MIDI interfaces. Linux machines can use ALSA or JACK (although I have not been able to successfully send MIDI to another application on a Linux machine)

2) G4P http://www.lagers.org.uk/g4p/
aka Graphics for Processing provides most of the GUI features.

To do:
- Fix the repeating note period measurument. It's either way off, or the program is lagging
- Ditch multiple windows
- Make a GUI dialogue to select an available midi port from the OS

Take aways:
- Multiple windows is too much of a performance cost, at least when implemented a Java application
- For applications where latency and constant time is a primary concern, Processing / Java is NOT the way to go. It is not close enough to the hardware. Such applications should be written natively. I may give this another go in C++

