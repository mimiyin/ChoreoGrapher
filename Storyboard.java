import processing.core.*;

// Composes the sequence

public class Storyboard {
	PApplet parent;
	Voice selected;
	
	// Rate at which we move across the screen
	public static float t;
	public static float tSpeed = 0;

	Storyboard(PApplet p) {
		parent = p;
	}

	void reset() {
		t = 0;
		for (Voice v : ChoreoGrapher.voices) {
			v.reset();
		}
	}

	void pickVoice() {
		int sum = 0;
		t+=tSpeed;
		for (Voice v : ChoreoGrapher.voices) {
			v.run();
			sum += v.weight;
			v.threshold = sum;
		}
		float dart = (float) Math.random()*sum;
		for (int v = 0; v < ChoreoGrapher.voices.size(); v++) {
			Voice thisVoice = ChoreoGrapher.voices.get(v);
			if (dart < thisVoice.threshold) {
				selected = thisVoice;
				selected.pickClip();
				break;
			}
		}
	}

	void record() {
		selected.record();
	}

	void play() {
		selected.play();
	}

	boolean isDone() {
		if (selected.isDone())
			return true;
		else
			return false;
	}
}
