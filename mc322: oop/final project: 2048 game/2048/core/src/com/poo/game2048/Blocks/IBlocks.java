package com.poo.game2048.Blocks;

import com.badlogic.gdx.scenes.scene2d.ui.Image;

public interface IBlocks
{
    public Object getId(); // each block has an ID, which can be a String or an Integer
    public Image getImage();
    public boolean getCombined();
    public void setCombined(boolean info);
    public float getPosX();
    public void setPosX(float posX);
    public float getPosY();
    public void setPosY(float posY);
    public float getSize();
    public void setSize(float size);
    
}
