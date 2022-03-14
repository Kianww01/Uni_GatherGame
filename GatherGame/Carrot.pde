class Carrot extends Collectible {
  Carrot(float x, float y) {
    super(x, y);
    setScore(2);
    vegetableImage = loadImage("Carrot.png");
  }

  @Override
    void render() {
    image(vegetableImage, getX(), getY());
  }
}
