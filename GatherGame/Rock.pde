class Rock extends Obstacle {
  Rock(float x, float y) {
    super(x, y);
    obstacleImage = loadImage("Rock_Pile.png");
  }

  @Override
    void render() {
    image(obstacleImage, getX(), getY());
  }

}
