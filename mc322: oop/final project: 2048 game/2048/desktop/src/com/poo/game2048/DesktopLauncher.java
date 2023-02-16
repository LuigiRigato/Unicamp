package com.poo.game2048;

import com.badlogic.gdx.backends.lwjgl3.Lwjgl3Application;
import com.badlogic.gdx.backends.lwjgl3.Lwjgl3ApplicationConfiguration;

public class DesktopLauncher {
	public static void main (String[] arg) {
		Lwjgl3ApplicationConfiguration config = new Lwjgl3ApplicationConfiguration();
		config.setTitle("2048");
		config.setWindowedMode(500, 500);
		config.setResizable(true);
		new Lwjgl3Application(new Creator(), config);
	}
}