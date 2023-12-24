class Zombie {
  PVector position;
  
  int hitsRemaining = 3;
  
  float [] speed = {0.5, 1, 1.75};  // Zombies move at different speeds
  
  PImage michaelJackson = loadImage("MJZombie.gif");
  PImage skateBoard = loadImage("SkateboardZombie.png");
  PImage rollerSkate = loadImage("RollerSkaterZombie.png");
  
  PImage [] zombieImage = {michaelJackson, skateBoard, rollerSkate};
  
  int zombieType;  // 0 = MJ, 1 = skateBoard, 2 = rollerSkate
  
  int transparency;
  
  Zombie (int zombieType, int rowIndex) {
    this.zombieType = zombieType;
    position = new PVector(round(tileWidth * 10), round(tileHeight * (rowIndex + 1) + tileHeight / 3));  // Start at the very right of the screen
    transparency = 255;
  }
  
  void draw() {
    imageMode(CENTER);
    tint(255, transparency);  // Add transparencys
    image(zombieImage[zombieType], position.x, position.y);
    tint(255, 255);
  }
  
  void move() {
    position.x -= speed[zombieType];
  }
  
  PVector getPosition() {
    return position;
  }
  
  // Returns true if pea hit zombie (used to remove pea)
  boolean isHit(PVector pea) {
    if (pea.x >= position.x) {
      if (hitsRemaining > 0) {
        hitsRemaining -= 1;
      transparency -= 51;  // Make zombie more and more transparent for every hit
      }
      return true;
    }
    return false;
  }
  
  // Returns true if zombie is dead (no more hits remaining)
  boolean isZombieDead() {
    if (hitsRemaining == 0) {
      return true;
    }
    return false;
  }
}
