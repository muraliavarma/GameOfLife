
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
void setup() {
	size(NUM_HORIZONTAL_CELLS * CELL_WIDTH + CONTROLS_WIDTH, NUM_VERTICAL_CELLS * CELL_HEIGHT);
	background(0);
	stroke(100);

	//initialize variables
	cellState = new boolean[NUM_VERTICAL_CELLS][NUM_HORIZONTAL_CELLS];	//by default all cells are inititialized to false
	neighborCount = new int[NUM_VERTICAL_CELLS][NUM_HORIZONTAL_CELLS];	//by default all cells are inititialized to zero
	mode = SINGLE_STEP_MODE;
	drawGlider();
	drawCells();

	//GUI Stuff
	buttons = new Button[4];
	buttons[0] = new Button(20, 60, 120, 20, "Clear", "C");
	buttons[1] = new Button(20, 100, 120, 20, "Randomize", "R");
	buttons[2] = new Button(20, 140, 120, 20, "Toggle Mode", "G");
	buttons[3] = new Button(20, 180, 120, 20, "Step Once", "Space");
	drawControls();
}

//called every draw cycle
void draw() {
	if (mode == CONTINUOUS_MODE) {
		advance();
		drawCells();
	}
}

//redraws all the cells based on cell data structure
void drawCells() {
	for (int i = 0; i < NUM_VERTICAL_CELLS; i++) {
		for (int j = 0; j < NUM_HORIZONTAL_CELLS; j++) {
			drawCell(i, j);
		}
	}
}

//draw a single cell
void drawCell(int i, int j) {
	if (cellState[i][j]) {
		fill(255);
	}
	else {
		fill(0);
	}
	rect (CELL_WIDTH * j, CELL_HEIGHT * i, CELL_WIDTH, CELL_HEIGHT);

}

//draw a simple glider
void drawGlider() {
	int midX = NUM_HORIZONTAL_CELLS / 2;
	int midY = NUM_VERTICAL_CELLS / 2;
	cellState[midY][midX] = cellState[midY][midX + 1] = cellState[midY][midX + 2] = cellState[midY + 1][midX + 2] = cellState[midY + 2][midX + 1] = true;
}

//called when the mouse is clicked
void mousePressed() {
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
void mouseMoved() {
	if (mouseX/CELL_WIDTH >= NUM_HORIZONTAL_CELLS) {
		//find which control the mouse is hovered on
		for (int i = 0; i < buttons.length; i++) {
			buttons[i].hover();
		}
	}
}

//called when some key is pressed
void keyPressed() {
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

void clearGrid() {
	for (int i = 0; i < NUM_VERTICAL_CELLS; i++) {
		for (int j = 0; j < NUM_HORIZONTAL_CELLS; j++) {
			cellState[i][j] = false;
		}
	}
	drawCells();
}

void randomizeGrid() {
	for (int i = 0; i < NUM_VERTICAL_CELLS; i++) {
		for (int j = 0; j < NUM_HORIZONTAL_CELLS; j++) {
			//random(2) gives a float between 0 and 2
			cellState[i][j] = (random(2) >= 1);
		}
	}
	drawCells();
}

void changeMode() {
	if (mode == SINGLE_STEP_MODE) {
		mode = CONTINUOUS_MODE;
	}
	else {
		mode = SINGLE_STEP_MODE;
	}
	drawControls();
}

void advanceStep() {
	mode = SINGLE_STEP_MODE;
	advance();
	drawControls();
	drawCells();
}

//change to single step mode and advance by one timestep
void advance() {
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

//draw the GUI controls
void drawControls() {
	fill(0);
	rect(NUM_HORIZONTAL_CELLS * CELL_WIDTH, 0, CONTROLS_WIDTH, NUM_VERTICAL_CELLS * CELL_HEIGHT);
	fill(255);
	text("Mode: " + (mode == SINGLE_STEP_MODE ? "Single Step" : "Continuous"), NUM_HORIZONTAL_CELLS * CELL_WIDTH + 20, 30);
	for (int i = 0; i < buttons.length; i++) {
		buttons[i].draw(200);
	}
	line(NUM_HORIZONTAL_CELLS * CELL_WIDTH, 250, NUM_HORIZONTAL_CELLS * CELL_WIDTH + CONTROLS_WIDTH, 250);

}

class Button {
	int x;
	int y;
	int width;
	int height;
	String buttonText;
	String hotkey;

	Button(int x, int y, int width, int height, String buttonText, String hotkey) {
		this.x = NUM_HORIZONTAL_CELLS * CELL_WIDTH + x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.buttonText = buttonText;
		this.hotkey = hotkey;
	}

	void click() {
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
				//do something else
			}
		}
	}

	void hover() {
		if (mouseX > x && mouseX < x + width && mouseY > y && mouseY < y + height) {
			draw(100);
		}
		else {
			draw(200);
		}
	}

	void draw(int col) {
		fill(col);
		rect(x, y, width, height);
		fill(0);
		text(buttonText + " (" + hotkey + ")", x + 2, y + 4, width, height);
	}
};
