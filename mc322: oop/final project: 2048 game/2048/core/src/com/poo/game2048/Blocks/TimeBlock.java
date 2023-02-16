package com.poo.game2048.Blocks;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.scenes.scene2d.ui.Image;

public class TimeBlock implements ILifeBlocks
{
    private static ILifeBlocks instance;
    private String id = "time";
    private Texture txtr = new Texture(Gdx.files.internal("blocks/time.png"));
    private Image img = new Image(txtr);
    private boolean combined = false;
    private float posX;
    private float posY;
    private float size;
    private int life = 4;
    private int vert;
    private int hori;
    private boolean activated = false;
    
    

    // to implement the singleton design pattern, a private constructor is needed
    private TimeBlock() {}
    
    // implementation of the singleton design pattern, ensuring that only one time instance exists
    public static ILifeBlocks getInstance()
    {
        if (instance == null)
            instance = new TimeBlock();

        return instance;
    }
    
    public Object getId()
    {
        return id;
    }

    public Texture getTexture()
    {
        return txtr;
    }

    public void setTexture(Texture txtr)
    {
        this.txtr = txtr;
    }

    public boolean getCombined()
    {
        return combined;
    }

    public void setCombined(boolean info)
    {
        combined = info;
    }

    public Image getImage()
    {
        return img;
    }

    public void setImage(Image img)
    {
        this.img = img;
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

    // the time block has 4 lives until it dissapears
    public int getLife()
    {
        return life;
    }

    public void setLife(int addition)
    {
        life += addition;
    }

    public int getVertical()
    {
        return vert;
    }

    public void setVertical(int vert)
    {
        this.vert = vert;
    }

    public int getHorizontal()
    {
        return hori;
    }

    public void setHorizontal(int hori)
    {
        this.hori = hori;
    }

    // the time block can be actived (participating in the board) or not (waiting to return)
    public boolean getActivated()
    {
        return activated;
    }

    public void setActivated(boolean info)
    {
        activated = info;
    }


    // after the time block explodes, its attributes are renewed
    public void reset()
    {
        life = 4;
        activated = false;
        img = new Image(new Texture(Gdx.files.internal("blocks/time.png")));
    }
}
