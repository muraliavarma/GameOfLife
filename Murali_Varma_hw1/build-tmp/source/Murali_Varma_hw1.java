import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Murali_Varma_hw1 extends PApplet {


//constants

int NUM_HORIZONTAL_CELLS = 100;
int NUM_VERTICAL_CELLS = 50;
int CELL_HEIGHT = 8;
int CELL_WIDTH = 8;

int EDIT_MODE = 0;
int SINGLE_STEP_MODE = 1;
int CONTINUOUS_MODE = 2;

//variables

boolean [][] cellState;
int mode;

public void setup() {
	size(NUM_HORIZONTAL_CELLS * CELL_WIDTH, NUM_VERTICAL_CELLS * CELL_HEIGHT);
	background(0);
	stroke(100);

	//initialize variables
	cellState = new boolean[NUM_VERTICAL_CELLS][NUM_HORIZONTAL_CELLS];	//by default all cells are inititialized to 0
	mode = EDIT_MODE;
}

public void draw() {
	drawCells();
}

public void drawCells() {
	for (int i = 0; i < NUM_VERTICAL_CELLS; i++) {
		for (int j = 0; j < NUM_HORIZONTAL_CELLS; j++) {
			if (cellState[i][j]) {
				fill(255);
			}
			else {
				fill(0);
			}
			rect (CELL_WIDTH * j, CELL_HEIGHT * i, CELL_WIDTH, CELL_HEIGHT);
		}
	}
}

public void mousePressed() {
	if (mode != EDIT_MODE) {
		//mouse clicks have effect only in edit mode
		return;
	}
	int xCell = mouseX/CELL_WIDTH;
	int yCell = mouseY/CELL_HEIGHT;
	cellState[yCell][xCell] = !cellState[yCell][xCell];
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Murali_Varma_hw1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
