/*
Define any mathematical operations that you need here.
 */

PVector crossProduct(PVector v1, PVector v2){
    return v1.cross(v2);
}

float dotProduct(PVector v1, PVector v2){
    return v1.dot(v2);
}

PVector avgNormal(PVector v1, PVector v2, PVector v3){
  return ((v2.add(v1).add(v3)).div(3)).normalize();
}
