package com.poo.game2048.Blocks;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.scenes.scene2d.ui.Image;

public class BombBlock implements ILifeBlocks
{
    private static ILifeBlocks instance;
    private String id = "bomb";
    private Texture txtr = new Texture(Gdx.files.internal("blocks/bomb.png"));
    private Image img = new Image(txtr);
    private boolean combined = false;
    private float posX;
    private float posY;
    private float size;
    private int life = 3;
    private int vert;
    private int hori;
    private boolean activated = false;
    

    // to implement the singleton design pattern a private constructor is needed
    private BombBlock() {}
    
    // implementation of the singleton design pattern, ensuring that only one bomb instance exists
    public static ILifeBlocks getInstance()
    {
        if (instance == null)
            instance = new BombBlock();
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

    // the bomb has 3 lives until it explodes
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

    // the bomb can be actived (participating in the board) or not (waiting to return)
    public boolean getActivated()
    {
        return activated;
    }

    public void setActivated(boolean info)
    {
        activated = info;
    }

    // after the bomb explodes, its attributes are renewed
    public void reset()
    {
        setLife(3);
        setActivated(false);
        img = new Image(new Texture(Gdx.files.internal("blocks/bomb.png")));
    }
}