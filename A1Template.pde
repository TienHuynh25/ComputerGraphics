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
  vertices[1] = new PVector(10, 50,30);
  vertices[2] = new PVector(-100, 200,30);
  vertices[0] = new PVector(-250, 100,30);
 
  singleTriangle = new Triangle[1]; // change this line
  singleTriangle[0] = new Triangle(vertices);
  rotatedSingleTriangle = copyTriangleList(singleTriangle);
  
  
  cylinderList = genTri(10,20);
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
  PVector[] vertices = new PVector[Triangle.NUM_VERTICES];
  
  vertices = projectTriangle(t);
  if(vertices ==  null){return;}
  if(!backFaceCull(t)){return;}
  
  fillTriangle(t);
  setColor(OUTLINE_COLOR);
  if(doOutline){
    bresenhamLine(int(vertices[0].x),int(vertices[0].y),int(vertices[1].x), int(vertices[1].y));
    bresenhamLine(int(vertices[1].x),int(vertices[1].y),int(vertices[2].x), int(vertices[2].y));
    bresenhamLine(int(vertices[2].x),int(vertices[2].y),int(vertices[0].x), int(vertices[0].y));
  }
  if(doNormals){drawNormals(t);}
}

boolean backFaceCull(Triangle t){
  PVector[] vertices2d = new PVector[Triangle.NUM_VERTICES];
  
  vertices2d = projectTriangle(t);
  if(vertices2d ==  null){return false;}
  Triangle triangle = new Triangle(vertices2d);
  if(crossProduct(triangle.edges[0],triangle.edges[1]).z == 0){ return false;}
  if(isFront(triangle.vertexNormals[0]) == false){return false;}
  return true;
}

/*
 Draw the normal vectors at each vertex and triangle center
 */
final int NORMAL_LENGTH = 20;
final float[] FACE_NORMAL_COLOR = {0f, 1f, 1f}; // cyan
final float[] VERTEX_NORMAL_COLOR = {1f, 1f, 0f}; // yellow

void drawNormals(Triangle t) {
  PVector[] vertices = new PVector[Triangle.NUM_VERTICES];
  
  PVector centerNormal = avgVec(t.vertexNormals[0],t.vertexNormals[1],t.vertexNormals[2]).normalize();
  PVector centerStart = avgVec(t.vertices[0],t.vertices[1],t.vertices[2]);
  
  print("\nnormals 1"+t.vertexNormals[0].x,t.vertexNormals[0].y,t.vertexNormals[0].z);
  print("\nnormals 2"+t.vertexNormals[1].x,t.vertexNormals[1].y,t.vertexNormals[1].z);
  print("\nnormals 3"+t.vertexNormals[2].x,t.vertexNormals[2].y,t.vertexNormals[2].z);
  print("\nnormals"+centerNormal.x,centerNormal.y,centerNormal.z);
  
  PVector v1Point = t.vertices[0].copy();
  v1Point = v1Point.add(t.vertexNormals[0].mult(NORMAL_LENGTH));
  
  PVector v2Point = t.vertices[1].copy();
  v2Point = v2Point.add(t.vertexNormals[1].mult(NORMAL_LENGTH));
  
  PVector v3Point = t.vertices[2].copy();
  v3Point = v3Point.add(t.vertexNormals[2].mult(NORMAL_LENGTH));
  
  PVector centerEnd = centerStart.copy();
  centerEnd = centerEnd.add(centerNormal.mult(NORMAL_LENGTH));
  
  vertices = projectTriangle(t);
  v1Point = projectVertex(v1Point);
  v2Point = projectVertex(v2Point);
  v3Point = projectVertex(v3Point);
  centerStart = projectVertex(centerStart);
  centerEnd = projectVertex(centerEnd);
  
  if(v1Point == null || v2Point == null || v3Point == null){print("null normals");return;}
  
  setColor(VERTEX_NORMAL_COLOR);
  bresenhamLine(int(vertices[0].x),int(vertices[0].y),int(v1Point.x), int(v1Point.y));
  bresenhamLine(int(vertices[1].x),int(vertices[1].y),int(v2Point.x), int(v2Point.y));
  bresenhamLine(int(vertices[2].x),int(vertices[2].y),int(v3Point.x), int(v3Point.y));
  bresenhamLine(int(centerStart.x),int(centerStart.y),int(centerEnd.x), int(centerEnd.y));
}

PVector[][] genPoints(int nbInY, int nbInTheta){
  float theta = 0f;
  PVector[][] indices = new PVector[nbInY+1][nbInTheta+1];
  float y = CYLINDER_HEIGHT;
  
  for(int j=0; j<=nbInY; j++){
    y = (CYLINDER_HEIGHT/2) - j*(CYLINDER_HEIGHT/nbInY);    
    if(y == CYLINDER_HEIGHT/2|| y == -CYLINDER_HEIGHT/2){
      indices[j][0] = new PVector(0,y,0);
    }
    else{
      indices[j][0] = new PVector(CYLINDER_RADIUS*sin(0f), y, CYLINDER_RADIUS*cos(0f));
    }
    
    for (int i=0; i<(nbInTheta); i++) {
      theta = TWO_PI*i/nbInTheta;
      indices[j][i+1] = new PVector(CYLINDER_RADIUS*sin(theta), y, CYLINDER_RADIUS*cos(theta));
    }

  }
  
  return indices;
}

Triangle[] genTri(int nbInY, int nbInTheta) {
  PVector[][] indices = genPoints(nbInY, nbInTheta);
  int total = ( (nbInY+1) * (nbInTheta+1) * 2) + 2 * (nbInTheta+1);
  Triangle[] triangles = new Triangle[total];
  int current = 0;

  // fill top endcap
  for (int i = 0; i <= nbInTheta; i++) {
    PVector[] vertices = new PVector[Triangle.NUM_VERTICES];
    vertices[0] = indices[0][0].copy();
    vertices[2] = indices[0][(i + 1) % nbInTheta].copy(); // Wrap around for the last point
    vertices[1] = indices[0][i].copy();
    triangles[current] = new Triangle(vertices);
    current++;
  }

  // fill bottom endcap
  for (int i = 0; i <= nbInTheta; i++) {
    PVector[] vertices = new PVector[Triangle.NUM_VERTICES];
    vertices[0] = indices[nbInY][0].copy();
    vertices[1] = indices[nbInY][(i + 1) % nbInTheta].copy(); // Wrap around for the last point
    vertices[2] = indices[nbInY][i].copy();
    triangles[current] = new Triangle(vertices);
    current++;
  }
  
  ////fill last slides
  //for (int j = 0; j <= nbInY; j++) {
  //    // Add an additional triangle to complete the bottom endcap
  //  PVector[] bottomVertices = new PVector[Triangle.NUM_VERTICES];
  //  bottomVertices[0] = indices[j][nbInTheta].copy();
  //  bottomVertices[1] = indices[j][0].copy();
  //  bottomVertices[2] = indices[j][(nbInTheta - 1) % nbInTheta].copy();
  //  triangles[current] = new Triangle(bottomVertices);
  //  current++;  
  //}

  // fill side
  for (int j = 0; j <= nbInY; j++) {
    for (int i = 0; i <= nbInTheta; i++) {
      PVector[] vertices = new PVector[Triangle.NUM_VERTICES];
      vertices[0] = indices[j][i].copy();
      vertices[1] = indices[(j + 1) % (nbInY + 1)][(i + 1) % nbInTheta].copy(); // Wrap around for the last point
      vertices[2] = indices[j][(i + 1) % nbInTheta].copy();
      triangles[current] = new Triangle(vertices);
      current++;

      vertices[0] = indices[j][i].copy();
      vertices[1] = indices[(j + 1) % (nbInY + 1)][i].copy();
      vertices[2] = indices[(j + 1) % (nbInY + 1)][(i + 1) % nbInTheta].copy(); // Wrap around for the last point
      triangles[current] = new Triangle(vertices);
      current++;
    }
  }
  

  return triangles;
}

/*
Fill the 2D triangle on the raster, using a scanline algorithm.
 Modify the raster using setColor() and setPixel() ONLY.
 */
void fillTriangle(Triangle t) {

  //3d -> 2d
  PVector[] vertices = projectTriangle(t);
  // Find the bounding box
  float xmin = min(vertices[0].x, vertices[1].x, vertices[2].x);
  float xmax = max(vertices[0].x, vertices[1].x, vertices[2].x);
  float ymin = min(vertices[0].y, vertices[1].y, vertices[2].y);
  float ymax = max(vertices[0].y, vertices[1].y, vertices[2].y);

  // Iterate over each scanline within the bounding box
  for (float y = ymin; y <= ymax; y++) {
    // Iterate over each pixel in the scanline
    for (float x = xmin; x <= xmax; x++) {
      // Check if the current pixel is inside the triangle
      PVector p = new PVector(x, y);
      if (inside(p,vertices)) {
        if(shadingMode == ShadingMode.FLAT){
            setColor(FLAT_FILL_COLOR);
            setPixel(p);
        }
        else if(shadingMode == ShadingMode.BARYCENTRIC){
          float[] bary = findBarycentric(p,vertices);
          setColor(bary[R], bary[G],bary[B]);
          setPixel(p);
        }
      }
    }
  }
  
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
