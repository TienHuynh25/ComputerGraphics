/*
Define any mathematical operations that you need here.
 */

PVector crossProduct(PVector v1, PVector v2){
    return v1.cross(v2);
}

float dotProduct(PVector v1, PVector v2){
    return v1.dot(v2);
}

PVector avgVec(PVector v1, PVector v2, PVector v3){
  PVector v = PVector.add(v1, v2);
  v = PVector.add(v, v3);
  return PVector.div(v, 3);
}

PVector[] findEdges(PVector v1, PVector v2, PVector v3){
    PVector[] edges = new PVector[3];
    edges[0]  = PVector.sub(v2, v1);
    edges[1] = PVector.sub(v3, v2);
    edges[2] = PVector.sub(v1, v3);
    
    return edges;
}

PVector findNormals(PVector v1, PVector v2){
  return crossProduct(v1,v2);
}

boolean isFront(PVector normal){
     PVector front = new PVector(0,0,50);
     float result = dotProduct(front, normal);
     if(result > 0){return true;}
     else{return false;}
}

PVector[] findVector(PVector point, PVector[] vertices){
    PVector[] p = new PVector[3];
    p[0] = PVector.sub(point, vertices[0]);
    p[1] = PVector.sub(point, vertices[1]);   
    p[2] = PVector.sub(point, vertices[2]);  
    return p;
}

float[] findBarycentric(PVector point, PVector[] vertices) {
    PVector[] p = findVector(point, vertices);
    float[] a = new float[Triangle.NUM_VERTICES];
    Triangle t = new Triangle(vertices);

    for (int i = 0; i < 3; i++) {
        float crossProductZ = crossProduct(p[i], t.edges[i]).z;

        // Check for division by zero
        if (crossProductZ != 0) {
            a[i] = crossProductZ / (1.0 / 2.0);
        } else {
            // Handle the case where the cross product z component is zero
            // You might want to set a default value or handle it based on your requirements
            a[i] = 0.0;
        }
    }

    // Sum of a[0], a[1], a[2]
    float aTotal = a[0] + a[1] + a[2];

    // Normalize the values to get the barycentric coordinates
    for (int i = 0; i < 3; i++) {
          a[i] = a[i] / aTotal;
    }
    return a;
}


boolean inside(PVector point, PVector[] vertices){
    PVector[] p = findVector(point,vertices);
    PVector[] cross = new PVector[Triangle.NUM_VERTICES];
    Triangle t = new Triangle(vertices);
    for(int i=0; i<3;i++){
      cross[i] = crossProduct(p[i], t.edges[i]);   
    }
    if( (cross[0].z>0 & cross[1].z>0 & cross[2].z>0) || (cross[0].z<0 & cross[1].z<0 & cross[2].z<0) ){
      return true;
    }else{
      return false;
    }
}
