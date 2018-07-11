int strokeWidth = 80;

void setup(){
  size(640, 400);
  background(255, 230, 230);
  noLoop();
}

void draw() {
  ArrayList<PVector> basePoints = getPolygon(width/2-30, height/2-40, 10);
  ArrayList<PVector> basePoints1  = getBasePolygon(basePoints, 1);
  ArrayList<PVector> basePoints2  = getBasePolygon(basePoints1, 2);
  ArrayList<PVector> basePoints3  = getBasePolygon(basePoints2, 3);
  
  for(int layer = 0; layer < 100; layer++) {
    ArrayList<PVector> points;
    if(layer > 33) {
      points  = getBasePolygon(basePoints1, 3);
    }
    else if(layer > 66) {
      points = getBasePolygon(basePoints2, 3);
    }
    else {
      points = getBasePolygon(basePoints3, 3);
    }
    pushStyle();
    noStroke();
    fill(255, 0, 0, 5);
    drawPolygon(points);
    popStyle();
    
    pushStyle();
    pushMatrix();
    translate(60, 80);
    noStroke();
    fill(0, 0, 255, 5);
    drawPolygon(points);
    popMatrix();
    popStyle();
    
    pushStyle();
    pushMatrix();
    translate(-60, 80);
    noStroke();
    fill(0, 255, 0, 5);
    drawPolygon(points);
    popMatrix();
    popStyle();
    
  }

  //pushStyle();
  //noStroke();
  //fill(255, 0, 0);
  //drawPolygon(basePoints3);
  //popStyle();
  
  //pushStyle();
  //noFill();
  //drawPolygon(basePoints);
  //popStyle();
}

void drawPolygon(ArrayList<PVector> points) {
  beginShape();
  for (PVector point : points){
    vertex(point.x, point.y);
  }
  endShape(CLOSE);
}

ArrayList<PVector> getPolygon(int centerX, int centerY, int sides) {
  ArrayList<PVector> points = new ArrayList<PVector>();
  for (float angle = 0; angle < PI*2; angle += PI*2 / sides) {
    points.add(new PVector(strokeWidth*cos(angle) + centerX, strokeWidth*sin(angle) + centerY));
  }
  return points; 
}

ArrayList<PVector> getBasePolygon(ArrayList<PVector> points, int iterations) {
  if(iterations == 0) return points;
  else return getBasePolygon(deformation(points), iterations-1);
}

ArrayList<PVector> deformation(ArrayList<PVector> points) {
  
  ArrayList<PVector> result = new ArrayList<PVector>();
  
  for (int index = 0; index < points.size(); index++) {
    PVector startPoint = points.get(index);
    PVector endPoint;
    if(index == points.size()-1) endPoint = points.get(0);
    else endPoint = points.get(index+1);
    float dis = dist(startPoint.x, startPoint.y, endPoint.x, endPoint.y);
    PVector midPoint = PVector.div(PVector.add(startPoint, endPoint), 2);
    
    float len_loc = constrain(getRandomGaussian(0, dis/6), -dis/3, dis/3);
    PVector direction_loc = PVector.sub(endPoint, startPoint).normalize();
    PVector loc = direction_loc.mult(len_loc).add(midPoint);
    
    PVector perpendicular = PVector.sub(startPoint, endPoint).rotate(HALF_PI).normalize();
    float angle = constrain(getRandomGaussian(0, PI/3), 0, PI*2);
    PVector direction_angle = perpendicular.rotate(angle);
    
    float r = constrain(getRandomGaussian(dis/3, dis/6), dis/8, dis/2);

    PVector newPoint = direction_angle.mult(r).add(loc);
    result.add(startPoint);
    result.add(newPoint);
  }
  return result;
}

float getRandomGaussian(float mean, float std) {
  float value = randomGaussian();
  return (value*std) + mean;
}