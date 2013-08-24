import processing.core.*;
import processing.video.*;
import ddf.minim.*;

import java.util.*;
import java.io.*;

public class ChoreoGrapher extends PApplet {
	
	////////////////////////////
	////////////////////////////
	//////SETTINGS FOR YOU//////
	////////////////////////////
	////////////////////////////
	public static float seconds = 90;
	public static int fRate = 30;
	public static int totalFrames = (int) seconds * fRate;
	public static int maxNumberOfMedia = 1;

	// Gatekeepers for drawing and playing modes
	public static boolean isDrawable = true;
	public static boolean isDrawing = false;
	public static boolean isPlayable = false;
	public static boolean isTiming = false;

	// Voices
	public static ArrayList<Voice> voices;
	public static Voice selected;

	// Managing moving through your content
	public static Storyboard sb;

	// Your content
	public static ArrayList<Movie> movies;

	// Keeping track oftime
	// elapsed since clicking
	// Play button
	public static float timer;
	
	// Highest point you can draw
	public static int mouseYMin = 0;
	
	public static ToggleButton play;
	public static Button clear, save, load;
	public static Button loadAudio, loadClips;
	public static Button addVoice, removeVoice;
	
	public static Minim minim;
	public static AudioPlayer audio;

	

	public void setup() {
	  size(640, 480); 
	  loadAudio = new Button(this, "Audio", Controls.TOPRIGHT, 1);
	  save = new Button(this, "Save", Controls.TOPRIGHT, 3);
	  load = new Button(this, "Load", Controls.TOPRIGHT, 4);
	  play = new ToggleButton(this, "Play", Controls.TOPRIGHT, 6, "Stop");
	  clear = new Button(this, "Clear", Controls.TOPRIGHT, 7);
	  removeVoice = new Button(this, "Remove", Controls.BOTTOMLEFT, 1);
	  addVoice = new Button(this, "Add", Controls.BOTTOMLEFT, 2);
	  loadClips = new Button(this, "Clips", Controls.BOTTOMLEFT, 3);

	  imageMode(CENTER);
	  frameRate(fRate);

	  minim = new Minim(this);
	  sb = new Storyboard(this);

	  // Always start with at least one voice
	  voices.add(new Voice(this, "default", 0));
	}

	public void draw() {

	  // Drawing the storyboard graph
	  if (isDrawable) {
	    if (isDrawing) {
	      selected.record();
	    }
	    for (Voice v : voices) {
	      v.display();
	    }
	  }
	  else if (isTiming) {
	    //Calculate time elapsed
	    //Since beginning of storyboard
	    String clock = "";
	    int time = 0;
	    time = parseInt(timer/1000) + 1;
	    clock = time + "s";
	    textAlign(CENTER);
	    textSize(48);
	    float textWidth = textWidth(clock+5);

	    if (play.isOn) {
	      if (sb.isDone())
	        sb.pickVoice();
	      sb.play();
	      timer = timer + (millis() - timer);
	    }
	    // When stopped, show end-time
	    else {
	      fill(0);
	      rectMode(CENTER);
	      rect(50, 30, textWidth, 70);
	    }

	    // Display clock
	    stroke(255);
	    fill(255);
	    text(clock, textWidth/2, 50);
	  }
	  showButtons();
	}

	void reset() {
	  selected.reset();

	  // Allow drawing
	  // Don't allow playing
	  // Reset beats array to
	  // "hasn't been interpolated yet"
	  isDrawable = true;
	  isPlayable = false;
	  isTiming = false;
	}

	//////////////////////////////////////////
	//////////////////////////////////////////
	/////////////// INTERACTION //////////////
	//////////////////////////////////////////
	//////////////////////////////////////////
	public void mousePressed() {
	  isDrawing = true;

	  // Clear graph
	  // Re-initialize beats array
	  if (clear.isHovered() && !play.isOn) {
	    reset();
	    }

	    // Play or Stop storyboard
	  else if (play.isHovered() && isPlayable) {
	    if (!play.isOn) {
	      initPlayer();
	      isPlayable = true;
	      isDrawable = false;
	      timer = millis();
	      isTiming = true;
	    }
	    else {
	      resetPlayer();
	    }    
	    play.toggle();
	  }
	  else if (save.isHovered())
	    save();

	  else if (load.isHovered())
	    load();

	  else if (loadAudio.isHovered())
	    selectAudioFile();

	  else if (addVoice.isHovered())
	    addVoice();

	  else if (removeVoice.isHovered())
	    removeVoice();

	  else if (loadClips.isHovered())
	    selected.selectClipsSource();

	  else {
	    for (Voice v : voices) {
	      if (v.button.isHovered())
	        changeVoice(v);
	    }
	  }
	}

	public void mouseReleased() {
	  isDrawing = false;
	  if (isDrawable) {
	    selected.interpolate();
	  }

	  if (!play.isOn)
	    isDrawable = true;
	}

	public void mouseDragged() {
	  // ERASE
	  if (isDrawable) {
	    selected.erase();
	  }
	}

	void MovieEvent(Movie m) {
	  m.read();
	}

	public static void selectVoiceEvent(Voice v) {
	  selected = v;
	}

	void showButtons() {
	  loadAudio.display();
	  load.display();
	  save.display();
	  play.display();
	  clear.display();
	  addVoice.display();
	  removeVoice.display();
	  loadClips.display();
	}
	
	void initPlayer() {
		  sb.reset();
		  try {
		    audio.cue(0);
		    audio.play();
		  }
		  catch(Exception e) {
		    println("No audio to play.");
		  }
		}
		void resetPlayer() {
		  initPlayer();
		  try {
		    audio.pause();
		  }
		  catch(Exception e) {
		    println("No audio to pause.");
		  }
		}

		void load() {
		  // Pause drawing while we load the file
		  reset();
		  selectFolder("Load Graph", "load");
		}

		void load(File folder) {
		  // Clear voices
		  voices = new ArrayList<Voice>();

		  String path = folder.getAbsolutePath();
		  int numVoices = folder.listFiles().length;
		  String[] clips = loadStrings(path + "/clips.txt");

		  for (int i = 0; i < numVoices; i++) {
		    Voice v = new Voice(this, Integer.toString(i), i);
		    voices.add(v);
		    String[] savedBeats = loadStrings(path + "/" + nf(i, 2) + ".txt");
		    v.loadBeats(savedBeats);
		    v.loadClips(new File(clips[i]));
		  }

		  // Get ready to play
		  isPlayable = true;
		}

		void save() {
		  selectFolder("Save This Graph", "dump");
		}

		void dump(File folder) {
		  String path = folder.getAbsolutePath();

		  for (int v= 0; v < voices.size(); v++) {
			  Voice thisVoice = voices.get(v);
			  thisVoice.dumpBeats(path, v);
		  }
		}

		void selectAudioFile() {
		  selectOutput("Select Audio File", "loadAudio");
		}

		void loadAudio(File file) {
		  try {
		    audio = minim.loadFile(file.getAbsolutePath());
		    seconds = Math.round(audio.length()/1000);
		    println("The audio is " + seconds + "s long.");
		  }
		  catch(Exception e) {
		    println("No audio");
		  }
		}

		void addVoice() {
		  turnOffVoices();
		  int index = voices.size();
		  String name = "Voice " + index;
		  voices.add(new Voice(this, name, index));
		}

		void removeVoice() {
		  // Must have at least 1 voice
		  if (voices.size() > 1)
		    return;

		  int index = voices.indexOf(selected);
		  voices.remove(index);
		  try {
		    changeVoice(voices.get(index));
		  }
		  finally {
		    changeVoice(voices.get(index-1));
		  }
		}

		void changeVoice(Voice v) {
		  turnOffVoices();
		  v.toggle(true) ;
		}

		void turnOffVoices() {
		  for (Voice voice : voices) {
		    voice.toggle(false);
		  }
		}

}
