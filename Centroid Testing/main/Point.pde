class Point
{
  public float x;
  public float y;
  public float r;
  
  Point(float a, float b, float c)
  {
    x = a;
    y = b;
    r = c;
  }
  
  boolean check_click(float m_x, float m_y)
  {
    return ( pow(m_x - x, 2) + pow(m_y - y, 2) <= pow(r, 2) );
  }
  
  void set_xy(float a, float b)
  {
    x = a;
    y = b;
  }
}
