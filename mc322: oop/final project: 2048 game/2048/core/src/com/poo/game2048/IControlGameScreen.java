package com.poo.game2048;

public interface IControlGameScreen
{
    public void connectBoard(Board board);
    public void spawnBlock();
    public void transferInput(char direction);
	public boolean getWin();
    public void setWin(boolean win);
}