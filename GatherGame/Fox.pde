class Fox extends Enemy {
  Fox(float x, float y) {
    super(x, y);

    // Loop for adding all images to arraylists (for animation)
    for (int count = 1; count <= 3; count++) {
      imageLoader = loadImage("Fox_MoveRight" + count + ".png");
      moveRightImages.add(imageLoader);
      imageLoader = loadImage("Fox_MoveLeft" + count + ".png");
      moveLeftImages.add(imageLoader);
      imageLoader = loadImage("Fox_MoveDown" + count + ".png");
      moveDownImages.add(imageLoader);
      imageLoader = loadImage("Fox_MoveUp" + count + ".png");
      moveUpImages.add(imageLoader);
    }
    currentImage = moveRightImages.get(0);
  }

  @Override
    void render() {
    image(currentImage, this.x, this.y);
  }

  @Override
    void move() {
    // Sets initial direction based on where the enemy spawned
    if (getInitialMovementSet() == false) {
      if (getMovement() == VERTICAL) {
        // Spawned near bottom of the screen
        if (this.y >= 280 && this.y <= height - 50) {
          setVerticalDirection(UP);
          // Spawned near top of the screen
        } else if (this.y >= 0 && this.y <= 240) {
          setVerticalDirection(DOWN);
        }
      }

      if (getMovement() == HORIZONTAL) {
        // Spawned right side of the screen
        if (this.x >= 340 && this.x <= width - 50) {
          setHorizontalDirection(LEFT);
          // Spawned left side of the screen
        } else if (this.x >= 0 && this.x <= 220) {
          setHorizontalDirection(RIGHT);
        }
      }
      setInitialMovementSet(true);
    } 

    // Vertical Direction
    if (getMovement() == VERTICAL) {
      if (this.y >= height - 50 || !canMoveDown) {
        setVerticalDirection(UP);
        moveDownCounter = 0;
      } else if (this.y <= 0 || !canMoveUp) {
        setVerticalDirection(DOWN);
        moveUpCounter = 0;
      }
      // Vertical movement (speed and animation)
      if (getVerticalDirection() == UP) {
        this.y -= randomSpeed;
        canMoveDown = true;
        if (moveUpCounter < 12) { 
          currentImage = moveUpImages.get(0);
        } else if (moveUpCounter < 24) { 
          currentImage = moveUpImages.get(1);
        } else if (moveUpCounter < 36) { 
          currentImage = moveUpImages.get(2);
        } else {
          currentImage = moveUpImages.get(0);
          moveUpCounter = 0;
        }
        moveUpCounter++;
      } else if (getVerticalDirection() == DOWN) {
        this.y += randomSpeed;
        canMoveUp = true;
        if (moveDownCounter < 12) { 
          currentImage = moveDownImages.get(0);
        } else if (moveDownCounter < 24) { 
          currentImage = moveDownImages.get(1);
        } else if (moveDownCounter < 36) { 
          currentImage = moveDownImages.get(2);
        } else {
          currentImage = moveDownImages.get(0);
          moveDownCounter = 0;
        }
        moveDownCounter++;
      }
    }
    // Horizontal Direction
    if (getMovement() == HORIZONTAL) {
      if (this.x >= width - 50 || !canMoveRight) {
        moveRightCounter = 0;
        setHorizontalDirection(LEFT);
      } else if (this.x <= 0 || !canMoveLeft) {
        setHorizontalDirection(RIGHT);
        moveLeftCounter = 0;
      }
      // Horizontal movement (speed and animation)
      if (getHorizontalDirection() == LEFT) {
        this.x -= randomSpeed;
        canMoveRight = true;
        if (moveLeftCounter < 12) { 
          currentImage = moveLeftImages.get(0);
        } else if (moveLeftCounter < 24) { 
          currentImage = moveLeftImages.get(1);
        } else if (moveLeftCounter < 36) { 
          currentImage = moveLeftImages.get(2);
        } else {
          currentImage = moveLeftImages.get(0);
          moveLeftCounter = 0;
        }
        moveLeftCounter++;
      } else if (getHorizontalDirection() == RIGHT) {
        this.x += randomSpeed;
        canMoveLeft = true;
        if (moveRightCounter < 12) { 
          currentImage = moveRightImages.get(0);
        } else if (moveRightCounter < 24) { 
          currentImage = moveRightImages.get(1);
        } else if (moveRightCounter < 36) { 
          currentImage = moveRightImages.get(2);
        } else {
          currentImage = moveRightImages.get(0);
          moveRightCounter = 0;
        }
        moveRightCounter++;
      }
    }
  }

  @Override
    float randomSpeedGenerator() {
    return random(0.5, 2);
  }
}
