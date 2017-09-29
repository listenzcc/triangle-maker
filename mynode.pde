class mynode
{
  int state;
  float x;
  float y;
  
  mynode(float x, float y)
  {
    this.state = 0;
    this.x = x;
    this.y = y;
  }
  void setnode(int i)
  {
    this.state = i;
  }
  
  boolean cansee(float x, float y, myline block)
  {
    mynode node = new mynode(x, y);
    mynode crossnode = block.crossto(new myline(this, node));
    fill(255);
    crossnode.drawme();
    if (crossnode.equalsto(node) || crossnode.equalsto(this) || crossnode.equalsto(block.n1) || crossnode.equalsto(block.n2))
    {
      // crossnode is one out of four
      return true;
    }
    if (((crossnode.x-block.n1.x)*(crossnode.x-block.n2.x)<=0) && ((crossnode.x-node.x)*(crossnode.x-this.x)<=0) && ((crossnode.y-block.n1.y)*(crossnode.y-block.n2.y)<=0) && ((crossnode.y-node.y)*(crossnode.y-this.y)<=0))
    {
      // crossnode is on block and newline
      return false;
    }
    return true;
  }
  
  boolean cansee(mynode node, myline block)
  {
    return this.cansee(node.x, node.y, block);
  }
  
  boolean equalsto(float x, float y)
  {
    if ((abs(this.x-x)+abs(this.y-y))<1)
    {
      return true;
    }
    return false;
  }
  
  boolean equalsto(mynode node)
  {
    return this.equalsto(node.x, node.y);
  }
  
  void drawme()
  {
    ellipse(this.x, this.y, 5, 5);
  }
  
  void lineto(float x, float y)
  {
    line(this.x, this.y, x, y);
  }
  
}

class myline
{
  mynode n1;
  mynode n2;
  float k, b;
  int specialline;
  
  myline(mynode n1, mynode n2)
  {
    this.n1 = n1;
    this.n2 = n2;
    this.k = (n2.y-n1.y) / (n2.x-n1.x);
    this.b = n1.y - n1.x*(n2.y-n1.y)/(n2.x-n1.x);
    specialline = 0;
    if (n1.x==n2.x) specialline = 1;
    if (n1.y==n2.y) specialline = 2;
  }
  
  mynode crossto(myline line)
  {
    float x, y;
    if (this.specialline==0 && line.specialline==0)
    {
      x = -(line.b-this.b)/(line.k-this.k);
      y = this.k*x + this.b;
      return new mynode(x, y);
    }
    if (this.specialline==0 && line.specialline==1)
    {
      x = line.n1.x;
      y = this.k*x + this.b;
      return new mynode(x, y);
    }
    if (this.specialline==0 && line.specialline==2)
    {
      y = line.n1.y;
      x = (y-this.b)/this.k;
      return new mynode(x, y);
    }
    if (line.specialline==0 && this.specialline==1)
    {
      x = this.n1.x;
      y = line.k*x + line.b;
      return new mynode(x, y);
    }
    if (line.specialline==0 && this.specialline==2)
    {
      y = this.n1.y;
      x = (y-line.b)/line.k;
      return new mynode(x, y);
    }
    if (this.specialline==1 && line.specialline==1)
    {
      if (this.n1.x==line.n1.x) return this.n1;
    }
    if (this.specialline==2 && line.specialline==2)
    {
      if (this.n1.y==line.n1.y) return this.n1;
    }
    return new mynode(-16498189, -84196198);
  }
  
  boolean contain(float x, float y)
  {
    if (this.n1.equalsto(x, y)) return true;
    if (this.n2.equalsto(x, y)) return true;
    return false;
  }
  
  boolean contain(mynode node)
  {
    return this.contain(node.x, node.y);
  }
  
  void drawme()
  {
    n1.lineto(n2.x, n2.y);
  }
  
}

class mytria
{
  mynode n1;
  mynode n2;
  mynode n3;
  mynode nm;
  color _color;
  
  mytria(mynode n1, mynode n2, mynode n3)
  {
    this.n1 = n1;
    this.n2 = n2;
    this.n3 = n3;
    this._init();
  }
  
  mytria(mynode n1, myline line)
  {
    this.n1 = n1;
    this.n2 = line.n1;
    this.n3 = line.n2;
    this._init();
  }
  
  void _init()
  {
    this._color = color(0, 0, random(255), 100);
    this.nm = new mynode((this.n1.x+this.n2.x+this.n3.x)/3, (this.n1.y+this.n2.y+this.n3.y)/3);
  }
  
  boolean cover(float x, float y)
  {
    float t1 = ((x-n1.x)/(n2.x-n1.x)-(y-n1.y)/(n2.y-n1.y)) * ((nm.x-n1.x)/(n2.x-n1.x)-(nm.y-n1.y)/(n2.y-n1.y));
    boolean b1 = t1>0;
    float t2 = ((x-n2.x)/(n3.x-n2.x)-(y-n2.y)/(n3.y-n2.y)) * ((nm.x-n2.x)/(n3.x-n2.x)-(nm.y-n2.y)/(n3.y-n2.y));
    boolean b2 = t2>0;
    float t3 = ((x-n3.x)/(n1.x-n3.x)-(y-n3.y)/(n1.y-n3.y)) * ((nm.x-n3.x)/(n1.x-n3.x)-(nm.y-n3.y)/(n1.y-n3.y));
    boolean b3 = t3>0;
    return b1 && b2 && b3;
  }
  
  boolean cover(mynode node)
  {
    return this.cover(node.x, node.y);
  }
  
  boolean contain(float x, float y)
  {
    if (this.n1.equalsto(x, y)) return true;
    if (this.n2.equalsto(x, y)) return true;
    if (this.n3.equalsto(x, y)) return true;
    return false;
  }
  
  boolean contain(mynode node)
  {
    return this.contain(node.x, node.y);
  }
  
  void drawme()
  {
    fill(this._color);
    triangle(this.n1.x, this.n1.y, this.n2.x, this.n2.y, this.n3.x, this.n3.y);
    //fill(0, 0, 255);
    //ellipse(this.nm.x, this.nm.y, 5, 5);
  }
  
}