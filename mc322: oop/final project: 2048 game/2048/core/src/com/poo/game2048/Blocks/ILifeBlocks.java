package com.poo.game2048.Blocks;

import com.badlogic.gdx.scenes.scene2d.ui.Image;

public interface ILifeBlocks extends IBlocks
{
    public void setImage(Image img);
    public int getLife();
    public void setLife(int addition);
    public boolean getActivated();
    public void setActivated(boolean info);
    public int getVertical();
    public void setVertical(int vert);
    public int getHorizontal();
    public void setHorizontal(int hori);
    public void reset();
}
