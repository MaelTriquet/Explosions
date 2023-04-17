class Cell {
  ArrayList<Integer> content = new ArrayList<Integer>();
  int index;

  Cell(int index_) {
    index = index_;
  }

  ArrayList<Cell> neighbours() {
    ArrayList<Cell> neighbours = new ArrayList<Cell>();
    neighbours.add(this);

    if (index % widthCell != 0) {
      neighbours.add(cells[index - 1]);
      if (index / widthCell != 0) {
        neighbours.add(cells[index - widthCell - 1]);
      }
      if (index / widthCell != heightCell - 1) {
        neighbours.add(cells[index + widthCell - 1]);
      }
    }

    if (index % widthCell != widthCell - 1) {
      neighbours.add(cells[index + 1]);
      if (index / widthCell != 0) {
        neighbours.add(cells[index - widthCell + 1]);
      }
      if (index / widthCell != heightCell - 1) {
        neighbours.add(cells[index + widthCell + 1]);
      }
    }

    if (index / widthCell != 0) {
      neighbours.add(cells[index - widthCell]);
    }
    if (index / widthCell != heightCell - 1) {
      neighbours.add(cells[index + widthCell]);
    }

    return neighbours;
  }

  void clean() {
    content.clear();
  }

  void collide(Cell other) {
    for (int i : content) {
      for (int j : other.content) {
        balls.get(i).collide(balls.get(j));
        balls.get(i).pressure++;
        balls.get(j).pressure++;
      }
    }
  }
}

void updateCells() {
  for (Cell c : cells) {
    c.clean();
  }
  for (Ball b : balls) {
    if (b.pos.x > 0 && b.pos.x < width && b.pos.y > 0 && b.pos.y < height) {
      cells[((int)b.pos.x) / maxRadius + ((int)b.pos.y) / maxRadius * widthCell].content.add(b.index);
    }
  }
}
