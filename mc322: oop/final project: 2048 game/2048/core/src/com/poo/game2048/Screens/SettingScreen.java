package com.poo.game2048.Screens;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.OrthographicCamera;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.Batch;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.scenes.scene2d.InputEvent;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.scenes.scene2d.ui.Image;
import com.badlogic.gdx.scenes.scene2d.utils.ClickListener;
import com.badlogic.gdx.utils.ScreenUtils;
import com.poo.game2048.IControlSettingScreen;
import com.poo.game2048.Creator;

public class SettingScreen extends AbstractScreen
{
    private IControlSettingScreen control;
    private Stage stage;
    private SpriteBatch batch;
    private final Creator creator;
    private OrthographicCamera camera;

    private Texture txtrBackgr;
    private Texture txtr4x4;
    private Texture txtr5x5;
    private Texture txtr6x6;
    private Texture txtr7x7;
    private Texture txtrBomb;
    private Texture txtrDel;
    private Texture txtrTime;
    private Texture txtr2x;
    private Texture txtrPlay;
    private Texture txtrButtonMusic;

    public SettingScreen(final Creator creator)
    {
        this.creator = creator;
        control = creator.getControl();
        creator.getStage().clear();
        this.stage = creator.getStage();
        this.batch = creator.getBatch();

        camera = new OrthographicCamera();
		camera.setToOrtho(false, 500, 500);
    
        // textures configuration
        txtrBackgr = new Texture(Gdx.files.internal("backgrounds/settings.png"));

        txtr4x4 = new Texture(Gdx.files.internal("buttons/4x4.png"));
        txtr5x5 = new Texture(Gdx.files.internal("buttons/5x5_unselected.png"));
        txtr6x6 = new Texture(Gdx.files.internal("buttons/6x6_unselected.png"));
        txtr7x7 = new Texture(Gdx.files.internal("buttons/7x7_unselected.png"));

        txtrBomb = new Texture(Gdx.files.internal("blocks/bomb.png"));
        txtrDel = new Texture(Gdx.files.internal("blocks/del.png"));
        txtrTime = new Texture(Gdx.files.internal("blocks/time.png"));
        txtr2x = new Texture(Gdx.files.internal("blocks/2x.png"));

        txtrPlay = new Texture(Gdx.files.internal("buttons/play_2.png"));

        txtrButtonMusic = new Texture(Gdx.files.internal("buttons/music.png"));

        // block buttons
        control.setButtonSelected("bomb", true);
        control.setButtonSelected("del", true);
        control.setButtonSelected("time", true);
        control.setButtonSelected("2x", true);
        control.setButtonSelected("music", true);
    }

    @Override
	public void render(float delta)
    {
		ScreenUtils.clear(0.32f, 0.41f, 0.42f, 1);

		camera.update();

        // conifuring batch
		batch.setProjectionMatrix(camera.combined);
        batch.begin();
        batch.draw(txtrBackgr, 0, 0, camera.viewportWidth, camera.viewportHeight);

        // configuring stage
        createStage(batch, stage);

        batch.end();
	}

    public void createStage(Batch batch, Stage stage)
    {
        // board size buttons
        Image button4x4 = createButton(txtr4x4, 0.13, 0.65, 0.17, 0.17);
        Image button5x5 = createButton(txtr5x5, 0.32, 0.65, 0.17, 0.17);
        Image button6x6 = createButton(txtr6x6, 0.51, 0.65, 0.17, 0.17);
        Image button7x7 = createButton(txtr7x7, 0.70, 0.65, 0.17, 0.17);

        // block buttons
        Image buttonBomb = createButton(txtrBomb, 0.13, 0.32, 0.17, 0.17);
        Image buttonDel = createButton(txtrDel, 0.32, 0.32, 0.17, 0.17);
        Image buttonTime = createButton(txtrTime, 0.51, 0.32, 0.17, 0.17);
        Image button2x = createButton(txtr2x, 0.70, 0.32, 0.17, 0.17);

        // play button
        Image buttonPlay = new Image(txtrPlay);
        buttonPlay.setX(500 / 2 - 0.37f * 500 / 2);
        buttonPlay.setY(0.1f * 500);
        buttonPlay.setWidth((float) (0.37 * 500));
        buttonPlay.setHeight((float) (0.1 * 500));
        buttonPlay.draw(batch, 1);
        stage.addActor(buttonPlay);

        // back button
        Texture txtrButtonBack = new Texture(Gdx.files.internal("buttons/back.png"));
        Image buttonBack = new Image(txtrButtonBack);
        buttonBack.setPosition(stage.getWidth() * 0.05f, stage.getHeight() * 0.85f);
        buttonBack.setSize(stage.getWidth() * 0.1f, stage.getHeight() * 0.1f);
        buttonBack.draw(batch, 1);
        stage.addActor(buttonBack);

        // music button
        Image buttonMusic = new Image(txtrButtonMusic);
        buttonMusic.setPosition(stage.getWidth() * 0.85f, stage.getHeight() * 0.85f);
        buttonMusic.setSize(stage.getWidth() * 0.1f, stage.getHeight() * 0.1f);
        buttonMusic.draw(batch, 1);
        stage.addActor(buttonMusic);

        // configuring buttons
        button4x4.addListener(new ClickListener()
        {
            public void clicked(InputEvent event, float x, float y)
            {
                creator.setSizeBoard(4);
                
                txtr4x4 = new Texture(Gdx.files.internal("buttons/4x4.png"));
                txtr5x5 = new Texture(Gdx.files.internal("buttons/5x5_unselected.png"));
                txtr6x6 = new Texture(Gdx.files.internal("buttons/6x6_unselected.png"));
                txtr7x7 = new Texture(Gdx.files.internal("buttons/7x7_unselected.png"));
            }
        });

        button5x5.addListener(new ClickListener()
        {
            public void clicked(InputEvent event, float x, float y)
            {
                creator.setSizeBoard(5);

                txtr4x4 = new Texture(Gdx.files.internal("buttons/4x4_unselected.png"));
                txtr5x5 = new Texture(Gdx.files.internal("buttons/5x5.png"));
                txtr6x6 = new Texture(Gdx.files.internal("buttons/6x6_unselected.png"));
                txtr7x7 = new Texture(Gdx.files.internal("buttons/7x7_unselected.png"));
            }
        });

        button6x6.addListener(new ClickListener()
        {
            public void clicked(InputEvent event, float x, float y)
            {
                creator.setSizeBoard(6);

                txtr4x4 = new Texture(Gdx.files.internal("buttons/4x4_unselected.png"));
                txtr5x5 = new Texture(Gdx.files.internal("buttons/5x5_unselected.png"));
                txtr6x6 = new Texture(Gdx.files.internal("buttons/6x6.png"));
                txtr7x7 = new Texture(Gdx.files.internal("buttons/7x7_unselected.png"));
            }
        });

        button7x7.addListener(new ClickListener()
        {
            public void clicked(InputEvent event, float x, float y)
            {
                creator.setSizeBoard(7);

                txtr4x4 = new Texture(Gdx.files.internal("buttons/4x4_unselected.png"));
                txtr5x5 = new Texture(Gdx.files.internal("buttons/5x5_unselected.png"));
                txtr6x6 = new Texture(Gdx.files.internal("buttons/6x6_unselected.png"));
                txtr7x7 = new Texture(Gdx.files.internal("buttons/7x7.png"));
            }
        });

        buttonBomb.addListener(new ClickListener()
        {
            public void clicked(InputEvent event, float x, float y)
            {
                if(control.getButtonSelected("bomb"))
                {
                    control.setButtonSelected("bomb", false);;
                    txtrBomb = new Texture(Gdx.files.internal("blocks/bomb_unselected.png"));
                }
                else
                {
                    control.setButtonSelected("bomb", true);;
                    txtrBomb = new Texture(Gdx.files.internal("blocks/bomb.png"));
                }
            }
        });

        buttonDel.addListener(new ClickListener()
        {
            public void clicked(InputEvent event, float x, float y)
            {
                if(control.getButtonSelected("del"))
                {
                    control.setButtonSelected("del", false);;
                    txtrDel = new Texture(Gdx.files.internal("blocks/del_unselected.png"));
                }
                else
                {
                    control.setButtonSelected("del", true);;
                    txtrDel = new Texture(Gdx.files.internal("blocks/del.png"));
                }
            }
        });

        buttonTime.addListener(new ClickListener()
        {
            public void clicked(InputEvent event, float x, float y)
            {
                if(control.getButtonSelected("time"))
                {
                    control.setButtonSelected("time", false);
                    txtrTime = new Texture(Gdx.files.internal("blocks/time_unselected.png"));
                }
                else
                {
                    control.setButtonSelected("time", true);
                    txtrTime = new Texture(Gdx.files.internal("blocks/time.png"));
                }
            }
        });

        button2x.addListener(new ClickListener()
        {
            public void clicked(InputEvent event, float x, float y)
            {
                if(control.getButtonSelected("2x"))
                {
                    control.setButtonSelected("2x", false);
                    txtr2x = new Texture(Gdx.files.internal("blocks/2x_unselected.png"));
                }
                else
                {
                    control.setButtonSelected("2x", true);
                    txtr2x = new Texture(Gdx.files.internal("blocks/2x.png"));
                }
            }
        });

        
        
        buttonMusic.addListener(new ClickListener()
        {
            public void clicked(InputEvent event, float x, float y)
            {
                if(control.getButtonSelected("music"))
                {
                    creator.getMusic().pause();
                    control.setButtonSelected("music", false);
                    txtrButtonMusic = new Texture(Gdx.files.internal("buttons/music_unselected.png"));
                }
                else
                {
                    creator.getMusic().play();
                    control.setButtonSelected("music", true);
                    txtrButtonMusic = new Texture(Gdx.files.internal("buttons/music.png"));
                }
                    

            }
        });

        // back to home screen button
        addConnection(buttonBack, "start");

        // play the game button
        addConnection(buttonPlay, "game");
    }

    private Image createButton(Texture txtr, Double posX, Double posY, Double width, Double height)
    {
        Image button = new Image(txtr);
        button.setX((float) (posX * camera.viewportWidth));
        button.setY((float) (posY * camera.viewportHeight));
        button.setWidth((float) (width * camera.viewportWidth));
        button.setHeight((float) (height * camera.viewportHeight));

        button.draw(batch, 1);
        stage.addActor(button);

        return button;
    }

    private void addConnection(Image button, String screen)
    {
        if(screen.equals("start"))
            button.addListener(new ClickListener()
            {
                public void clicked(InputEvent event, float x, float y) {
                    creator.setScreen(new HomeScreen(creator));
                }
            });
        else if(screen.equals("game"))
            button.addListener(new ClickListener()
            {
                public void clicked(InputEvent event, float x, float y) {
                    creator.setScreen(new GameScreen(creator));
                }
            });
        else if(screen.equals("instructions"))
            button.addListener(new ClickListener()
            {
                public void clicked(InputEvent event, float x, float y) {
                    creator.setScreen(new InstructionScreen(creator));
                }
            });
    }
}