
//constants

int NUM_HORIZONTAL_CELLS = 100;
int NUM_VERTICAL_CELLS = 50;
int CELL_HEIGHT = 8;
int CELL_WIDTH = 8;

int EDIT_MODE = 0;
int SINGLE_STEP_MODE = 1;
int CONTINUOUS_MODE = 2;

//variables

int[][] cellState;
int mode;

void setup() {
	size(NUM_HORIZONTAL_CELLS * CELL_WIDTH, NUM_VERTICAL_CELLS * CELL_HEIGHT);
	background(0);

	//initialize variables

	cellState = new int[NUM_VERTICAL_CELLS][NUM_HORIZONTAL_CELLS];	//by default all cells are inititialized to 0
	mode = EDIT_MODE;
}

void draw() {
	drawCells();
}

void drawCells() {
	for (int i = 0; i < NUM_VERTICAL_CELLS; i++) {
		for (int j = 0; j < NUM_HORIZONTAL_CELLS; j++) {
			rect (CELL_WIDTH * j, CELL_HEIGHT * i, CELL_WIDTH, CELL_HEIGHT);
		}
	}
}

void mousePressed() {
	if (mode != EDIT_MODE) {
		//mouse clicks have effect only in edit mode
		return;
	}
	
}