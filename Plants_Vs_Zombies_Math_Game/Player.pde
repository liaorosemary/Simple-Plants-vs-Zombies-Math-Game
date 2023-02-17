class Player {
  PVector position;
  
  int currentRow;
  
  int peaSize = 50;
  
  int step = 3;
  
  ArrayList<PVector> row1 = new ArrayList<PVector>();
  ArrayList<PVector> row2 = new ArrayList<PVector>();
  ArrayList<PVector> row3 = new ArrayList<PVector>();
  ArrayList<PVector> row4 = new ArrayList<PVector>();
  ArrayList<PVector> row5 = new ArrayList<PVector>();
  
  ArrayList [] peas = new ArrayList [] {row1, row2, row3, row4, row5};
  
  PImage Peashooter = loadImage("Peashooter.png");
    
  Player(float width) {
    currentRow = 3;  // Player starts in row 3 (middle row)
    position = new PVector(2 * tileWidth - tileWidth / 3, screenCenterY);  // Horizontally placed in column 1
  }
  
  void draw() {
    imageMode(CENTER);
    image(Peashooter, position.x, position.y);
  }
  
  void move(int direction) {
    // Player moves down when down arrow is pressed
    if (direction == 1) {
      if (currentRow + 1 <= rows) {
        position.y += direction * tileHeight;
        currentRow += 1;
      }
    }
    // Player moves up when up arrow is pressed
    if (direction == -1) {
      if (currentRow - 1 > 0) {
        position.y += direction * tileHeight;
        currentRow -= 1;
      }
    }
  }
  
  // Adds a pea when player answers correctly
  void addPea() {
    peas[currentRow - 1].add(position.copy());
  }
  
  // Remove pea when pea hits a zombie
  void removePea(int row, int index) {
    peas[row].remove(index);
  }
  
  // Return list of peas for collision detection
  ArrayList[] returnPeas() {
    return peas;
  }
  
  // Move peas forward
  void movePeas() {
    for (int row = 0; row < peas.length; row ++){
      for (int i = 0; i < peas[row].size(); i ++) {
        PVector pea = (PVector) peas[row].get(i);
        
        // Draw the pea
        fill(0, 255, 0);
        stroke(0);  // Black border
        strokeWeight(2);
        ellipse(pea.x, pea.y, peaSize, peaSize);
        
        pea.x += step;  // Move the pea forward
      }
    }
  }
}
