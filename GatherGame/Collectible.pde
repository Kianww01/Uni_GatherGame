abstract class Collectible {
  private float x;
  private float y;
  private float score;

  PImage vegetableImage;

  // Supered by Cabbage and Carrot class
  Collectible(float x, float y) {
    this.x = x;
    this.y = y;
  }

  // Overridden by Cabbage and Carrot Class
  abstract void render();

  public float getX() {
    return this.x;
  }

  public float getY() {
    return this.y;
  }

  public void setScore(float newValue) {
    this.score = newValue;
  }
}
