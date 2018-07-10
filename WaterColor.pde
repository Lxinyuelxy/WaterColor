int strokeWidth = 80;
//float projection_r = 12;
//float projection_angle = PI / 4.0;

void setup(){
  size(960, 480);
  noLoop();
}

void draw() {
  background(255);
  ArrayList<PVector> basePoints = getPolygon(width/2, height/2, 10);
  ArrayList<PVector> basePoints1  = getBasePolygon(basePoints, 1);
  ArrayList<PVector> basePoints2  = getBasePolygon(basePoints1, 2);
  ArrayList<PVector> basePoints3  = getBasePolygon(basePoints2, 3);
  
  for(int i = 0; i < 80; i++) {
    ArrayList<PVector> points;
    if(i > 33) {
      points  = getBasePolygon(basePoints1, 4);
    }
    else if(i > 66) {
      points = getBasePolygon(basePoints2, 4);
    }
    else {
      points = getBasePolygon(basePoints3, 4);
    }
    pushStyle();
    noStroke();
    fill(255, 0, 0, 5);
    drawPolygon(points);
    popStyle();
    
    
    pushStyle();
    pushMatrix();
    translate(100, 100);
    noStroke();
    fill(0, 0, 255, 5);
    drawPolygon(points);
    popMatrix();
    popStyle();
    
    pushStyle();
    pushMatrix();
    translate(-100, 100);
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
    PVector midPoint = PVector.div(PVector.add(startPoint, endPoint), 2);
    
    float dis = dist(startPoint.x, startPoint.y, endPoint.x, endPoint.y);
    float len = constrain(getRandomGaussian(0, dis/6), -dis/3, dis/3);
    PVector direction_loc = PVector.sub(endPoint, startPoint).normalize();
    PVector loc = direction_loc.mult(len).add(midPoint);
    
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