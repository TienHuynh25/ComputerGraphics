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
