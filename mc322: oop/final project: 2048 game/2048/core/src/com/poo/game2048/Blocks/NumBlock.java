package com.poo.game2048.Blocks;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.scenes.scene2d.ui.Image;

public class NumBlock implements IBlocks
{
	private int id;
    private Image img;
    private boolean combined = false;
    private float posX;
    private float posY;
    private float size;

    public NumBlock(int id)
    {
        setId(id);
    }

    public Object getId()
    {
        return id;
    }

    public void setId(int id)
    {
        this.id = id;
        switch(id)
        {
            case 0:
                setImage(new Image(new Texture(Gdx.files.internal("blocks/empty.png"))));
                break;
            case 1:
                setImage(new Image(new Texture(Gdx.files.internal("blocks/1.png"))));
                break;
            case 2:
                setImage(new Image(new Texture(Gdx.files.internal("blocks/2.png"))));
                break;
            case 4:
                setImage(new Image(new Texture(Gdx.files.internal("blocks/4.png"))));
                break;
            case 8:
                setImage(new Image(new Texture(Gdx.files.internal("blocks/8.png"))));
                break;
            case 16:
                setImage(new Image(new Texture(Gdx.files.internal("blocks/16.png"))));
                break;
            case 32:
                setImage(new Image(new Texture(Gdx.files.internal("blocks/32.png"))));
                break;
            case 64:
                setImage(new Image(new Texture(Gdx.files.internal("blocks/64.png"))));
                break;
            case 128:
                setImage(new Image(new Texture(Gdx.files.internal("blocks/128.png"))));
                break;
            case 256:
                setImage(new Image(new Texture(Gdx.files.internal("blocks/256.png"))));
                break;
            case 512:
                setImage(new Image(new Texture(Gdx.files.internal("blocks/512.png"))));
                break;
            case 1024:
                setImage(new Image(new Texture(Gdx.files.internal("blocks/1024.png"))));
                break;
            case 2048:
                setImage(new Image(new Texture(Gdx.files.internal("blocks/2048.png"))));
                break;
        }
    }

    public void combineDouble()
    {
        setId(id * 2);
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
}
