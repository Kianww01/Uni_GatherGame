class Butterfly extends Enemy {
  Butterfly(float x, float y) {
    super(x, y);
    // Loop for adding all images to arraylists (for animation)
    for (int count = 1; count <= 3; count++) {
      imageLoader = loadImage("Butterfly_Move" + count + ".png");
      moveRightImages.add(imageLoader);
    }
  }

  @Override
    void render() {
    if (moveRightCounter < 6) {
      image(moveRightImages.get(0), this.x, this.y);
    } else if (moveRightCounter < 12) {
      image(moveRightImages.get(1), this.x, this.y);
    } else if (moveRightCounter < 18) {
      image(moveRightImages.get(2), this.x, this.y);
    } else {
      moveRightCounter = 0;
    }
    moveRightCounter++;
  }

  @Override
    void move() {
    int newPosX, newPosY;
    newPosX = player.x + 15;
    newPosY = player.y + 30;

    // Follows the player
    if (newPosX > this.x) {
      this.x += randomSpeed;
    } else if (newPosX < this.x) {
      this.x -= randomSpeed;
    }

    if (newPosY > this.y) {
      this.y += randomSpeed;
    } else if (newPosY < this.y) {
      this.y -= randomSpeed;
    }
  }

  @Override
    float randomSpeedGenerator() {
    return random(0.5, 1);
  }
}
