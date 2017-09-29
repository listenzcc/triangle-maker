mymousenote mmn;

ArrayList<mynode> list_node; 
ArrayList<myline> list_line;
ArrayList<mytria> list_tria;
float x;
float y;
void setup()
{
  size(800, 400);
  mmn = new mymousenote(16);
  list_node = new ArrayList<mynode>();
  list_line = new ArrayList<myline>();
  list_tria = new ArrayList<mytria>();
  background(255);
  smooth();
}

void draw()
{
  background(127);
  x = mouseX;
  y = mouseY;
  noStroke();
  mmn.write((int)x+", "+(int)y);
  
  fill(0);
  noStroke();
  ellipse(x, y, 10, 10);
  
  showdynamic();
  drawnodes();
  drawlines();
  drawtrias();
  
  smooth();
}

void showdynamic()
{
  boolean drawme;
  for (mynode node : list_node)
  {
    myline line = new myline(new mynode(x, y), node);
    drawme = true;
    for (myline block : list_line)
    {
      if (block.contain(node) || block.contain(x, y)) continue;
      if (!node.cansee(x, y, block))
      {
        drawme = false;
        break;
      }
    }
    if (drawme)
    {
      stroke(255);
      line.drawme();
    }
  }
}

void drawnodes()
{
  for (mynode node : list_node)
  {
    fill(0);
    noStroke();
    node.drawme();
  }
}

void drawlines()
{
  for (myline line : list_line)
  {
    stroke(0);
    line.drawme();
  }
}

void drawtrias()
{
  for (mytria tria : list_tria)
  {
    noStroke();
    fill(255, 0, 0, 100);
    tria.drawme();
  }
}

void mouseClicked()
{
  // click on node
  mynode node = new mynode(x, y);
  
  // if the node exists, do nothing and return
  for (mynode n : list_node)
  {
    if (n.equalsto(node)) return;
  }
  
  // when the program begins, no node at all
  if (list_node.size()==0)
  {
    // add the new node, and return
    list_node.add(node);
    return;
  }
  
  // when the program begins, no line at all
  if (list_line.size()==0)
  {
    // add the new node, add a new line, and return
    list_node.add(node);
    list_line.add(new myline(list_node.get(1), list_node.get(0)));
    return;
  }
  
  // program runs, update lines and triangles when add new node
  // when inside triangles
  // test all triangles
  mytria tria;
  for (int i=0; i<list_tria.size(); i++)
  {
    tria = list_tria.get(i);
    if (tria.cover(node))
    {
      // when inside a triangle
      // remove the triangle
      list_tria.remove(i);
      // add three lines
      list_line.add(new myline(node, tria.n1));
      list_line.add(new myline(node, tria.n2));
      list_line.add(new myline(node, tria.n3));
      // add three new triangles
      list_tria.add(new mytria(node, tria.n1, tria.n2));
      list_tria.add(new mytria(node, tria.n2, tria.n3));
      list_tria.add(new mytria(node, tria.n3, tria.n1));
      // add the new node and return
      list_node.add(node);
      return;
    }
  }
  
  // when not inside any triangles
  int sz = list_line.size();
  myline line;
  myline block;
  boolean isgoodline;
  // build new lines and triangles as much as i can
  for (int i=0; i<sz; i++)
  {
    line = list_line.get(i);
    isgoodline = true;
    for (int j=0; j<sz; j++)
    {
      block = list_line.get(j);
      if (block.contain(node) || (block.contain(line.n1) && block.contain(line.n2))) continue;
      if (line.n1.cansee(node, block) && line.n2.cansee(node, block))
      {
        // is still good line
      }
      else
      {
        isgoodline = false;
        break;
      }
    }
    if (isgoodline)
    {
      list_line.add(new myline(node, line.n1));
      list_line.add(new myline(node, line.n2));
      list_tria.add(new mytria(node, line));
    }
  }
  
  // add the new node
  list_node.add(node);
   //<>//
}