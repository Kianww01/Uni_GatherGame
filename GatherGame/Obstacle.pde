abstract class Obstacle {
  private float x;
  private float y;

  PImage obstacleImage;

  // Supered by Rock Class
  Obstacle(float x, float y) {
    this.x = x;
    this.y = y;
  }

  // Overriden by Rock Class
  abstract void render();

  public float getX() {
    return this.x;
  }

  public float getY() {
    return this.y;
  }
}
