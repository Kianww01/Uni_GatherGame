class Cabbage extends Collectible {
  Cabbage(float x, float y) {
    super(x, y);
    setScore(1);
    vegetableImage = loadImage("Cabbage.png");
  }

  @Override
    void render() {
    image(vegetableImage, getX(), getY());
  }
}
