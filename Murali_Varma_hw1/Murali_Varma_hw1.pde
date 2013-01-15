
//constants

int NUM_HORIZONTAL_CELLS = 100;
int NUM_VERTICAL_CELLS = 50;
int CELL_HEIGHT = 8;
int CELL_WIDTH = 8;

int SINGLE_STEP_MODE = 0;
int CONTINUOUS_MODE = 1;

//variables

boolean [][] cellState;
int mode;

void setup() {
	size(NUM_HORIZONTAL_CELLS * CELL_WIDTH, NUM_VERTICAL_CELLS * CELL_HEIGHT);
	background(0);
	stroke(100);

	//initialize variables
	cellState = new boolean[NUM_VERTICAL_CELLS][NUM_HORIZONTAL_CELLS];	//by default all cells are inititialized to 0
	mode = EDIT_MODE;
}

void draw() {
	drawCells();
}

void drawCells() {
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

void mousePressed() {
	if (mode != SINGLE_STEP_MODE) {
		//mouse clicks have effect only in single step mode
		return;
	}
	int xCell = mouseX/CELL_WIDTH;
	int yCell = mouseY/CELL_HEIGHT;
	cellState[yCell][xCell] = !cellState[yCell][xCell];
}