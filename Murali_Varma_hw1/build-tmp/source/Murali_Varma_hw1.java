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
int NUM_VERTICAL_CELLS = 100;
int CELL_HEIGHT = 8;
int CELL_WIDTH = 8;
int CONTROLS_WIDTH = 200;

int SINGLE_STEP_MODE = 0;
int CONTINUOUS_MODE = 1;

//variables

boolean [][] cellState;
int [][] neighborCount;
int mode;
int neighbors;
Button[] buttons;

//called once in the beginning
public void setup() {
	size(NUM_HORIZONTAL_CELLS * CELL_WIDTH + CONTROLS_WIDTH, NUM_VERTICAL_CELLS * CELL_HEIGHT);
	background(0);
	stroke(100);

	//initialize variables
	cellState = new boolean[NUM_VERTICAL_CELLS][NUM_HORIZONTAL_CELLS];	//by default all cells are inititialized to false
	neighborCount = new int[NUM_VERTICAL_CELLS][NUM_HORIZONTAL_CELLS];	//by default all cells are inititialized to zero
	mode = SINGLE_STEP_MODE;
	drawGlider(20, 20);
	drawCells();

	//GUI Stuff
	buttons = new Button[6];
	buttons[0] = new Button(20, 60, 120, 20, "Clear", "C");
	buttons[1] = new Button(20, 100, 120, 20, "Randomize", "R");
	buttons[2] = new Button(20, 140, 120, 20, "Toggle Mode", "G");
	buttons[3] = new Button(20, 180, 120, 20, "Step Once", "Space");
	buttons[4] = new Button(20, 300, 60, 20, "Gliders");
	buttons[5] = new Button(20, 340, 120, 20, "Glider Gun");
	drawControls();
}

//called every draw cycle
public void draw() {
	if (mode == CONTINUOUS_MODE) {
		advance();
		drawCells();
	}
}

//redraws all the cells based on cell data structure
public void drawCells() {
	for (int i = 0; i < NUM_VERTICAL_CELLS; i++) {
		for (int j = 0; j < NUM_HORIZONTAL_CELLS; j++) {
			drawCell(i, j);
		}
	}
}

//draw a single cell
public void drawCell(int i, int j) {
	if (cellState[i][j]) {
		fill(255);
	}
	else {
		fill(0);
	}
	rect (CELL_WIDTH * j, CELL_HEIGHT * i, CELL_WIDTH, CELL_HEIGHT);

}

//called when the mouse is clicked
public void mousePressed() {
	int xCell = mouseX/CELL_WIDTH;
	int yCell = mouseY/CELL_HEIGHT;

	if (xCell >= NUM_HORIZONTAL_CELLS) {
		//find which control the click happened on
		for (int i = 0; i < buttons.length; i++) {
			buttons[i].click();
		}
		return;
	}

	if (mode != SINGLE_STEP_MODE) {
		//mouse clicks have effect only in single step mode
		return;
	}
	cellState[yCell][xCell] = !cellState[yCell][xCell];
	drawCell(yCell, xCell);
}

//called when the mouse is hovered
public void mouseMoved() {
	if (mouseX/CELL_WIDTH >= NUM_HORIZONTAL_CELLS) {
		//find which control the mouse is hovered on
		for (int i = 0; i < buttons.length; i++) {
			buttons[i].hover();
		}
	}
}

//called when some key is pressed
public void keyPressed() {
	//clear grid
	if (key == 'C' || key == 'c') {
		clearGrid();
	}

	//randomize grid
	if (key == 'R' || key == 'r') {
		randomizeGrid();
	}

	//change mode
	if (key == 'g' || key == 'G') {
		changeMode();
	}

	//advance step
	if (key == ' ') {
		advanceStep();
	}
}

public void clearGrid() {
	for (int i = 0; i < NUM_VERTICAL_CELLS; i++) {
		for (int j = 0; j < NUM_HORIZONTAL_CELLS; j++) {
			cellState[i][j] = false;
		}
	}
	drawCells();
}

public void randomizeGrid() {
	for (int i = 0; i < NUM_VERTICAL_CELLS; i++) {
		for (int j = 0; j < NUM_HORIZONTAL_CELLS; j++) {
			//random(2) gives a float between 0 and 2
			cellState[i][j] = (random(2) >= 1);
		}
	}
	drawCells();
}

public void changeMode() {
	if (mode == SINGLE_STEP_MODE) {
		mode = CONTINUOUS_MODE;
	}
	else {
		mode = SINGLE_STEP_MODE;
	}
	drawControls();
}

public void advanceStep() {
	mode = SINGLE_STEP_MODE;
	advance();
	drawControls();
	drawCells();
}

//change to single step mode and advance by one timestep
public void advance() {
	//calculate live neighbor counts for each cell
	for (int i = 0; i < NUM_VERTICAL_CELLS; i++) {
		for (int j = 0; j < NUM_HORIZONTAL_CELLS; j++) {
			neighbors = 0;
			for (int ii = -1; ii <= 1; ii++) {
				for (int jj = -1; jj <= 1; jj++) {
					if (ii == 0 && jj == 0) {
						continue;
					}
					int newX = (j + jj + NUM_HORIZONTAL_CELLS) % NUM_HORIZONTAL_CELLS;
					int newY = (i + ii + NUM_VERTICAL_CELLS) % NUM_VERTICAL_CELLS;
					if (cellState[newY][newX]) {
						neighbors ++;
					}
				}
			}
			neighborCount[i][j] = neighbors;
		}
	}

	//update cell state based on neightbor count
	for (int i = 0; i < NUM_VERTICAL_CELLS; i++) {
		for (int j = 0; j < NUM_HORIZONTAL_CELLS; j++) {
			if (cellState[i][j] && neighborCount[i][j] != 2 && neighborCount[i][j] != 3) {
				cellState[i][j] = false;
			}
			else if (!cellState[i][j] && neighborCount[i][j] == 3) {
				cellState[i][j] = true;
			}
		}
	}
}

//COOL PATTERNS

//draw generic pattern (assumes that the input is an n by 2 array)
public void drawPattern(int[][] pattern, int x, int y) {
	for (int i = 0; i < pattern.length; i++) {
		cellState[y + pattern[i][1]][x + pattern[i][0]] = true;
	}
}

//draw a simple glider
public void drawGlider(int x, int y) {
	int[][] glider = {
		{0, 0},	{1, 0},	{2, 0},	{2, 1},	{1, 2}
	};
	drawPattern(glider, x, y);
}

//draw the simplest known glider gun that keeps producing gliders
public void drawGliderGun(int x, int y) {
	int[][] gun = {
		{1, 5},	{1, 6},	{2, 5},	{2, 6},	{11, 5}, {11, 6}, {11, 7}, {12, 4},
		{12, 8}, {13, 3}, {13, 9}, {14, 3}, {14, 9}, {15, 6}, {16, 4}, {16, 8},
		{17, 5}, {17, 6}, {17, 7}, {18, 6}, {21, 3}, {21, 4}, {21, 5}, {22, 3},
		{22, 4}, {22, 5}, {23, 2}, {23, 6},	{25, 1}, {25, 2}, {25, 6}, {25, 7},
		{35, 3}, {35, 4}, {36, 3}, {36, 4}
	};
	drawPattern(gun, x, y);
}

//draw an LWSS spaceship
public void drawLWSS(int x, int y) {
	int[][] lwss = {
		{0, 0},	{0, 2},	{1, 3},	{2, 3},	{3, 0}, {3, 3}, {4, 1}, {4, 2}, {4, 3}
	};
	drawPattern(lwss, x, y);	
}

//GUI STUFF

//draw the GUI controls
public void drawControls() {
	fill(0);
	rect(NUM_HORIZONTAL_CELLS * CELL_WIDTH, 0, CONTROLS_WIDTH, NUM_VERTICAL_CELLS * CELL_HEIGHT);
	fill(255);
	text("Mode: " + (mode == SINGLE_STEP_MODE ? "Single Step" : "Continuous"), NUM_HORIZONTAL_CELLS * CELL_WIDTH + 20, 30);
	text("Insert Patterns", NUM_HORIZONTAL_CELLS * CELL_WIDTH + 20, 280);
	for (int i = 0; i < buttons.length; i++) {
		buttons[i].draw(200);
	}
	line(NUM_HORIZONTAL_CELLS * CELL_WIDTH, 250, NUM_HORIZONTAL_CELLS * CELL_WIDTH + CONTROLS_WIDTH, 250);

}

//Button class that is used plenty of times in the GUI controls
class Button {
	int x;
	int y;
	int width;
	int height;
	String buttonText;
	String hotkey = "";

	//constructor for buttons with hotkeys
	Button(int x, int y, int width, int height, String buttonText, String hotkey) {
		this(x, y, width, height, buttonText);
		this.hotkey = hotkey;
	}

	//constructor for buttons for patterns
	Button(int x, int y, int width, int height, String buttonText) {
		this.x = NUM_HORIZONTAL_CELLS * CELL_WIDTH + x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.buttonText = buttonText;
	}

	//what happens when you click the button
	public void click() {
		if (mouseX > x && mouseX < x + width && mouseY > y && mouseY < y + height) {
			if (hotkey == "C") {
				clearGrid();
			}
			else if (hotkey == "R") {
				randomizeGrid();
			}
			else if (hotkey == "G") {
				changeMode();
			}
			else if (hotkey == "Space") {
				advanceStep();
			}
			else {
				//inserting patterns
				clearGrid();
				if (buttonText == "Gliders") {
					drawGlider(30, 30);
					drawGlider(40, 40);
					drawLWSS(50, 50);
					drawLWSS(60, 60);
				}
				else if (buttonText == "Glider Gun") {
					drawGliderGun(30, 30);
				}

				drawCells();
			}
		}
	}

	//change color upon hovering on button
	public void hover() {
		if (mouseX > x && mouseX < x + width && mouseY > y && mouseY < y + height) {
			draw(100);
		}
		else {
			draw(200);
		}
	}

	//draw the actual button
	public void draw(int col) {
		fill(col);
		rect(x, y, width, height);
		fill(0);
		text(buttonText + hotkeyify(), x + 2, y + 4, width, height);
	}

	//really, a stupid function. i am saddened that i created a function named like this -_-
	public String hotkeyify() {
		if (hotkey == "") {
			return "";
		}
		return " (" + hotkey + ")";
	}
};
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Murali_Varma_hw1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
