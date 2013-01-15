
//constants

int NUM_HORIZONTAL_CELLS = 100;
int NUM_VERTICAL_CELLS = 50;
int CELL_HEIGHT = 8;
int CELL_WIDTH = 8;

int SINGLE_STEP_MODE = 0;
int CONTINUOUS_MODE = 1;

//variables

boolean [][] cellState;
int [][] neighborCount;
int mode;
int neighbors;

void setup() {
	size(NUM_HORIZONTAL_CELLS * CELL_WIDTH, NUM_VERTICAL_CELLS * CELL_HEIGHT);
	background(0);
	stroke(100);

	//initialize variables
	cellState = new boolean[NUM_VERTICAL_CELLS][NUM_HORIZONTAL_CELLS];	//by default all cells are inititialized to false
	neighborCount = new int[NUM_VERTICAL_CELLS][NUM_HORIZONTAL_CELLS];	//by default all cells are inititialized to zero
	mode = SINGLE_STEP_MODE;
	drawCells();
}

void draw() {

}

void drawCells() {
	for (int i = 0; i < NUM_VERTICAL_CELLS; i++) {
		for (int j = 0; j < NUM_HORIZONTAL_CELLS; j++) {
			drawCell(i, j);
		}
	}
}

void drawCell(int i, int j) {
	if (cellState[i][j]) {
		fill(255);
	}
	else {
		fill(0);
	}
	rect (CELL_WIDTH * j, CELL_HEIGHT * i, CELL_WIDTH, CELL_HEIGHT);

}

void mousePressed() {
	if (mode != SINGLE_STEP_MODE) {
		//mouse clicks have effect only in single step mode
		return;
	}
	int xCell = mouseX/CELL_WIDTH;
	int yCell = mouseY/CELL_HEIGHT;
	cellState[yCell][xCell] = !cellState[yCell][xCell];
	drawCell(yCell, xCell);
}

void keyPressed() {
	//clear grid
	if (key == 'C' || key == 'c') {
		for (int i = 0; i < NUM_VERTICAL_CELLS; i++) {
			for (int j = 0; j < NUM_HORIZONTAL_CELLS; j++) {
				cellState[i][j] = false;
			}
		}
	}

	//randomize grid
	if (key == 'R' || key == 'r') {
		for (int i = 0; i < NUM_VERTICAL_CELLS; i++) {
			for (int j = 0; j < NUM_HORIZONTAL_CELLS; j++) {
				//random(2) gives a float between 0 and 2
				cellState[i][j] = (random(2) >= 1);
			}
		}
	}

	//change mode
	if (key == 'g' || key == 'G') {
		if (mode == SINGLE_STEP_MODE) {
			mode = CONTINUOUS_MODE;
		}
		else {
			mode = SINGLE_STEP_MODE;
		}
	}

	//advance step
	if (key == ' ') {
		mode = SINGLE_STEP_MODE;
		advance();
	}
	drawCells();
}

void advance() {
	for (int i = 0; i < NUM_VERTICAL_CELLS; i++) {
		for (int j = 0; j < NUM_HORIZONTAL_CELLS; j++) {
			neighbors = 0;
			for (int ii = -1; ii <= 1; ii++) {
				for (int jj = -1; jj <= 1; jj++) {
					if ( ii == 0 && jj == 0) {
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