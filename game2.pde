int ss, jj, zoom;
int[][][] game;
boolean running;
int lowThresh=0, highThresh=250;
int top=255, bottom=0;
float decay=5;
int decayTop=10, decayBottom=5;
boolean decaySign=true;
float lastDecayTime=0, decayInterval=2000;
int randomDecay=4;

void setup()
{
  zoom = 6;
  ss = int(1280/zoom);
  jj = int(1024/zoom);
  game = new int[ss][jj][2];
  running = true;
  size(1280,1024, P2D);
  frameRate(33);
  background(255);
  noStroke();
  fill(200);
}

void draw()
{
  decayTimer();
  scale(zoom);
  drawing();
  life();
}

void life() {
  if ( running ) {
    for (int x = 0; x < ss; x=x+1) {
      for (int y = 0; y < jj; y=y+1) {
        int count = neighbors(x, y);
        if (game[x][y][0] < 100) {
          if (count == 3) {
            game[x][y][1] = top;
          }
        }
        else if (count < 2 || count > 3) {
          game[x][y][1] -= decay;
        }
      }
    }
  }
}

void drawing() {
  for (int x = 0; x < ss; x++) {
    for (int y = 0; y < jj; y++) {
      if (game[x][y][1] > lowThresh) {
        game[x][y][0] = top;
        fill(game[x][y][1]);
        rect(x, y, 1, 1);
        if(random(10)>randomDecay) game[x][y][0] -=6;
      }
      else {
        if (game[x][y][0]>=0) game[x][y][0] -=3;
      }
    }
  }
}

void decayTimer() {
  if (millis() - lastDecayTime > decayInterval) {
    if (decaySign) decay++; 
    else decay--;
    if (decay<decayBottom || decay>decayTop) decaySign =  !decaySign;
    lastDecayTime=millis();
    println(decay);
  }
}

int neighbors(int x, int y)
{
  int total=0;
  if (game[(x + 1) % ss][y][0] > highThresh) total++; 
  if (game[x][(y + 1) % jj][0] > highThresh) total++;
  if (game[(x + ss - 1) % ss][y][0] > highThresh) total++;
  if (game[x][(y + jj - 1) % jj][0] > highThresh) total++;
  if (game[(x + 1) % ss][(y + 1) % jj][0] > highThresh) total++;
  if (game[(x + ss - 1) % ss][(y + 1) % jj][0] > highThresh) total++;
  if (game[(x + ss - 1) % ss][(y + jj - 1) % jj][0] > highThresh) total++;
  if (game[(x + 1) % ss][(y + jj - 1) % jj][0] > highThresh) total++;
  return total;
}
void keyPressed() {
  if ( key == 'c' ) {

    game = new int[ss][jj][2];
    running = false;
  }
  else {

    running = !running;
  }

  if ( running ) { 
    fill(top);
  } 
  else { 
    fill(200);
  }
}

int[][] pattern = {
  {
    0, 255, 255
  }
  , 
  {
    255, 255, 0
  }
  , 
  {
    0, 255, 0
  }
};


void mouseDragged() {
  if (mouseX>40 && mouseX < width-40 && mouseY > 40 && mouseY < height-40) {
  for ( int x = 0; x < pattern[0].length; x++ ) {
    for ( int y = 0; y < pattern.length; y++ ) {
      game[int(mouseX/zoom+x)][int(mouseY/zoom+y)][1] = pattern[y][x];
    }
  }
  }
}
