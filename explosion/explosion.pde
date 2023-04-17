ArrayList<Ball> balls = new ArrayList<Ball>();
int widthCell;
int heightCell;
int minRadius = 15;
int maxRadius = 15;
Cell[] cells;
int startI;
int stopI;
PVector[] init;
int startingFountainNb = 3;
int fountainNb = startingFountainNb;
Threading[] threads;
color[] colors;
int lastChange = 0;
float startingSpeed = 4;
float speed = startingSpeed;
int substeps = 2;
boolean pause = false;
int maxBalls = 3000;
ArrayList<Integer> rand = new ArrayList<Integer>();

void setup() {
  size(1000, 1000);
  noStroke();
  background(0, 0, 0, 1);
  colorMode(RGB);
  widthCell = ((int)width) / maxRadius + 1;
  threads = new Threading[max(widthCell/4, 1)];
  heightCell = ((int)height) / maxRadius + 1;
  cells = new Cell[widthCell * heightCell];
  for (int i = 0; i < cells.length; i++) {
    cells[i] = new Cell(i);
  }
}

void draw() {
  if (!pause) {
    background(0, 10);
    for (int i = 0; i < fountainNb; i++) {
      int randR = (int) random(minRadius, maxRadius);
      balls.add(new Ball(randR, new PVector((widthCell/2 - fountainNb/2) * (maxRadius + .15) + i * (maxRadius + .1), height/2), new PVector(0, 1).mult(speed), balls.size(), color(0)));
    }

    for (int i = 0; i < substeps; i++) {
      collision();
    }
    for (Ball b : balls) {
      b.update();
      b.show();
      b.pressure = 0;
    }
  } else {
    frameCount--;
  }
}

void collision() {
  updateCells();
  //first half to make it deterministic
  for (int i = 0; i < threads.length; i++) {
    threads[i] = new Threading((int) (i * (1. * widthCell/threads.length)), (int) (i *  (1. * widthCell/threads.length) + widthCell/(threads.length*2)), 1);
  }
  for (int i = 0; i < threads.length; i++) {
    threads[i].start();
  }
  try {
    for (int i = 0; i < threads.length; i++) {
      threads[i].join();
    }
  }
  catch (InterruptedException e) {
  }

  //second half
  for (int i = 0; i < threads.length; i++) {
    threads[i] = new Threading((int) (i * (1. * widthCell/threads.length) + widthCell/(threads.length*2)), (int)((i+1) *  (1. * widthCell/threads.length)), 2);
  }
  for (int i = 0; i < threads.length; i++) {
    threads[i].start();
  }
  try {
    for (int i = 0; i < threads.length; i++) {
      threads[i].join();
    }
  }
  catch (InterruptedException e) {
  }
}

void keyPressed() {
  if (key == 'p') {
    pause = !pause;
  } else if (key == 'e') {
    lastChange = 500;
  }
}
