package com.poo.game2048.Blocks;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.scenes.scene2d.ui.Image;

public class DoubleBlock implements IBlocks
{
    private String id = "2x";
    private Texture txtr = new Texture(Gdx.files.internal("blocks/2x.png"));
    private Image img = new Image(txtr);
    private boolean combined = false;
    private float posX;
    private float posY;
    private float size;

    public Object getId()
    {
        return id;
    }
    
    public Texture getTexture()
    {
        return txtr;
    }

    public Image getImage()
    {
        return img;
    }

    public boolean getCombined()
    {
        return combined;
    }

    public void setCombined(boolean info)
    {
        combined = info;
    }

    public float getPosX()
    {
        return posX;
    }

    public void setPosX(float posX)
    {
        this.posX = posX;
        this.getImage().setX(posX);
    }

    public float getPosY()
    {
        return posY;
    }

    public void setPosY(float posY)
    {
        this.posY = posY;
        this.getImage().setY(posY);
    }

    public float getSize()
    {
        return size;
    }

    public void setSize(float size)
    {
        this.size = size;
        this.getImage().setWidth(size);
        this.getImage().setHeight(size);
    }
}