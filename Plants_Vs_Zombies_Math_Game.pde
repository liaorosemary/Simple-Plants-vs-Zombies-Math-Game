 // This needs to be imported for background music to work:
import processing.sound.*;
/* Steps for importing (Reference site here: https://stackoverflow.com/questions/30559754/how-to-install-the-sound-library-for-processing-in-a-simple-way):
  In the Processing Editor, click: Sketch --> Import Library --> Add Library
  Search for "Sound" in libraries and click to install
*/

boolean pauseGame = false;

float percentage;  // needed for progress bar

int level = 1;

// Variable to hold user inputed answer
String answer;

float generateZombiesProbability;  // For randomizing when new zombies are generated

int gameStatus;

float buttonWidth;
float buttonHeight;

// Set widths and heights of tiles
float tileWidth;  // this is also the same width for some images
float tileHeight;

float screenCenterX;
float screenCenterY;

int columns = 8;
int rows = 5;
  
int spacing = 100;  // Spacing between buttons and text

int smallText = 20;
int bigText = 75;

int totalZombies, zombiesKilled, zombiesToMake;

// Background music
SoundFile battleMusic;
SoundFile gameOverMusic;
SoundFile levelCompletedMusic;

// Images
PImage CrazyDave;
PImage Discoball;

Question question;

// Game characters
Player player;  // Player
ArrayList [] zombies;  // Array for zombies divided by the row they are on
ArrayList zombieRow1;
ArrayList zombieRow2;
ArrayList zombieRow3;
ArrayList zombieRow4;
ArrayList zombieRow5;

void setup() {
  fullScreen();
  
  // Set widths and positions
  tileWidth = width / 10;  // Split screen width into 10 equal parts (resulting in 8 columns and 2 blanks spaces of equal width on the sides of the discofloor)
  tileHeight = height / 7;  // Split screen height into 7 equal parts (5 columns and 2 blank column spaces) 
  
  screenCenterX = width / 2;
  screenCenterY = height / 2;
  
  buttonWidth = tileWidth * 2;
  buttonHeight = tileHeight / 2;
  
  totalZombies = 10;  // Start with 10 zombies in level 1
  
  // Might not need
  question = new Question(); 
    
  // Background music
  battleMusic = new SoundFile(this, "Music/Music.wav");
  gameOverMusic = new SoundFile(this, "Music/Plants vs. Zombies - The Zombies Ate Your Brains! - Failure in the game - Sound effect.wav");;
  levelCompletedMusic = new SoundFile(this, "Music/Plants vs. Zombies Victory Music Guitar Cover with TAB.wav");
  
  // Images
  CrazyDave = loadImage("CrazyDave.png");
  Discoball = loadImage("Discoball.png");
  
  reset(0);  // reset with no level up (0)
}

void draw() {
  // Game lost
  if (gameStatus == 1) {
    gameLost();
  }
  
  // Game won
  else if (percentage == 1) {
    gameStatus = 2;
    gameWon();
  }
  
  // Game is ongoing
  else {
    
    rectMode(CORNER);
    
    setBackground();  // Draw tiles and images
    
    progressBar();  // Draw progress bar and percentage
    
    player.draw();  // Draw player
    
    // Display the question and player's typed answer at the top of the screen (on the discoball)
    textAlign(CENTER, CENTER);
    textSize(100);
    text(question.getQuestion() + answer, screenCenterX, Discoball.height / 4);
    
    // For generating zombies randomly
    if (generateZombiesProbability < 100) {
      generateZombiesProbability += 0.5;  // Increase the proabability that the next zombie will be generated
    }
    // Generate zombies if the probability is high enough and there are still more zombies needed to make
    if (random(generateZombiesProbability) > 99.8 && zombiesToMake > 0) {
      // Randomly choose zombie's assigned row
      int rowIndex = (int) random(1, rows);
      zombies[rowIndex].add(new Zombie(int(random(3)), rowIndex));
      
      // Decrease the number of zombies to make
      zombiesToMake -= 1;
    }
    
    // Draw the zombies
    for (int row = 0; row < zombies.length; row ++) {
      for (int i = 0; i < zombies[row].size(); i ++) {
        Zombie zombie = (Zombie) zombies[row].get(i);
        zombie.draw();
        zombie.move();
      }
    }
    
    player.movePeas();  // peas = what is shot by the player
    
    // Check for collisions between peas and zombies and remove them accordingly
    ArrayList [] peas = player.returnPeas();    
    for (int row = 0; row < rows; row ++) {
      int i = 0;  // Zombie index in row
      while (i < zombies[row].size()) {
        Zombie zombie = (Zombie) zombies[row].get(i);
        PVector zombiePosition = zombie.getPosition();
        boolean zombieDead = false;     
        
        // When zombie crosses to the end of the field, player loses
        if (zombiePosition.x <= tileWidth) {
          gameStatus = 1;
        }
        
        int j = 0;  // Pea index in row   
        
        while (j < peas[row].size()) {
          PVector peaPosition = (PVector) peas[row].get(j);
          
          // Remove peas when it hits a zombie
          if (zombie.isHit(peaPosition)) {
            player.removePea(row, j);
            j -= 1;  // -1 because +1 will be added to j every time and the pea index must remain the same for the next loop
          }
          // Remove pea when it goes past the screen
          else if (peaPosition.x > width) {
            player.removePea(row, j);       
          }
          
          // Remove zombies when they die
          zombieDead = zombie.isZombieDead();
          if (zombieDead) {
            zombies[row].remove(zombie);
            zombiesKilled += 1;
            break;
          }
          j += 1;
        }
        // +1 to zombie index in row if zombie is not dead, else, zombie index remains the same
        if (!zombieDead) {
          i += 1;
        }
      }
    }
  }
}

void reset(int resetMode) {
  
  percentage = 0;
  
  answer = "";
  
  generateZombiesProbability = 0;
  
  gameStatus = 0;  // Statuses: 0 = playing, 1 = lost, 2 = won
  
  zombiesKilled = 0;
  
  // Play the background music
  battleMusic.play();
  battleMusic.loop();  // Ensure the the music is replayed when song reaches its end
  
  // Player
  player = new Player(tileWidth);
  
  // Array for containing zombie objects
  zombies = new ArrayList[rows];  // Array for zombies divided by the row they are on
  zombieRow1 = new ArrayList<Zombie>();
  zombieRow2 = new ArrayList<Zombie>();
  zombieRow3 = new ArrayList<Zombie>();
  zombieRow4 = new ArrayList<Zombie>();
  zombieRow5 = new ArrayList<Zombie>();   
  zombies[0] = zombieRow1;
  zombies[1] = zombieRow2;
  zombies[2] = zombieRow3;
  zombies[3] = zombieRow4;
  zombies[4] = zombieRow5;
  
  zombies[2].add(new Zombie(0, 2));  // Start off with Michael Jackson zombie in the middle row
  
  // Game won and leveling up
  if (resetMode == 1){
    totalZombies += 5;  // Add 5 more zombies
    level += 1;
  }
  zombiesToMake = totalZombies - 1;
  
  question.generateQuestion();  // Generate initial question
  
  loop();  // Call draw loop whenever game is reset
}

void gameLost() {
  noLoop();  // Stop draw loop
  
  background(0,0,0);
  textAlign(CENTER, CENTER);
  
  fill(255, 0, 0);
  textSize(bigText);
  text("The zombie ate your brainz!!!", screenCenterX, screenCenterY);
  text("Game over.", screenCenterX, screenCenterY + spacing);
  
  // Restart level button
  drawRestartLevelButton();
  
  
  battleMusic.pause();
  gameOverMusic.play();
}

void gameWon() {
  background(0,0,0);
  noLoop();  // Stop draw loop
  
  fill(0, 255, 0);
  
  textAlign(CENTER, CENTER);
  textSize(bigText);
  text("You beat the zombies!", screenCenterX, screenCenterY);
  text("Excellent!", screenCenterX, screenCenterY + spacing);
    
  // Restart level button
  drawRestartLevelButton();
  
  // Next level button
  fill(0, 0, 0);
  rect(screenCenterX, screenCenterY + 3 * spacing, buttonWidth, buttonHeight);
  fill(255, 255, 255);
  text("Level " + (level + 1), screenCenterX, screenCenterY + 3 * spacing);
  
  battleMusic.pause();
  levelCompletedMusic.play();
}

void drawRestartLevelButton() {
  textSize(smallText);
  stroke(255, 255, 255);  
  rectMode(CENTER);
  fill(0, 0, 0);
  rect(screenCenterX, screenCenterY + 2 * spacing, buttonWidth, buttonHeight);
  fill(255, 255, 255);
  text("Restart Level " + level, screenCenterX, screenCenterY + 2 * spacing);
}

void setBackground() {
  color [] colors = new color[] {color(#D4FF47), color(#DC2C48), color(#98195B), color(#ecb673), color(#ce6492), color(#681258), color(#322c5f), color(#C3CCFF)};

  background(15, 9, 36);
  noStroke();
  
  // Draw field (5 rows, 8 columns)
  for (int row = 0; row < rows; row ++) {
    for (int col = 0; col < columns; col ++) {
      fill(colors[int(random(colors.length))]);
      rect(tileWidth * (col + 1), tileHeight * (row + 1), tileWidth, tileHeight);
    }
  }
  imageMode(CENTER);
  image(CrazyDave, tileWidth / 2, screenCenterY);
  image(Discoball, screenCenterX, 0);
}

void progressBar() {
  percentage = float(zombiesKilled) / totalZombies;  // Convert zombiesKilled to float in order to get percentage as a float
  
  // Draw black rectangle (which gets filled by green rectangle as more zombies are killed)
  fill(0, 0, 0);
  rect(tileWidth, tileHeight / 2, tileWidth * 2, tileHeight / 3, 50);  // Top left corner, drawn with rounded borders
  
  // Draw green rectangle (which starts empty and fills up black rectangle as more zombies are killed)
  fill(0, 255, 0);
  rect(tileWidth, tileHeight / 2, percentage * (tileWidth * 2), tileHeight / 3, 50);
  
  // Display the percentage progress (how many zombies are killed out of how many zombies to kill in total)
  textAlign(LEFT, TOP);
  fill(255, 255, 255);
  textSize(smallText);
  text((percentage * 100) + "%", tileWidth, tileHeight / 2);
}


void keyPressed() {
  // Execute the following if the game is not paused
  if (!pauseGame) {
    
    // Move player if up or down arrow keys are pressed
    if (keyCode == UP || keyCode == DOWN) {
      player.move(((keyCode == UP) ? -1 : 1));
    }
    
    // Delete last character if backspace key is pressed
    else if (keyCode == 8){
      if (answer.length() > 0) {
        answer = answer.substring(0, answer.length()-1);
      }
    }
    
    // If input is a digit, evaluate the answer and add the digit to the input answer
    else if (Character.isDigit(key)) {
      answer += key;
      if (question.evaluate(int(answer))) {
        question.generateQuestion();
        answer = "";
        player.addPea();
      }
    }
  }
  // When space bar is pressed, pause and unpause game
  if (keyCode == 32) {
    if (!pauseGame) {
      noLoop();
      pauseGame = true;
    }
    else {
      loop();
      pauseGame = false;
    }
  }
}

void mouseClicked() {
  // Game was lost
  if (gameStatus == 1) {
    
    // Restart level button clicked
    if ((mouseY > (screenCenterY + 2 * spacing) - buttonHeight / 2) && (mouseY < (screenCenterY + 2 * spacing) + buttonHeight / 2)) {
      if ((mouseX > screenCenterX - buttonWidth / 2) && (mouseX < screenCenterX + buttonWidth / 2)) {
            
          gameOverMusic.pause();  // Stop the game over music
          reset(0);
      }
    }
  }
  
  // Game was won  
  else if (gameStatus == 2) {    
    
    // Player clicked on a button    
    if ((mouseX > screenCenterX - buttonWidth / 2) && (mouseX < screenCenterX + buttonWidth / 2)) {
            
      levelCompletedMusic.pause();  // Stop the victory music
      
      // Restart level button clicked
      if ((mouseY > (screenCenterY + 2 * spacing) - buttonHeight / 2) && (mouseY < (screenCenterY + 2 * spacing) + buttonHeight / 2)) {
            reset(0);
      }
      // Player clicked on next level button
      else if ((mouseY > (screenCenterY + 3 * spacing) - buttonHeight / 2) && (mouseY < (screenCenterY + 3 * spacing) + buttonHeight / 2)) {
        reset(1);
      }
    }
  }
}
