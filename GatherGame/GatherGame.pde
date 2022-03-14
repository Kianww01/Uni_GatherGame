Gamemode gameMode; //<>//
// Defines all the timers
CountDown splashscreenTimer;
CountDown levelOneTimer;
CountDown levelOneSplashscreenTimer;
CountDown levelTwoSplashscreenTimer;
CountDown levelTwoTimer;
CountDown levelThreeSplashscreenTimer;
CountDown levelThreeTimer;

// Constants for Level Select
final int LEVELSPLASHSCREEN = 0;
final int LEVELONE = 1;
final int LEVELTWO = 2;
final int LEVELTHREE = 3;

int level = LEVELSPLASHSCREEN;
boolean hasGeneratedLevel = false;

int currentLevelScore = 0;
int score = 0;
int lives = 5;
int numOfVegetablesCollected;

boolean invincible = false;
int invincibilityTimer = 0;

float randomXPos;
float randomYPos;

Player player;
// Defines ArrayLists
ArrayList<Collectible> collectibleList = new ArrayList();
ArrayList<Enemy> enemyList = new ArrayList();
ArrayList<Enemy> butterflyList = new ArrayList();
ArrayList<Obstacle> obstacleList = new ArrayList();

PImage grass;

// Movement checks for collision system
boolean canMoveUp = true;
boolean canMoveDown = true;
boolean canMoveLeft = true;
boolean canMoveRight = true;

float animationX;
float animationY;
boolean animationRunning = false;

int smokeCount = 0;
ArrayList<PImage> smokeImages = new ArrayList();
PImage imageLoader;

void setup() {
  // Screen Size
  size(600, 400);

  // Sets initial gamemode
  gameMode = Gamemode.SPLASHSCREEN;

  // Sets Timers
  splashscreenTimer = new CountDown(10); 
  levelOneSplashscreenTimer = new CountDown(15); 
  levelOneTimer = new CountDown(45); 
  levelTwoSplashscreenTimer = new CountDown(50);
  levelTwoTimer = new CountDown(95); 
  levelThreeSplashscreenTimer = new CountDown(100); 
  levelThreeTimer = new CountDown(160);

  player = new Player((width/2) - 20, (height/2) - 20);

  grass = loadImage("Grass.png");

  for (int count = 1; count <= 8; count++) {
    imageLoader = loadImage("Smoke" + count + ".png");
    smokeImages.add(imageLoader);
  }
}

// Called 60 times a second
void draw() {
  gameModeSelect();
}

void playing() {
  // Inputs combination of collectibles, enemies and obstacles for each level into the level generator
  if (!hasGeneratedLevel) {
    switch(level) {
    case LEVELONE:
      levelGenerator(3, 3, 1, 1);
      break;
    case LEVELTWO:
      levelGenerator(5, 5, 2, 2);
      break;
    case LEVELTHREE:
      levelGenerator(8, 8, 3, 3);
      break;
    }
  }

  background(grass);
  player.render();

  // Loops through each collectible in the arraylist
  for (int i = 0; i < collectibleList.size(); i++) {
    Collectible currentCollectible = collectibleList.get(i);
    if (player.collectibleCrash(currentCollectible)) {  
      // Stores positions for collection animation to use
      animationX = currentCollectible.x;
      animationY = currentCollectible.y;
      animationRunning = true;
      // Deletes the collectible and adds the corresponding score
      collectibleList.remove(currentCollectible);
      currentLevelScore += currentCollectible.score;
      numOfVegetablesCollected += 1;
    }
    currentCollectible.render();
  }

  if (numOfVegetablesCollected == 3) {
    numOfVegetablesCollected = 0;
    lives += 1;
  }

  if (animationRunning == true) {
    collectedAnimation(animationX, animationY);
  }

  // Loops through the enemy arraylist
  for (int i = 0; i < enemyList.size(); i++) {
    Enemy currentEnemy = enemyList.get(i);
    // Checks if player has collided with enemy and if the player has recently been hit giving them temporary invincibility
    if (player.enemyCrash(currentEnemy) && invincible == false) {
      // Removes a life 
      lives -= 1; 
      // Enables temporary invincibility
      invincible = true;
    }
    currentEnemy.update();

    invincibility();
  }

  // Loops through the obstacle array list
  for (int i = 0; i < obstacleList.size(); i++) {
    Obstacle currentObstacle = obstacleList.get(i);  
    currentObstacle.render();

    int canMove = player.obstacleCrash(currentObstacle);

    // Switch statement to determine if a player is trying to move through an obstacle
    // Disables the movement depending on what side of the obstacle they are on
    switch(canMove) {
    case 1:
      canMoveUp = false;
      break;
    case 2: 
      canMoveDown = false;
      break;
    case 3:
      canMoveLeft = false;
      break;
    case 4:
      canMoveRight = false;
      break;
    }
  }

  for  (int i = 0; i < butterflyList.size(); i++) {
    Enemy currentButterfly = butterflyList.get(i);

    if (player.butterflyCrash(currentButterfly) && invincible == false) {
      // Removes a life 
      lives -= 1; 
      // Enables temporary invincibility
      invincible = true;
    }
    currentButterfly.update();

    invincibility();
  }

  fill(255, 255, 255);
  // Changes the timer displayed on screen
  switch(level) {
  case LEVELONE:
    text("Time Remaining: " + levelOneTimer.getRemainingTime(), 67, 20);
    break;
  case LEVELTWO:
    text("Time Remaining: " + levelTwoTimer.getRemainingTime(), 67, 20);
    break;
  case LEVELTHREE:
    text("Time Remaining: " + levelThreeTimer.getRemainingTime(), 67, 20);
    break;
  }

  // Displays score for current level and lives remaining
  text("Current Level Score: " + currentLevelScore, 78, 40);
  text("Lives Remaining: " + lives, 65, 60);


  // End of level one 
  if (level == LEVELONE) {
    if (levelOneTimer.getRemainingTime() == 0) {
      level = LEVELTWO;
      levelReset();
    }
  }
  // End of level two
  if (level == LEVELTWO) {
    if (levelTwoTimer.getRemainingTime() == 0) {
      level = LEVELTHREE;
      levelReset();
    }
  }
  // End of level 3
  if (level == LEVELTHREE) {
    if (levelThreeTimer.getRemainingTime() == 0) {
      score += currentLevelScore;
      // Goes to game over screen as all levels have been completed
      gameMode = Gamemode.FINISHED;
    }
  }
  // Goes to gameover screen if the player runs out of lives
  if (lives == 0) {
    score += currentLevelScore;
    gameMode = Gamemode.FINISHED;
  }
}

void levelReset() {
  // Resets all necessary variables for a new level
  score += currentLevelScore;
  currentLevelScore = 0;
  collectibleList.clear();
  enemyList.clear();
  obstacleList.clear();
  butterflyList.clear();
  player.x = width/2 - 20;
  player.y = height/2 - 20;
  canMoveUp = true;
  canMoveDown = true;
  canMoveLeft = true;
  canMoveRight = true;
  hasGeneratedLevel = false;
  gameMode = Gamemode.SPLASHSCREEN;
}

void invincibility() {
  // Temporary invincibility 
  if (invincible == true) {
    final int INVINCIBILITYCOOLDOWN = 600;
    if (invincibilityTimer > INVINCIBILITYCOOLDOWN) {
      invincibilityTimer = 0;
      invincible = false;
    } else {
      invincibilityTimer++;
    }
  }
}

void levelGenerator(int collectiblesToGenerate, int enemiesToGenerate, int obstaclesToGenerate, int butterfliesToGenerate) {
  for (int count = 0; count < obstaclesToGenerate; count++) {
    randomXPos = randomXGenerator(false);
    randomYPos = randomYGenerator(false);

    // Used to prevent Obstacles from spawning inside eachother or other items
    for (int i = 0; i < obstacleList.size(); i++) {
      Obstacle currentObstacle = obstacleList.get(i);
      if (dist(randomXPos + 30, randomYPos + 30, currentObstacle.x + 30, currentObstacle.y + 30) < 80) {
        if (randomXPos - 45 <= 50)
        {
          randomXPos += 60;
        } else if (randomXPos + 45 >= width - 50) {
          randomXPos -= 60;
        } else {
          randomXPos += 60;
        }

        if (randomYPos - 45 <= 50) {
          randomYPos += 60;
        } else if (randomYPos + 45 >= height - 50) {
          randomYPos -= 60;
        } else {
          randomYPos += 60;
        }
      }
    }    

    obstacleList.add(new Rock(randomXPos, randomYPos));
  }

  for (int count = 0; count < collectiblesToGenerate; count++) {      
    int random = (int) random(1, 3);

    randomXPos = randomXGenerator(false);
    randomYPos = randomYGenerator(false);

    // Used to prevent collectibles from spawning inside each other
    for (int i = 0; i < collectibleList.size(); i++) {
      Collectible currentCollectible = collectibleList.get(i);
      if (dist(randomXPos + 20, randomYPos + 20, currentCollectible.x + 20, currentCollectible.y + 20) < 50) {
        if (randomXPos - 45 <= 50) {
          randomXPos += 45;
        } else if (randomXPos + 45 >= width - 50) {
          randomXPos -= 45;
        } else {
          randomXPos += 45;
        }

        if (randomYPos - 45 <= 50) {
          randomYPos += 45;
        } else if (randomYPos + 45 >= height - 50) {
          randomYPos -= 45;
        } else {
          randomYPos += 45;
        }
      }
    }
    // Used to prevent collectibles from spawning inside of obstacles
    for (int i = 0; i < obstacleList.size(); i++) {
      Obstacle currentObstacle = obstacleList.get(i);
      if (dist(randomXPos + 30, randomYPos + 30, currentObstacle.x + 30, currentObstacle.y + 30) < 60) {
        if (randomXPos - 80 <= 50)
        {
          randomXPos += 80;
        } else if (randomXPos + 80 >= width - 50) {
          randomXPos -= 80;
        } else {
          randomXPos += 80;
        }

        if (randomYPos - 80 <= 50) {
          randomYPos += 80;
        } else if (randomYPos + 80 >= height - 50) {
          randomYPos -= 80;
        } else {
          randomYPos += 80;
        }
      }
    }  

    // Generates either a carrot or a cabbage collectible
    if (random == 1) {
      collectibleList.add(new Carrot(randomXPos, randomYPos));
    } else if (random == 2) {
      collectibleList.add(new Cabbage(randomXPos, randomYPos));
    }
  }

  for (int count = 0; count < enemiesToGenerate; count++) {
    randomXPos = randomXGenerator(true);
    randomYPos = randomYGenerator(true);

    // Used to prevent Enemies from spawning inside of eachother
    for (int i = 0; i < enemyList.size(); i++) {
      Enemy currentEnemy = enemyList.get(i);
      if (dist(randomXPos, randomYPos, currentEnemy.x, currentEnemy.y) < 35) {
        if (randomXPos - 45 <= 50)
        {
          randomXPos += 45;
        } else if (randomXPos + 45 >= width - 50) {
          randomXPos -= 45;
        } else {
          randomXPos += 45;
        }

        if (randomYPos - 45 <= 50) {
          randomYPos += 45;
        } else if (randomYPos + 45 >= height - 50) {
          randomYPos -= 45;
        } else {
          randomYPos += 45;
        }
      }
    }    
    // Used to prevent enemies from spawning inside of obstacles
    for (int i = 0; i < obstacleList.size(); i++) {
      Obstacle currentObstacle = obstacleList.get(i);
      if (dist(randomXPos + 30, randomYPos + 30, currentObstacle.x + 30, currentObstacle.y + 30) < 80) {
        if (randomXPos - 45 <= 50)
        {
          randomXPos += 60;
        } else if (randomXPos + 45 >= width - 50) {
          randomXPos -= 60;
        } else {
          randomXPos += 60;
        }

        if (randomYPos - 45 <= 50) {
          randomYPos += 60;
        } else if (randomYPos + 45 >= height - 50) {
          randomYPos -= 60;
        } else {
          randomYPos += 60;
        }
      }
    }  
    enemyList.add(new Fox(randomXPos, randomYPos));
  }

  switch(butterfliesToGenerate) {
  case 1:
    butterflyList.add(new Butterfly(8, 368));
    break;
  case 2:
    butterflyList.add(new Butterfly(8, 368));
    butterflyList.add(new Butterfly(568, 368));
    break;
  case 3:
    butterflyList.add(new Butterfly(8, 368));
    butterflyList.add(new Butterfly(568, 368));
    butterflyList.add(new Butterfly(568, 8));
    break;
  }

  hasGeneratedLevel = true;
}

// Generates a random X position for collectibles, enemies and obstacles
float randomXGenerator(boolean isEnemy) {
  int randomX = (int) random(1, 3);

  if (isEnemy == true) {
    if (randomX == 1) {
      // Left Side 
      return random(0, 220);
    } else if (randomX == 2) {
      // Right Side 
      return random(340, width - 50);
    } else {
      return 0;
    }
  } else {

    // Left Side of Player
    if (randomX == 1) {
      return random(20, width/2 - 50);
    }
    // Right Side of Player
    else if (randomX == 2) {
      return random(width/2 + 80, width - 50 );
    } else {
      return 0;
    }
  }
}

// Generates a random Y position for collectibles, enemies and obstacles
float randomYGenerator(boolean isEnemy) {
  int randomY = (int) random(1, 3);

  if (isEnemy == true) {
    if (randomY == 1) {
      // Top Side 
      return random(0, 220);
    } else if (randomY == 2) {
      // Bottom Side 
      return random(280, height - 50);
    } else {
      return 0;
    }
  } else {

    // Above Player
    if (randomY == 1) {
      return random(20, height/2 - 60);
    }
    // Below Player
    else if (randomY == 2) {
      return random(height/2 + 60, height - 60);
    } else {
      return 0;
    }
  }
}

// Splashscreen gamemode to show starting splashscreens and all level intro screens
void splashscreen() {
  if (level == LEVELSPLASHSCREEN) {
    background(96, 128, 56);
    textSize(14);
    textAlign(CENTER);
    fill(0);
    text("You are a farmer, your goal is to collect all of the carrots and cabbages", width/2, height/2);
    text("Carrots are worth 2 points, cabbages are worth 1", width/2, height/2 + 20);
    text("Make sure to avoid the obstacles and enemies", width/2, height/2 + 40);
    text("Time Remaining: " + splashscreenTimer.getRemainingTime(), 70, 20);

    if (splashscreenTimer.getRemainingTime() == 0) {
      background(96, 128, 56);
      textSize(14);
      textAlign(CENTER);
      fill(0);
      text("LEVEL ONE", width/2, height/2);
      text("3 Collectibles. 3 Foxes. 1 Butterfly. 1 Obstacle", width/2, height/2 + 20);
      text("30 seconds to complete", width/2, height/2 + 40);
      text("Time Remaining: " + levelOneSplashscreenTimer.getRemainingTime(), 70, 20);

      if (levelOneSplashscreenTimer.getRemainingTime() == 0) {
        gameMode = Gamemode.PLAYING;
        level = LEVELONE;
      }
    }
  }
  if (level == LEVELTWO) {
    background(96, 128, 56);
    textSize(14);
    textAlign(CENTER);
    fill(0);
    text("LEVEL TWO", width/2, height/2);
    text("5 Collectibles. 5 Foxes. 2 Butterflies. 2 Obstacles", width/2, height/2 + 20);
    text("45 seconds to complete", width/2, height/2 + 40);
    text("Time Remaining: " + levelTwoSplashscreenTimer.getRemainingTime(), 70, 20);

    if (levelTwoSplashscreenTimer.getRemainingTime() == 0) {
      gameMode = Gamemode.PLAYING;
    }
  }
  if (level == LEVELTHREE) {
    background(96, 128, 56);
    textSize(14);
    textAlign(CENTER);
    fill(0);
    text("LEVEL THREE", width/2, height/2);
    text("8 Collectibles. 8 Foxes. 3 Butterflies. 3 Obstacles", width/2, height/2 + 20);
    text("60 seconds to complete", width/2, height/2 + 40);
    text("Time Remaining: " + levelThreeSplashscreenTimer.getRemainingTime(), 70, 20);

    if (levelThreeSplashscreenTimer.getRemainingTime() == 0) {
      gameMode = Gamemode.PLAYING;
    }
  }
}

// Game Over screen
void gameOver() {
  background(96, 128, 56);
  textSize(14);
  textAlign(CENTER);
  fill(0);
  text("Game Over", width/2, height/2);
  text("Final Score: " + score, width/2, height/2 + 20);
  text("Lives Left: " + lives, width/2, height/2 + 40);
}

// Basic smoke animation whenever a collectible is collided with
void collectedAnimation(float x, float y) { 
  if (smokeCount >= 0 && smokeCount < 6) {
    image(smokeImages.get(0), x + 20, y + 20);
  } else if (smokeCount >= 6 && smokeCount < 12) {
    image(smokeImages.get(1), x + 20, y + 20);
  } else if (smokeCount >= 12 && smokeCount < 18) {
    image(smokeImages.get(2), x + 20, y + 20);
  } else if (smokeCount >= 18 && smokeCount < 24) {
    image(smokeImages.get(3), x + 20, y + 20);
  } else if (smokeCount >= 24 && smokeCount < 30) {
    image(smokeImages.get(4), x + 20, y + 20);
  } else if (smokeCount >= 36 && smokeCount < 42) {
    image(smokeImages.get(5), x + 20, y + 20);
  } else if (smokeCount >= 48 && smokeCount < 54) {
    image(smokeImages.get(6), x + 20, y + 20);
  } else if (smokeCount >= 54 && smokeCount < 60) {
    image(smokeImages.get(7), x + 20, y + 20);
  } else {
    smokeCount = 0;
    animationRunning = false;
  }
  smokeCount++;
}

// Changes the gamemode
void gameModeSelect() {
  switch(gameMode) {
  case SPLASHSCREEN:
    splashscreen();
    break;
  case PLAYING:
    playing();
    break;
  case FINISHED:
    gameOver();
    break;
  }
}

// Movement system
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP && (player.y) > 0 && canMoveUp) {
      player.y -= 5;
      player.moveUp();
      // Resets player movements after colliding with an obstacle from above
      canMoveDown = true;
      canMoveLeft = true;
      canMoveRight = true;
    }
    if (keyCode == DOWN && (player.y + 65) < height && canMoveDown) {
      player.y += 5;
      player.moveDown();
      // Resets player movements after colliding with an obstacle from below
      canMoveUp = true;
      canMoveLeft = true;
      canMoveRight = true;
    }
    if (keyCode == LEFT && (player.x) > 0 && canMoveLeft) {
      player.x -= 5;
      player.moveLeft();
      // Resets player movements after colliding with an obstacle from the right
      canMoveUp = true;
      canMoveDown = true;
      canMoveRight = true;
    }
    if (keyCode == RIGHT && (player.x + 60) < width && canMoveRight) {
      player.x += 5;
      player.moveRight();
      // Resets player movements after colliding with an obstacle from the left
      canMoveUp = true;
      canMoveDown = true;
      canMoveLeft = true;
    }
  }
}

// Resets movement animation counter and sets the idle image to the first image for the direction the player was moving
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      player.currentImage = player.moveUpImages.get(0);
      player.moveUpCounter = 0;
    }
    if (keyCode == DOWN) {
      player.currentImage = player.moveDownImages.get(0);
      player.moveDownCounter = 0;
    }
    if (keyCode == LEFT) {
      player.currentImage = player.moveLeftImages.get(0);
      player.moveLeftCounter = 0;
    }
    if (keyCode == RIGHT) {
      player.currentImage = player.moveRightImages.get(0);
      player.moveRightCounter = 0;
    }
  }
}
