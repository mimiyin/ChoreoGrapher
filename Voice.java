import processing.core.*;
import processing.video.*;

import java.util.*;
import java.io.*;

public class Voice {
	PApplet parent;
	String name;
	boolean isSelected;
	Beat[] beats;
	float weight, threshold;
	int firstBeatInd, lastBeatInd, numBeats;
	ArrayList<Movie> clips;
	Movie selected;

	Button button;

	Voice(PApplet p, String _name, int index) {
		parent = p;
		name = _name;
		toggle(true);
		button = new Button(parent, name, Controls.SIDEBAR, index);
		reset();
	}

	void toggle(boolean isOn) {
		isSelected = isOn;
		if (isOn)
			ChoreoGrapher.selectVoiceEvent(this);
	}

	void reset() {
		parent.background(255);
		weight = 1;
		threshold = 0;

		// Initialize beats array with
		// a dot for every x-position
		beats = new Beat[parent.width];
		for (int i = 0; i < beats.length; i++) {
			beats[i] = createBeat(i, ChoreoGrapher.mouseYMin, false);
		}
	}

	void loadBeats(Beat[] _beats) {
		beats = _beats;
	}

	Beat createBeat(float x, float y, boolean isUserCreated) {
		x = PApplet.constrain(x, 0, parent.width);
		y = PApplet.constrain(y, ChoreoGrapher.mouseYMin, parent.height);
		return new Beat(parent, x, y, isUserCreated);
	}

	void record() {
		if (parent.mouseX >= 0 && parent.mouseX < parent.width
				&& parent.mouseY >= ChoreoGrapher.mouseYMin && parent.mouseY < parent.height) {
			beats[parent.mouseX] = createBeat(parent.mouseX, parent.mouseY,
					true);
			ChoreoGrapher.isPlayable = true;
		}
	}

	void display() {
		parent.background(255);
		for (Beat beat : beats) {
			int col = isSelected ? parent.color(255, 0, 0) : parent.color(0);
			beat.display(col);
		}
	}

	void erase() {
		boolean isGoingRight = parent.mouseX > parent.pmouseX;
		if (isGoingRight) {
			for (int i = parent.pmouseX + 1; i < parent.mouseX; i++) {
				beats[i] = createBeat(i, ChoreoGrapher.mouseYMin, false);
			}
		} else {
			for (int i = parent.pmouseX - 1; i > parent.mouseX; i--) {
				beats[i] = createBeat(i, ChoreoGrapher.mouseYMin, false);
			}
		}
	}

	void run() {
		weight = beats[(int)Math.round(Storyboard.t)].tempo;
	}

	void pickClip() {
		int m = (int) Math.round(clips.size());
		selected = clips.get(m);
		selected.play();
	}

	void play() {
		parent.image(selected, 0, 0);
	}

	boolean isDone() {
		if (selected.time() > selected.duration())
			return true;
		else
			return false;
	}

	void selectClipsSource() {
		parent.selectFolder("Select source folder for clips.", "loadClips");
	}

	void loadClips(File folder) {
		// Update button label with folder name
		button.update(folder.getName());

		// Try to load images
		for (int i = 0; i < folder.listFiles().length; i++) {
			String path = folder + "/" + PApplet.nf(i, 4) + ".mov";
			Movie movie;
			try {
				movie = new Movie(parent, path);
				clips.add(movie);
			} catch (Exception e) {
				PApplet.println("No movie at: " + path);
			}
		}
	}

	// Interpolate beats so that
	// every x-position has a beat value
	void interpolate() {

		// Calculate the first/last beat
		for (int i = 0; i < beats.length; i++) {
			if (beats[i].isUserCreated) {
				firstBeatInd = i;
				break;
			}
		}

		for (int i = beats.length - 1; i > 0; i--) {
			if (beats[i].isUserCreated) {
				lastBeatInd = i;
				break;
			}
		}

		int prevBeatInd = firstBeatInd;
		int nextBeatInd = findNextBeat(firstBeatInd + 1);
		int indRange = nextBeatInd - prevBeatInd;
		PVector prevBeat = new PVector(beats[0].beat, beats[0].rawTempo);
		PVector nextBeat = new PVector(beats[nextBeatInd].beat,
				beats[nextBeatInd].rawTempo);
		PVector range = PVector.sub(nextBeat, prevBeat);
		float progress = 0;
		for (int i = 0; i < (lastBeatInd + 1); i++) {
			Beat thisBeat = beats[i];
			float beat = thisBeat.beat;
			float tempo = thisBeat.rawTempo;
			if (thisBeat.isUserCreated) {
				prevBeatInd = i;
				nextBeatInd = findNextBeat(i + 1);
				indRange = nextBeatInd - prevBeatInd;
				prevBeat.set(beat, tempo);
				nextBeat.set(beats[nextBeatInd].beat,
						beats[nextBeatInd].rawTempo);
				range = PVector.sub(nextBeat, prevBeat);
			} else {
				progress = ((float) (i - prevBeatInd)) / indRange;
				beat = prevBeat.x + Math.round(progress * range.x);
				tempo = prevBeat.y + Math.round(progress * range.y);
				thisBeat = createBeat(beat, tempo, false);
			}
			thisBeat.init();
			beats[i] = thisBeat;
		}

		// Scale tSpeed so that it takes the full
		// duration of the piece to play all the beats
		numBeats = (lastBeatInd - firstBeatInd) + 1;
	}

	int findNextBeat(int _i) {
		for (int i = _i; i < lastBeatInd + 1; i++) {
			if (beats[i].isUserCreated)
				return i;
		}
		// If there are no more beats
		// Send the last beat
		return lastBeatInd;
	}
	
	public void loadBeats(String[] savedBeats) {
		beats = new Beat[savedBeats.length];
	    for (int i = 0; i < savedBeats.length; i++) {
	      String[] savedBeat = savedBeats[i].split(", ");
	      beats[i] = new Beat(parent, Float.parseFloat(savedBeat[0]), Float.parseFloat(savedBeat[1]), Boolean.parseBoolean(savedBeat[2]));
	    }
	}
	
	public void dumpBeats(String path, int index) {
		String[] savedBeats = new String[beats.length];
	    String concatenator = ", ";
	    for (int i = 0; i < beats.length; i++) {
	      Beat beat = beats[i];
	      String savedBeat = "" + beat.beat;
	      savedBeat += concatenator + beat.rawTempo;
	      savedBeat += concatenator + beat.isUserCreated;
	      savedBeats[i] = savedBeat;
	    }
	    parent.saveStrings(path + "/" + PApplet.nf(index, 2) + ".txt", savedBeats);
	}
}
