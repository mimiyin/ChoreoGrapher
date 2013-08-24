// Keeps track of "tempo" as we move across the storyboard graph
import java.awt.Color;

import processing.core.*;

public class Beat {
	PApplet parent;
	float beat, tempo, rawTempo, scaledTempo, counter;
	boolean isUserCreated;

	Beat(PApplet p, float _beat, float _tempo, boolean _isUserCreated) {
		parent = p;
		beat = _beat;
		tempo = _tempo;
		rawTempo = tempo;
		isUserCreated = _isUserCreated;
	}

	public void init() {
		// A tempo of 1 frame (3 minutes at 60fps) means take all 3 minutes to
		// play out 1 scene
		// Max tempo means 10 scenes will play out in 1 second
		// Tempo values are mapped "on a curve" (natural log curve)
		// Play with expMax and expMin to play with which part of the curve
		// you'd like to map your values to
		float max = ChoreoGrapher.seconds * 10;
		float expMin = -5;
		float expMax = 2.5f;
		float exp = PApplet.map(rawTempo, parent.height, ChoreoGrapher.mouseYMin, expMin, expMax);
		float log = PApplet.exp(exp);
		tempo = PApplet.map(log, PApplet.exp(expMin), PApplet.exp(expMax), 1, max);
		// PApplet.println("Beat: " + beat + "\tRaw Tempo: " + rawTempo +
		// "\tNatural Log: " + log + "\tTempo: " + tempo +
		// "\tTempo in seconds: " + ((totalFrames/tempo)/fRate));
	}

	public void display(int col) {
		parent.noStroke();
		parent.fill(col);
		parent.ellipse(beat, rawTempo, 10, 10);
	}
}
