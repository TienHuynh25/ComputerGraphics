/*
COMP 3490 Assignment 1 Template
 */

// for the test mode with one triangle
Triangle[] singleTriangle;
Triangle[] rotatedSingleTriangle;

// for drawing and rotating the cylinder
Triangle[] cylinderList;
Triangle[] rotatedCylinderList;

// to make the image rotate - don't change these values
float theta = 0.0;  // rotation angle
float dtheta = 0.01; // rotation speed

PGraphics buffer;

void setup() {
  // RGB values range over 0..1 rather than 0..255
  colorMode(RGB, 1.0f);

  buffer = createGraphics(600, 600);
    
  PVector[] vertices = new PVector[Triangle.NUM_VERTICES];
  PVector[] vertexNormals = new PVector[Triangle.NUM_VERTICES];
  
  vertices[1] = new PVector(10, 50,30);
  vertices[0] = new PVector(-100, 200,30);
  vertices[2] = new PVector(-250, 100,30);
  vertexNormals[0] = crossProduct(vertices[0],vertices[1]).normalize();
  vertexNormals[1] = crossProduct(vertices[0],vertices[1]).normalize();
  vertexNormals[2] = crossProduct(vertices[0],vertices[1]).normalize();
  
  singleTriangle = new Triangle[1]; // change this line
  singleTriangle[0] = new Triangle(vertices, vertexNormals);
  
  
  rotatedSingleTriangle = copyTriangleList(singleTriangle);
  cylinderList = new Triangle[]{}; // change this line
  rotatedCylinderList = copyTriangleList(cylinderList);

  printSettings();
}

void settings() {
  size(600, 600); // hard-coded canvas size, same as the buffer
}

/*
You should read this function carefully and understand how it works,
 but you should not need to edit it
 */
void draw() {
  buffer.beginDraw();
  buffer.colorMode(RGB, 1.0f);
  buffer.background(0); // clear to black each frame

  /*
  CAUTION: none of your functions should call loadPixels() or updatePixels().
   This is already done in the template. Extra calls will probably break things.
   */
  buffer.loadPixels();

  if (doRotate) {
    theta += dtheta;
    if (theta > TWO_PI) {
      theta -= TWO_PI;
    }
  }

  //do not change these blocks: rotation is already set up for you
  if (displayMode == DisplayMode.TEST_LINES) {
    testBresenham();
  } else if (displayMode == DisplayMode.SINGLE_TRIANGLE) {
    rotateTriangles(singleTriangle, rotatedSingleTriangle, theta);
    drawTriangles(rotatedSingleTriangle);
  } else if (displayMode == DisplayMode.CYLINDER) {
    rotateTriangles(cylinderList, rotatedCylinderList, theta);
    drawTriangles(rotatedCylinderList);
  }

  buffer.updatePixels();
  buffer.endDraw();
  image(buffer, 0, 0); // draw our raster image on the screen
}

/*
 Receives an array of triangles and draws them on the raster by
 calling draw2DTriangle()
 */
void drawTriangles(Triangle[] triangles) {
  for(int i=0; i<triangles.length ;i++){
    draw2DTriangle(triangles[i]);
  }
}

/*
Use the projected vertices to draw the 2D triangle on the raster.
 Several tasks need to be implemented:
 - cull degenerate or back-facing triangles
 - draw triangle edges using bresenhamLine()
 - draw normal vectors if needed
 - fill the interior using fillTriangle()
 */
void draw2DTriangle(Triangle t) {
  //this.vertexNormals[j];
  final color BLUE = color(0.5f, 1f, 0.9f);
  PVector[] vertices = new PVector[Triangle.NUM_VERTICES];
  
  vertices = projectTriangle(t);
  if(vertices ==  null){return;}
  
  setColor(BLUE);
  bresenhamLine(int(vertices[0].x),int(vertices[0].y),int(vertices[1].x), int(vertices[1].y));
  bresenhamLine(int(vertices[1].x),int(vertices[1].y),int(vertices[2].x), int(vertices[2].y));
  bresenhamLine(int(vertices[2].x),int(vertices[2].y),int(vertices[0].x), int(vertices[0].y));
  if(doNormals){drawNormals(t);}
}

void backFaceCull(){
  return;
}

/*
 Draw the normal vectors at each vertex and triangle center
 */
final int NORMAL_LENGTH = 20;
final float[] FACE_NORMAL_COLOR = {0f, 1f, 1f}; // cyan
final float[] VERTEX_NORMAL_COLOR = {1f, 1f, 0f}; // yellow

void drawNormals(Triangle t) {
  PVector[] vertices = new PVector[Triangle.NUM_VERTICES];
  vertices = projectTriangle(t);
  
  PVector centerNormal = avgNormal(t.vertexNormals[0],t.vertexNormals[1],t.vertexNormals[2]);
  print("normals"+centerNormal.x,centerNormal.y,centerNormal.z);
  PVector v1Point = t.vertices[0].add(centerNormal.mult(NORMAL_LENGTH));
  PVector v2Point = t.vertices[1].add(centerNormal.mult(NORMAL_LENGTH));
  PVector v3Point = t.vertices[2].add(centerNormal.mult(NORMAL_LENGTH));
  
  v1Point = projectVertex(v1Point);
  v2Point = projectVertex(v2Point);
  v3Point = projectVertex(v3Point);
  print("point: "+vertices[0].x,vertices[0].y,v1Point.x,v1Point.y);
  if(v1Point == null || v2Point == null || v3Point == null){print("null normals");return;}
  
  setColor(VERTEX_NORMAL_COLOR);
  bresenhamLine(int(vertices[0].x),int(vertices[0].y),int(v1Point.x), int(v1Point.y));
  bresenhamLine(int(vertices[1].x),int(vertices[1].y),int(v2Point.x), int(v2Point.y));
  bresenhamLine(int(vertices[2].x),int(vertices[2].y),int(v3Point.x), int(v3Point.y));
}

/*
Fill the 2D triangle on the raster, using a scanline algorithm.
 Modify the raster using setColor() and setPixel() ONLY.
 */
void fillTriangle(Triangle t) {
  
}

/*
Given a point p, unit normal vector n, eye location, light location, and various
 material properties, calculate the Phong lighting at that point (see course
 notes and the assignment text for more details).
 Return an array of length 3 containing the calculated RGB values.
 */
float[] phong(PVector p, PVector n, PVector eye, PVector light,
  float[] material, float[][] fillColor, float shininess) {
  return null;
}