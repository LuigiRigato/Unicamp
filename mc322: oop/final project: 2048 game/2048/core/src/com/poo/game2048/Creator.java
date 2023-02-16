package com.poo.game2048;

import com.badlogic.gdx.Game;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.audio.Music;
import com.badlogic.gdx.graphics.OrthographicCamera;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.utils.viewport.StretchViewport;
import com.poo.game2048.Screens.HomeScreen;


public class Creator extends Game implements ICreatorSettingScreen
{
	private OrthographicCamera camera;
	private SpriteBatch batch;
	private Stage stage;
	private int sizeBoard = 4;
	private Control control;
	private Music music;

	@Override
	public void create()
	{
		// camera, batch and stage setup
		camera = new OrthographicCamera();
		camera.setToOrtho(false, 500, 500);
		batch = new SpriteBatch();
		stage = new Stage(new StretchViewport(camera.viewportWidth, camera.viewportHeight));
		Gdx.input.setInputProcessor(stage);

		// control setup
		control = new Control(this);

		// music setp
		music = Gdx.audio.newMusic(Gdx.files.internal("songs/Corona-320bit.mp3"));
		/* 
		Corona by Alexander Nakarada | https://www.serpentsoundstudios.com
		Music promoted by https://www.chosic.com/free-music/all/
		Attribution 4.0 International (CC BY 4.0)
		https://creativecommons.org/licenses/by/4.0/ 
		*/
		music.setLooping(true);
		music.play();
 
		// defining the first screen
		this.setScreen(new HomeScreen(this));
	}

	public SpriteBatch getBatch()
	{
		return batch;
	}

	public Stage getStage()
	{
		return stage;
	}

	public void setSizeBoard(int sizeBoard)
	{
		this.sizeBoard = sizeBoard;
	}

	public int getSizeBoard()
	{
		return sizeBoard;
	}

	public Control getControl()
	{
		return control;
	}

	public Music getMusic()
	{
		return music;
	}
}
