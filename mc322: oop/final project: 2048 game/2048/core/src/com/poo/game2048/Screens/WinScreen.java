package com.poo.game2048.Screens;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.scenes.scene2d.InputEvent;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.scenes.scene2d.actions.MoveToAction;
import com.badlogic.gdx.scenes.scene2d.ui.Image;
import com.badlogic.gdx.scenes.scene2d.utils.ClickListener;
import com.poo.game2048.Creator;

public class WinScreen extends AbstractScreen
{
    private final Creator creator;
    private Stage stage;

    public WinScreen(final Creator creator)
    {
        this.creator = creator;
        this.stage = creator.getStage();

        // stage setup
        stage.clear();
        createStage();
    }

    public void createStage()
    {
        // background
        Texture txtrBackgr = new Texture(Gdx.files.internal("backgrounds/win.png"));
        Image imgBackgr = new Image(txtrBackgr);
        imgBackgr.setPosition(0, 0);
        imgBackgr.setSize(Gdx.graphics.getWidth(), Gdx.graphics.getHeight());
        stage.addActor(imgBackgr);

        // confetti
        Texture txtrConfetti = new Texture(Gdx.files.internal("extras/confetti.png"));
        Image imgConfetti = new Image(txtrConfetti);
        imgConfetti.setPosition(Gdx.graphics.getWidth() * 0.055f, Gdx.graphics.getHeight());
        imgConfetti.setSize(Gdx.graphics.getWidth() * 0.9f, Gdx.graphics.getHeight() * 0.95f);
        imgConfetti.setOrigin(Gdx.graphics.getWidth() * 0.055f, Gdx.graphics.getHeight());
        stage.addActor(imgConfetti);

        MoveToAction moveDown = new MoveToAction();
        moveDown.setPosition(Gdx.graphics.getWidth() * 0.055f, -Gdx.graphics.getHeight());
        moveDown.setDuration(7.5f);

        imgConfetti.addAction(moveDown);

        // menu button
        Texture txtrButtonMenu = new Texture(Gdx.files.internal("buttons/menu.png"));
        Image buttonMenu = new Image(txtrButtonMenu);
        buttonMenu.setPosition((stage.getWidth() / 2) - (stage.getWidth() * 0.5f / 2), stage.getHeight() * 0.35f);
        buttonMenu.setSize((float) (stage.getWidth() * 0.5), (float) (stage.getHeight() * 0.1));
        stage.addActor(buttonMenu);

        // close button
        Texture txtrButtonClose = new Texture(Gdx.files.internal("buttons/close.png"));
        Image buttonClose = new Image(txtrButtonClose);
        buttonClose.setPosition((stage.getWidth() / 2) - (stage.getWidth() * 0.5f / 2), stage.getHeight() * 0.2f);
        buttonClose.setSize((float) (stage.getWidth() * 0.5), (float) (stage.getHeight() * 0.1));
        stage.addActor(buttonClose);

        
        // configuring buttons
        buttonMenu.addListener(new ClickListener()
        {
            public void clicked(InputEvent event, float x, float y)
            {
                creator.setScreen(new HomeScreen(creator));
            }
        });

        buttonClose.addListener(new ClickListener()
        {
            public void clicked(InputEvent event, float x, float y)
            {
                System.exit(0);
            }
        });
    }
    
    @Override
    public void render(float delta)
    {
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
        stage.act();
        stage.draw();
    }
}
