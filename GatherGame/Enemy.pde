abstract class Enemy {
  float x;
  float y;

  // Constants for directions enemies can move in
  final int VERTICAL = 0;
  final int HORIZONTAL = 1;

  final int UP = 0;
  final int DOWN = 1;

  final int LEFT = 0;
  final int RIGHT = 1;

  private int movement;
  private int verticalDirection;
  private int horizontalDirection;

  private boolean initialMovementSet = false;

  boolean canMoveUp = true;
  boolean canMoveDown = true;
  boolean canMoveLeft = true;
  boolean canMoveRight = true;

  int moveRightCounter = 0;
  int moveLeftCounter = 0;
  int moveUpCounter = 0;
  int moveDownCounter = 0;

  PImage currentImage;
  PImage imageLoader;

  float randomSpeed;

  ArrayList<PImage> moveRightImages = new ArrayList();
  ArrayList<PImage> moveLeftImages = new ArrayList();
  ArrayList<PImage> moveDownImages = new ArrayList();
  ArrayList<PImage> moveUpImages = new ArrayList();

  // Supered by Fox and Butterfly Class
  Enemy(float x, float y) {
    this.x = x;
    this.y = y;

    // Randomly selects what directions the enemy will move
    int randomMovement = (int) random(1, 3);

    if (randomMovement == 1) {
      this.movement = VERTICAL;
    } else if (randomMovement == 2) {
      this.movement = HORIZONTAL;
    }

    randomSpeed = randomSpeedGenerator();
  }

  void update() {
    render();
    move();

    // Used to change enemies direction if they collide with an obstacle
    for (int i = 0; i < obstacleList.size(); i++) {
      Obstacle currentObstacle = obstacleList.get(i);  

      int canMove = this.obstacleCrash(currentObstacle);

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
  }

  // Checks if enemy is colliding with obstacle and needs to turn around
  int obstacleCrash(Obstacle obstacle) {
    if (dist(this.x + 15, this.y, obstacle.x + 30, obstacle.y + 30) < 30) {
      return 1;
    } else if (dist(this.x + 15, this.y + 65, obstacle.x + 30, obstacle.y + 30) < 30) {
      return 2;
    } else if (dist(this.x, this.y + 22.5, obstacle.x + 30, obstacle.y + 30) < 30) {
      return 3;
    } else if (dist(this.x + 45, this.y + 22.5, obstacle.x + 30, obstacle.y + 30) < 30) {
      return 4;
    } else {
      return 0;
    }
  }

  abstract float randomSpeedGenerator();

  // Overriden by Fox and Butterfly Class
  abstract void render();
  // Overriden by Fox and Butterfly Class
  abstract void move();

  public int getMovement() {
    return this.movement;
  }

  public int getVerticalDirection() {
    return this.verticalDirection;
  }

  public void setVerticalDirection(int newValue) {
    this.verticalDirection = newValue;
  }

  public int getHorizontalDirection() {
    return this.horizontalDirection;
  }

  public void setHorizontalDirection(int newValue) {
    this.horizontalDirection = newValue;
  }

  public boolean getInitialMovementSet() {
    return this.initialMovementSet;
  }

  public void setInitialMovementSet(boolean newValue) {
    this.initialMovementSet =  newValue;
  }
}
