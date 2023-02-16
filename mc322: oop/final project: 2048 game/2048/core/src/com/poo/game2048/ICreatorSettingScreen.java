package com.poo.game2048;

import com.badlogic.gdx.Screen;
import com.badlogic.gdx.audio.Music;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.scenes.scene2d.Stage;

public interface ICreatorSettingScreen
{
    public Control getControl();
    public SpriteBatch getBatch();
    public Stage getStage();
    public void setSizeBoard(int sizeBoard);
    public void setScreen(Screen screen);
    public Music getMusic();
}