class mymousenote
{
  int txsz;
  PFont font;
  mymousenote(int sz)
  {
    this.txsz = sz;
    this.font = createFont("FFScala.tff", 16);
  }
  void write(String s)
  {
    textFont(this.font);
    fill(0, 50);
    rect(mouseX, mouseY-this.txsz, textWidth(s)+4, this.txsz);
    fill(255);
    text(s, mouseX+2, mouseY-2);
  }
}