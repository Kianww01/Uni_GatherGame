class Player {
  int x;
  int y;

  PImage standingStill = loadImage("Whitebeard_StandingStill.png");  
  PImage currentImage = standingStill;

  PImage imageLoader;

  int moveRightCounter = 0;
  int moveLeftCounter = 0;
  int moveDownCounter = 0;
  int moveUpCounter = 0;


  ArrayList<PImage> moveRightImages = new ArrayList();
  ArrayList<PImage> moveLeftImages = new ArrayList();
  ArrayList<PImage> moveDownImages = new ArrayList();
  ArrayList<PImage> moveUpImages = new ArrayList();

  Player(int x, int y) {
    this.x = x;
    this.y = y;

    // Loop for adding all images to arraylists (for animation)
    for (int count = 1; count <= 7; count++) {
      imageLoader = loadImage("Whitebeard_MoveRight" + count + ".png");
      moveRightImages.add(imageLoader);
      imageLoader = loadImage("Whitebeard_MoveLeft" + count + ".png");
      moveLeftImages.add(imageLoader);
      imageLoader = loadImage("Whitebeard_MoveDown" + count + ".png");
      moveDownImages.add(imageLoader);
      imageLoader = loadImage("Whitebeard_MoveUp" + count + ".png");
      moveUpImages.add(imageLoader);
    }
  }

  void render() {
    fill (255, 0, 0);
    // Sets the image each time draw is called (60 times a second)
    image(currentImage, this.x, this.y);
  }

  // Player - Collectible collision system
  boolean collectibleCrash(Collectible collectible) {
    return(dist(this.x + 20, this.y + 30, collectible.x + 20, collectible.y + 20) < 20); // ADD SMOKE EFFECT ANIMATION
  }

  // Player - Enemy collision system
  boolean enemyCrash(Enemy enemy) {
    if (enemy.movement == enemy.VERTICAL) {
      return(dist(this.x + 20, this.y + 30, enemy.x + 15, enemy.y + 15) < 15);
    } else if (enemy.movement == enemy.HORIZONTAL) {
      return(dist(this.x + 20, this.y + 30, enemy.x + 22.5, enemy.y + 15) < 25);
    } else {
      return false;
    }
  }

  // Player - Butterfly collision system
  boolean butterflyCrash(Enemy butterfly) {
    return(dist(this.x + 20, this.y + 30, butterfly.x + 12, butterfly.y + 12) < 25);
  }

  // Player - Obstacle collision system
  int obstacleCrash(Obstacle obstacle) {
    if (dist(this.x + 22.5, this.y, obstacle.x + 30, obstacle.y + 30) < 25) {
      return 1;
    } else if (dist(this.x + 22.5, this.y + 65, obstacle.x + 30, obstacle.y + 30) < 30) {
      return 2;
    } else if (dist(this.x, this.y + 32.5, obstacle.x + 30, obstacle.y + 30) < 30) {
      return 3;
    } else if (dist(this.x + 45, this.y + 32.5, obstacle.x + 30, obstacle.y + 30) < 30) {
      return 4;
    } else {
      return 0;
    }
  }

  // ANIMATION
  void moveRight() {
    if (moveRightCounter < 6) { 
      currentImage = moveRightImages.get(0);
    } else if (moveRightCounter < 12) { 
      currentImage = moveRightImages.get(1);
    } else if (moveRightCounter < 18) { 
      currentImage = moveRightImages.get(2);
    } else if (moveRightCounter < 24) { 
      currentImage = moveRightImages.get(3);
    } else if (moveRightCounter < 30) { 
      currentImage = moveRightImages.get(4);
    } else if (moveRightCounter < 36) { 
      currentImage = moveRightImages.get(5);
    } else if (moveRightCounter < 42) { 
      currentImage = moveRightImages.get(6);
    } else { 
      currentImage = moveRightImages.get(0);
      moveRightCounter = 0;
    }
    moveRightCounter++;
  }

  void moveLeft() {
    if (moveLeftCounter < 6) { 
      currentImage = moveLeftImages.get(0);
    } else if (moveLeftCounter < 12) { 
      currentImage = moveLeftImages.get(1);
    } else if (moveLeftCounter < 18) { 
      currentImage = moveLeftImages.get(2);
    } else if (moveLeftCounter < 24) { 
      currentImage = moveLeftImages.get(3);
    } else if (moveLeftCounter < 30) { 
      currentImage = moveLeftImages.get(4);
    } else if (moveLeftCounter < 36) { 
      currentImage = moveLeftImages.get(5);
    } else if (moveLeftCounter < 42) { 
      currentImage = moveLeftImages.get(6);
    } else { 
      currentImage = moveLeftImages.get(0);
      moveLeftCounter = 0;
    }
    moveLeftCounter++;
  }

  void moveDown() {
    if (moveDownCounter < 6) { 
      currentImage = moveDownImages.get(0);
    } else if (moveDownCounter < 12) { 
      currentImage = moveDownImages.get(1);
    } else if (moveDownCounter < 18) {
      currentImage = moveDownImages.get(2);
    } else if (moveDownCounter < 24) {
      currentImage = moveDownImages.get(3);
    } else if (moveDownCounter < 30) { 
      currentImage = moveDownImages.get(4);
    } else if (moveDownCounter < 36) { 
      currentImage = moveDownImages.get(5);
    } else if (moveDownCounter < 42) { 
      currentImage = moveDownImages.get(6);
    } else { 
      currentImage = moveDownImages.get(0);
      moveDownCounter = 0;
    }
    moveDownCounter++;
  }

  void moveUp() {
    if (moveUpCounter < 6) { 
      currentImage = moveUpImages.get(0);
    } else if (moveUpCounter < 12) { 
      currentImage = moveUpImages.get(1);
    } else if (moveUpCounter < 18) { 
      currentImage = moveUpImages.get(2);
    } else if (moveUpCounter < 24) { 
      currentImage = moveUpImages.get(3);
    } else if (moveUpCounter < 30) { 
      currentImage = moveUpImages.get(4);
    } else if (moveUpCounter < 36) { 
      currentImage = moveUpImages.get(5);
    } else if (moveUpCounter < 42) { 
      currentImage = moveUpImages.get(6);
    } else { 
      currentImage = moveUpImages.get(0);
      moveUpCounter = 0;
    }
    moveUpCounter++;
  }
}
