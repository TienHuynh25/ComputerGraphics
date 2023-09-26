/*
Use Bresenham's line algorithm to draw a line on the raster between
 the two given points. Modify the raster using setColor() and setPixel() ONLY.
 */
void bresenhamLine(int fromX, int fromY, int toX, int toY) {
  final color BLUE = color(0.5f, 1f, 0.9f);
  int deltaX = abs(toX - fromX);
  int deltaY = abs(toY - fromY);
  int curX = fromX;
  int curY = fromY;
  int stepX = (fromX < toX) ? 1 : -1;
  int stepY = (fromY < toY) ? 1 : -1;
  float e = 0;

  if (deltaX == 0) {
    while (curY != toY) {
      //setColor(BLUE);
      setPixel(new PVector(curX, curY));
      curY += stepY;
    }
    return;
  } else if (deltaY == 0) {
    while (curX != toX) {
      //setColor(BLUE);
      setPixel(new PVector(curX, curY));
      curX += stepX;
    }
    return;
  }

  float slope = abs(float(deltaY) / float(deltaX));
  
  if (deltaX >= deltaY) {
    while (curX != toX) {
      //setColor(BLUE);
      setPixel(new PVector(curX, curY));
      e += slope;
      if (e >= 0.5) {
        curY += stepY;
        e -= 1;
      }
      curX += stepX;
    }
  } else {
    while (curY != toY) {
      //setColor(BLUE);
      setPixel(new PVector(curX, curY));
      e += 1/slope;
      if (e >= 0.5) {
        curX += stepX;
        e -= 1;
      }
      curY += stepY;
    }
  }
}

/*
Don't change anything below here
 */

final int LENGTH_X = 125;
final int LENGTH_Y = 125;
final int LINE_OFFSET = 52;

void testBresenham() {
  final color WHITE = color(1f, 1f, 1f);
  final color RED = color(1f, 0f, 0f);

  final int CENTER_X = 125;
  final int CENTER_Y = 125;

  buffer.updatePixels(); // display everything drawn so far

  buffer.stroke(RED);
  // comparison lines
  drawTestAllQuadrants(CENTER_X, CENTER_Y);

  buffer.loadPixels(); // switch back to editing raster
  setColor(WHITE);

  // using the implementation of Bresenham's algorithm
  drawBresenhamAllQuadrants(CENTER_X, CENTER_Y);
}

void drawBresenhamAllQuadrants(int centerX, int centerY) {
  for (int signX=-1; signX<=1; signX+=2) {
    int startX = signX*centerX;
    for (int signY=-1; signY<=1; signY+=2) {
      int startY = signY*centerY;
      drawBresenhamPattern(startX, startY);
    }
  }
}

void drawBresenhamPattern(int startX, int startY) {
  for (int sign=-1; sign<=1; sign+=2) {
    int endXHorizontal = startX + sign*LENGTH_X;
    int endYVertical = startY + sign*LENGTH_Y;
    bresenhamLine(startX, startY, endXHorizontal, startY);
    bresenhamLine(startX, startY, startX, endYVertical);
  }

  for (int signX=-1; signX<=1; signX+=2) {
    int endXHorizontal = startX + signX*LENGTH_X;
    int endXOffset = startX + signX*LINE_OFFSET;
    for (int signY=-1; signY<=1; signY+=2) {
      int endYVertical = startY + signY*LENGTH_Y;
      int endYOffset = startY + signY*LINE_OFFSET;
      bresenhamLine(startX, startY, endXOffset, endYVertical);
      bresenhamLine(startX, startY, endXHorizontal, endYOffset);
    }
  }
}

void drawTestAllQuadrants(int centerX, int centerY) {
  for (int signX=-1; signX<=1; signX+=2) {
    int startX = signX*centerX;
    for (int signY=-1; signY<=1; signY+=2) {
      int startY = signY*centerY;
      drawTestPattern(startX, startY);
    }
  }
}

void drawTestPattern(int startX, int startY) {
  for (int sign=-1; sign<=1; sign+=2) {
    int endXHorizontal = startX + sign*LENGTH_X;
    int endYVertical = startY + sign*LENGTH_Y;
    shiftedLine(startX, startY, endXHorizontal, startY);
    shiftedLine(startX, startY, startX, endYVertical);
  }

  for (int signX=-1; signX<=1; signX+=2) {
    int endXHorizontal = startX + signX*LENGTH_X;
    int endXOffset = startX + signX*LINE_OFFSET;
    for (int signY=-1; signY<=1; signY+=2) {
      int endYVertical = startY + signY*LENGTH_Y;
      int endYOffset = startY + signY*LINE_OFFSET;
      shiftedLine(startX, startY, endXOffset, endYVertical);
      shiftedLine(startX, startY, endXHorizontal, endYOffset);
    }
  }
}

void shiftedLine(int x0, int y0, int x1, int y1) {
  final int LINE_SHIFT = 3;

  // shift left/right or up/down
  int xDir = -Integer.signum(y1 - y0);
  int yDir = Integer.signum(x1 - x0);

  int px0 = rasterToProcessingX(x0 + xDir*LINE_SHIFT);
  int py0 = rasterToProcessingY(y0 + yDir*LINE_SHIFT);

  int px1 = rasterToProcessingX(x1 + xDir*LINE_SHIFT);
  int py1 = rasterToProcessingY(y1 + yDir*LINE_SHIFT);

  buffer.line(px0, py0, px1, py1);
}

int rasterToProcessingX(int rx) {
  return width/2 + rx;
}

int rasterToProcessingY(int ry) {
  return height/2 - ry;
}
