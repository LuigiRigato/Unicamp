package com.poo.game2048.Screens;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.Input.Keys;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.scenes.scene2d.InputEvent;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.scenes.scene2d.ui.Image;
import com.badlogic.gdx.scenes.scene2d.utils.ClickListener;
import com.poo.game2048.Creator;

public class InstructionScreen extends AbstractScreen
{
    private final Creator creator;
    private Stage stage;
    private Texture txtrBackgr;
    private int page = 1;
    
    public InstructionScreen(final Creator creator)
    {
        this.creator = creator;
        creator.getStage().clear();
        this.stage = creator.getStage();

        createStage();
    }

    public void createStage()
    {
        stage.clear();

        // backgrounds
        if(page == 1)
            txtrBackgr = new Texture(Gdx.files.internal("backgrounds/instructions_1:4.png"));
        else if(page == 2)
            txtrBackgr = new Texture(Gdx.files.internal("backgrounds/instructions_2:4.png"));
        else if(page == 3)
            txtrBackgr = new Texture(Gdx.files.internal("backgrounds/instructions_3:4.png"));
        else if(page == 4)
            txtrBackgr = new Texture(Gdx.files.internal("backgrounds/instructions_4:4.png"));

        Image imgBackgr = new Image(txtrBackgr);
        imgBackgr.setPosition(0, 0);
        imgBackgr.setSize(Gdx.graphics.getWidth(), Gdx.graphics.getHeight());
        stage.addActor(imgBackgr);

        // next page button
        Texture txtrButtonNext = new Texture(Gdx.files.internal("buttons/next.png"));
        Image buttonNext = new Image(txtrButtonNext);
        buttonNext.setPosition((stage.getWidth() / 2) + (stage.getWidth() * 0.01f), stage.getHeight() * 0.1f);
        buttonNext.setSize(stage.getWidth() * 0.11f, stage.getHeight() * 0.11f);
        stage.addActor(buttonNext);

        // previous page button
        Texture txtrButtonAnt = new Texture(Gdx.files.internal("buttons/previous.png"));
        Image buttonAnt = new Image(txtrButtonAnt);
        buttonAnt.setPosition((stage.getWidth() / 2) - (stage.getWidth() * 0.11f) - (stage.getWidth() * 0.01f), stage.getHeight() * 0.1f);
        buttonAnt.setSize(stage.getWidth() * 0.11f, stage.getHeight() * 0.11f);
        stage.addActor(buttonAnt);

        // back button
        Texture txtrButtonBack = new Texture(Gdx.files.internal("buttons/back.png"));
        Image buttonBack = new Image(txtrButtonBack);
        buttonBack.setPosition((stage.getWidth() * 0.05f), stage.getHeight() * 0.85f);
        buttonBack.setSize(stage.getWidth() * 0.1f, stage.getHeight() * 0.1f);
        stage.addActor(buttonBack);
        
        // configuring buttons
        buttonNext.addListener(new ClickListener()
        {
            public void clicked(InputEvent event, float x, float y)
            {
                if(page < 4)
                {
                    page++;
                    createStage();
                }
            }
        });

        buttonAnt.addListener(new ClickListener()
        {
            public void clicked(InputEvent event, float x, float y)
            {
                if(page > 1)
                {
                    page--;
                    createStage();
                }
            }
        });

        buttonBack.addListener(new ClickListener()
        {
            public void clicked(InputEvent event, float x, float y)
            {
                creator.setScreen(new HomeScreen(creator));
            }
        });
    }
    
    @Override
    public void render(float delta)
    {
        if(Gdx.input.isKeyJustPressed(Keys.RIGHT) || Gdx.input.isKeyJustPressed(Keys.D))
            if(page < 4)
            {
                page++;
                createStage();
            }
        else if(Gdx.input.isKeyJustPressed(Keys.LEFT) || Gdx.input.isKeyJustPressed(Keys.A))
            if(page > 1)
            {
                page--;
                createStage();
            }

        Gdx.gl.glClearColor(1, 1, 1, 1);
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
        stage.act();
        stage.draw();
    }
}