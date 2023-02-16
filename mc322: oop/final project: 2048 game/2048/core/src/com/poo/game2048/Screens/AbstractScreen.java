package com.poo.game2048.Screens;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.Screen;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.OrthographicCamera;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.utils.viewport.StretchViewport;

public abstract class AbstractScreen extends Stage implements Screen
{
    protected AbstractScreen()
    {
        super(new StretchViewport(400f, 400f, new OrthographicCamera()));
    }
    
    @Override
    public void render(float delta)
    {
        // clear screen
        Gdx.gl.glClearColor(0.32f, 0.41f, 0.42f, 1);
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);

        // Calling to Stage methods
        super.act(delta);
        super.draw();
    }
    
    @Override
    public void resize(int width, int height)
    {
        getViewport().update(width, height, true);
    }

	@Override
	public void show() {}

	@Override
	public void hide() {}

    @Override
	public void pause() {}

	@Override
	public void resume() {}

}
