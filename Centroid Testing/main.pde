float num_points = 5;
Point[] list_points = new Point[(int)num_points];

void setup()
{
  size(500, 500);
  for(int i = 0; i < num_points; ++i)
  {
    list_points[i] = new Point((width/2) + 150 * cos(TWO_PI * ((float)i/num_points)), (width/2) + 150 * sin(TWO_PI * ((float)i/num_points)), 25);
  }
}

void draw()
{
  clear();
  background(255);
  for(int i = 0; i < num_points; ++i)
  {
    stroke(255, 0, 0);
    fill(255, 0, 0);
    circle(list_points[i].x, list_points[i].y, list_points[i].r);
    line(list_points[i].x, list_points[i].y, list_points[(i+1)%(int)num_points].x, list_points[(i+1)%(int)num_points].y);
  }
  
  float avg_x = 0;
  float avg_y = 0;
  
  for(int i = 0; i < num_points; ++i)
  {
    avg_x += list_points[i].x;
    avg_y += list_points[i].y;
  }
  
  avg_x /= num_points;
  avg_y /= num_points;
  
  for(int i = 0; i < num_points; ++i)
  {
    stroke(0, 255, 0);
    fill(0, 255, 0);
    line(list_points[i].x, list_points[i].y, avg_x, avg_y);
  }
  circle(avg_x, avg_y, 25);
  
  int wei_x = (int)(((0.1 * list_points[0].x) + (0.1 * list_points[1].x) + (0.1 * list_points[2].x) + (0.25 * list_points[3].x) + (0.45 * list_points[4].x)));
  int wei_y = (int)(((0.1 * list_points[0].y) + (0.1 * list_points[1].y) + (0.1 * list_points[2].y) + (0.25 * list_points[3].y) + (0.45 * list_points[4].y)));
  stroke(0, 0, 255);
  fill(0, 0, 255);
  circle(wei_x, wei_y, 25);
}

void mouseDragged()
{
  int index = -1;
  for(int i = 0; i < num_points; ++i)
  {
    if( list_points[i].check_click(mouseX, mouseY) )
    {
      index = i;
    }
  }
  
  if(index == -1)
  {
    return;
  }
  
  list_points[index].set_xy(mouseX, mouseY);
}
