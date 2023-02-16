package com.poo.game2048.Screens;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.scenes.scene2d.InputEvent;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.scenes.scene2d.ui.Image;
import com.badlogic.gdx.scenes.scene2d.utils.ClickListener;
import com.badlogic.gdx.utils.ScreenUtils;
import com.poo.game2048.Creator;
import com.badlogic.gdx.graphics.OrthographicCamera;


public class HomeScreen extends AbstractScreen
{
    private final Creator creator;
    private Stage stage;
    private SpriteBatch batch;

    private OrthographicCamera camera;

    private Texture txtrBackgr;
    private Texture txtrPlay;
    private float xButtonPlay;
    private float yButtonPlay;
    private Texture txtrButtonInstruct;
    private float xButtonInstruct;
    private float yButtonInstruct;

    public HomeScreen(final Creator creator)
    {
        this.creator = creator;
        creator.getStage().clear();
        this.stage = creator.getStage();
        this.batch = creator.getBatch();

        camera = new OrthographicCamera();
		camera.setToOrtho(false, 500, 500);
    
        txtrBackgr = new Texture(Gdx.files.internal("backgrounds/start.png"));

        txtrPlay = new Texture(Gdx.files.internal("buttons/play_1.png"));
        xButtonPlay = (stage.getWidth() / 2) - (stage.getWidth() * 0.5f / 2);
        yButtonPlay = stage.getHeight() * 0.44f;

        txtrButtonInstruct = new Texture(Gdx.files.internal("buttons/instructions.png"));
        xButtonInstruct = (stage.getWidth() / 2) - (stage.getWidth() * 0.5f / 2);
        yButtonInstruct = stage.getHeight() * 0.27f;

    }

    @Override
	public void render(float delta)
    {
		ScreenUtils.clear(0.32f, 0.41f, 0.42f, 1);

		camera.update();
		batch.setProjectionMatrix(camera.combined);

        // configuring batch
		batch.begin();
        
        batch.draw(txtrBackgr, 0, 0, 500, 500);
        batch.draw(txtrPlay, xButtonPlay, yButtonPlay, stage.getWidth() * 0.5f, stage.getHeight() * 0.1f);
        batch.draw(txtrButtonInstruct, xButtonInstruct, yButtonInstruct, stage.getWidth() * 0.5f, stage.getHeight() * 0.1f);

        // configuring stage
        createStage();

		batch.end();
	}

    public void createStage()
    {
        // settings button
        Image buttonSetting = new Image(txtrPlay);
        buttonSetting.setPosition(xButtonPlay, yButtonPlay);
        buttonSetting.setSize(stage.getWidth() * 0.5f, stage.getHeight() * 0.1f);
        stage.addActor(buttonSetting);

        // instructions button
        Image buttonInstruct = new Image(txtrButtonInstruct);
        buttonInstruct.setPosition(xButtonInstruct, yButtonInstruct);
        buttonInstruct.setSize(stage.getWidth() * 0.5f, stage.getHeight() * 0.1f);
        stage.addActor(buttonInstruct);

        // configuring buttons
        buttonSetting.addListener(new ClickListener()
        {
            public void clicked(InputEvent event, float x, float y)
            {
                creator.setScreen(new SettingScreen(creator));
            }
        });
        buttonInstruct.addListener(new ClickListener()
        {
            public void clicked(InputEvent event, float x, float y)
            {
                creator.setScreen(new InstructionScreen(creator));
            }
        });
    }

    @Override
	public void dispose()
    {
		txtrBackgr.dispose();
		txtrPlay.dispose();
		txtrButtonInstruct.dispose();
	}

}