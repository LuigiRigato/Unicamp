package com.poo.game2048;

import java.util.Objects;
import java.util.Random;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.math.Interpolation;
import com.badlogic.gdx.scenes.scene2d.actions.Actions;
import com.badlogic.gdx.scenes.scene2d.actions.MoveToAction;
import com.badlogic.gdx.scenes.scene2d.actions.SequenceAction;
import com.badlogic.gdx.scenes.scene2d.ui.Image;
import com.poo.game2048.Blocks.*;
import com.poo.game2048.Screens.LooseScreen;

public class Control implements IControlGameScreen, IControlSettingScreen
{
    private final Creator creator;
    private IBoardControl board;

    private boolean buttonBombSelected;
    private boolean buttonDelSelected;
    private boolean buttonTimeSelected;
    private boolean button2xSelected;
    private boolean buttonMusicSelected;

    private ILifeBlocks timer, bomb;

    private int vertEnd = 0;
    private int horiEnd = 0;
    private float vertPosEnd;
    private float horiPosEnd;

    private boolean nonExistentVoid;
    private boolean smthChanged;

    private boolean win = false;

    public Control(final Creator creator)
    {
        this.creator = creator;
        bomb = BombBlock.getInstance();
        timer = TimeBlock.getInstance();
    }

    // Adds a block from [1, 2, 4 or specials] on an empty position on the board
    public void spawnBlock()
    {
        IBlocks blockSpawned = new NumBlock(0);
        Random random = new Random();
        int vert = random.nextInt(board.getSize());
		int hori = random.nextInt(board.getSize());

        // probability of each block to be spawned
		if (Objects.equals(board.getId(vert, hori), 0))
		{
			int index = random.nextInt(100);
            if(index < 35)
                blockSpawned = new NumBlock(1);
            else if (index < 60)
                blockSpawned = new NumBlock(2);
            else if (index < 80)
                blockSpawned = new NumBlock(4);
            else if (index < 85 && bomb.getActivated() == false && getButtonSelected("bomb"))
            {
                blockSpawned = bomb;
                
                bomb.setActivated(true);
                bomb.setVertical(vert);
                bomb.setHorizontal(hori);
            }
            else if (index < 90 && timer.getActivated() == false && getButtonSelected("time"))
            {
                blockSpawned = timer;

                timer.setActivated(true);
                timer.setVertical(vert);
                timer.setHorizontal(hori);
            }
            else if (index < 95 && getButtonSelected("del"))
                blockSpawned = new DelBlock();
            else if (index < 100 && getButtonSelected("2x"))
                blockSpawned = new DoubleBlock();
            else
                spawnBlock();
            
            board.setBlock(vert, hori, blockSpawned);
            board.getBlock(vert, hori).getImage().setScale(.75f);
			board.getBlock(vert, hori).getImage().addAction(Actions.scaleTo(1, 1, .25f));
		}
		else
			spawnBlock();
    }

    public void transferInput(char direction)
	{   
		if(direction == 'w')
            for(int vert = 0; vert < board.getSize(); vert++)
                for(int hori = board.getSize() - 1; hori >= 0; hori--)
                    checkViability(direction, vert, hori);
        else if(direction == 's')
            for(int vert = 0; vert < board.getSize(); vert++)
                for(int hori = 0; hori < board.getSize(); hori++)
                    checkViability(direction, vert, hori);
        else if(direction == 'a')
            for(int hori = 0; hori < board.getSize(); hori++)
                for(int vert = 0; vert < board.getSize(); vert++)
                    checkViability(direction, vert, hori);
        else if(direction == 'd')
            for(int hori = 0; hori < board.getSize(); hori++)
                for(int vert = board.getSize() - 1; vert >= 0; vert--)
                    checkViability(direction, vert, hori);
        
        checkWholeBoard();
        if(smthChanged)
        {
            updateLifes();
            spawnBlock();
            smthChanged = false;
        }
	}

    private void checkViability(char direction, int vertIni, int horiIni)
    {
        // if it is not a void and it has not combined yet
        if(!Objects.equals(board.getId(vertIni, horiIni), 0) && !board.getBlock(vertIni, horiIni).getCombined())
            interpretInput(direction, vertIni, horiIni);
    }

    private void interpretInput(char direction, int vertIni, int horiIni)
    {
        planMove(direction, vertIni, horiIni);

        // if it fits inside the board
        if(0 <= vertEnd && vertEnd < board.getSize() && 0 <= horiEnd && horiEnd < board.getSize())
            // if the destination block has not been combined yet
            if (!board.getBlock(vertEnd, horiEnd).getCombined() && (vertIni != vertEnd || horiIni != horiEnd))
            {
                // if the initial block is a life block and the destination block is from [void, del or 2x]
                if(board.getBlock(vertIni, horiIni) instanceof ILifeBlocks && 
                (Objects.equals(board.getId(vertEnd, horiEnd), 0) || 
                Objects.equals(board.getId(vertEnd, horiEnd), "del") || 
                Objects.equals(board.getId(vertEnd, horiEnd), "2x")))
                {
                    // then the destination blocks have no effect, they just vanish
                    ((ILifeBlocks) board.getBlock(vertIni, horiIni)).setVertical(vertEnd);
                    ((ILifeBlocks) board.getBlock(vertIni, horiIni)).setHorizontal(horiEnd);
                }
                move(direction, vertIni, horiIni);
            }
    }

    private void planMove(char direction, int vertIni, int horiIni)
    {
        switch (direction)
        {
            case 'w':
                vertEnd = vertIni;
                horiEnd = horiIni + 1;
                break;
            case 'a':
                vertEnd = vertIni - 1;
                horiEnd = horiIni;
                break;
            case 's':
                vertEnd = vertIni;
                horiEnd = horiIni - 1;
                break;
            case 'd':
                vertEnd = vertIni + 1;
                horiEnd = horiIni;
                break;
        }

        if (vertEnd < 0)
            vertEnd = 0;
        else if (vertEnd == board.getSize())
            vertEnd = board.getSize() - 1;
        if (horiEnd < 0)
            horiEnd = 0;
        else if (horiEnd == board.getSize())
            horiEnd = board.getSize() - 1;
    }

    private float calculatePosition(int coord)
    {
        return ((500 * 0.05f) + (500 * 0.87f / board.getSize()) * coord + (500 * 0.01f) * coord);
    }

    private void move(char direction, int vertIni, int horiIni)
    {
        // animation
        vertPosEnd = calculatePosition(vertIni);
        horiPosEnd = calculatePosition(horiIni);
        MoveToAction combineBlock = new MoveToAction();
        combineBlock.setPosition(vertPosEnd,horiPosEnd);
        combineBlock.setDuration(0.25f);
        combineBlock.setInterpolation(Interpolation.smooth);
        SequenceAction animateBlock = new SequenceAction(combineBlock, Actions.removeActor());

        // when the destionation block is void, the initial block must keep moving
        if(Objects.equals(board.getId(vertEnd, horiEnd), 0))
        {
            board.setBlock(vertEnd, horiEnd, board.getBlock(vertIni, horiIni));
            board.getBlock(vertIni, horiIni).getImage().addAction(animateBlock);
            board.setBlock(vertIni, horiIni, new NumBlock(0));
            interpretInput(direction, vertEnd, horiEnd);
            smthChanged = true;
        }

        // when both blocks are the same, they combine
        else if(Objects.equals(board.getId(vertEnd, horiEnd), board.getId(vertIni, horiIni)))
        {
            board.getBlock(vertEnd, horiEnd).getImage().addAction(Actions.removeActor());

            // when they are number blocks, they double their value
            if(board.getBlock(vertEnd, horiEnd) instanceof NumBlock)
                ((NumBlock) board.getBlock(vertEnd, horiEnd)).combineDouble();

            board.getBlock(vertIni, horiIni).getImage().addAction(animateBlock);
            board.setBlock(vertIni, horiIni, new NumBlock(0));
            board.getBlock(vertEnd, horiEnd).setCombined(true);
            smthChanged = true;
        }

        // the del block deletes others when it is on the initial or final position
        else if(Objects.equals(board.getId(vertEnd, horiEnd), "del") || Objects.equals(board.getId(vertIni, horiIni), "del"))
        {
            board.getBlock(vertIni, horiIni).getImage().addAction(animateBlock);
            if (Objects.equals(board.getId(vertEnd, horiEnd), "bomb") || Objects.equals(board.getId(vertIni, horiIni), "bomb"))
            {
                bomb.reset();
            }
            else if (Objects.equals(board.getId(vertEnd, horiEnd), "time") || Objects.equals(board.getId(vertIni, horiIni), "time"))
            {
                timer.reset();
            }
            
            board.setBlock(vertIni, horiIni, new NumBlock(0));
            board.getBlock(vertEnd, horiEnd).getImage().addAction(Actions.removeActor());
            board.setBlock(vertEnd, horiEnd, new NumBlock(0));
            smthChanged = true;
        }

        // when the 2x block is on the destination, it doubles the value of the initial block 
        else if(Objects.equals(board.getId(vertEnd, horiEnd), "2x"))
        {
            board.getBlock(vertIni, horiIni).getImage().addAction(animateBlock);
            if(board.getBlock(vertIni, horiIni) instanceof NumBlock)
                ((NumBlock) board.getBlock(vertIni, horiIni)).combineDouble();
            board.getBlock(vertEnd, horiEnd).getImage().addAction(Actions.removeActor());
            board.setBlock(vertEnd, horiEnd, board.getBlock(vertIni, horiIni));
            board.getBlock(vertIni, horiIni).getImage().addAction(Actions.removeActor());
            board.setBlock(vertIni, horiIni, new NumBlock(0));
            board.getBlock(vertIni, horiIni).setCombined(true);
            smthChanged = true;
        }
        
        // when the 2x block is on the initial position, it doubles the value of the initial block 
        else if(Objects.equals(board.getId(vertIni, horiIni), "2x"))
        {
            board.getBlock(vertIni, horiIni).getImage().addAction(animateBlock);
            board.setBlock(vertIni, horiIni, new NumBlock(0));
            board.getBlock(vertEnd, horiEnd).getImage().addAction(Actions.removeActor());
            if(board.getBlock(vertEnd, horiEnd) instanceof NumBlock)
                ((NumBlock) board.getBlock(vertEnd, horiEnd)).combineDouble();
            board.getBlock(vertEnd, horiEnd).setCombined(true);
            smthChanged = true;
        }
    }

    public void updateLifes()
    {
        if (bomb.getActivated())
        {
            bomb.setLife(-1);
            board.getBlock(bomb.getVertical(), bomb.getHorizontal()).getImage().addAction(Actions.removeActor());

            // image updates to show its lives
            if(bomb.getLife() == 2)
                bomb.setImage(new Image(new Texture(Gdx.files.internal("blocks/bomb_2:3.png"))));
            else if(bomb.getLife() == 1)
                bomb.setImage(new Image(new Texture(Gdx.files.internal("blocks/bomb_3:3.png"))));
        }
        if (timer.getActivated())
        {
            timer.setLife(-1);
            board.getBlock(timer.getVertical(), timer.getHorizontal()).getImage().addAction(Actions.removeActor());

            // image updates to show its lives
            if(timer.getLife() == 3)
                timer.setImage(new Image(new Texture(Gdx.files.internal("blocks/time_3:4.png"))));
            else if(timer.getLife() == 2)
                timer.setImage(new Image(new Texture(Gdx.files.internal("blocks/time_2:4.png"))));
            else if(timer.getLife() == 1)
                timer.setImage(new Image(new Texture(Gdx.files.internal("blocks/time_1:4.png"))));
        }
        if(bomb.getLife() == 0)
        {
            smthChanged = true;
            bomb.reset();
            aimNeighbors(bomb.getVertical(), bomb.getHorizontal());
        }
        if (timer.getLife() == 0)
        {
            smthChanged = true;
            timer.reset();
            board.setBlock(timer.getVertical(), timer.getHorizontal(), new NumBlock(0));
        }
    }

    private void aimNeighbors(int vert, int hori)
    {
        explode(vert, hori);

        vert--;
        hori--;
        explode(vert, hori);
        
        vert++;
        explode(vert, hori);

        vert++;
        explode(vert, hori);

        hori++;
        explode(vert, hori);

        hori++;
        explode(vert, hori);

        vert--;
        explode(vert, hori);

        vert--;
        explode(vert, hori);

        hori--;
        explode(vert, hori);
    }

    private void explode(int vert, int hori)
    {
        if(vert >= 0 && vert < board.getSize() && hori >= 0 && hori < board.getSize())
        {
            SequenceAction animateExplosion = new SequenceAction(Actions.scaleTo(0, 0, .25f), Actions.removeActor());
            board.getBlock(vert, hori).getImage().addAction(animateExplosion);
            board.setBlock(vert, hori, new NumBlock(0));
        }
    }

    public void checkWholeBoard()
    {
        nonExistentVoid = true;
        for(int i = 0; i < board.getSize(); i++)
            for(int j = 0; j < board.getSize(); j++)
            {
                if(Objects.equals(board.getId(i, j), 2048))
                    win = true;
                else if(Objects.equals(board.getId(i, j), 0))
                    nonExistentVoid = false;
                board.getBlock(i, j).setCombined(false);
            }
        // if there is no void anymore, the player loses
        if(nonExistentVoid)
            creator.setScreen(new LooseScreen(creator));
    }

    public void setButtonSelected(String idButton, boolean selected)
    {
        switch(idButton)
        {
            case("bomb"):
                buttonBombSelected = selected;
                break;
            case("del"):
                buttonDelSelected = selected;
                break;
            case("time"):
                buttonTimeSelected = selected;
                break;
            case("2x"):
                button2xSelected = selected;
                break;
            case("music"):
                buttonMusicSelected = selected;
                break;
            default:
                break;
        }
    }

    public boolean getButtonSelected(String idButton)
    {
        switch(idButton)
        {
            case("bomb"):
                return buttonBombSelected;
            case("del"):
                return buttonDelSelected;
            case("time"):
                return buttonTimeSelected;
            case("2x"):
                return button2xSelected;
            case("music"):
                return buttonMusicSelected;
            default:
                return false;
        }
    }

    public void connectBoard(Board tabuleiro)
    {
        board = tabuleiro;
    }

    public boolean getWin()
    {
        return win;
    }

    public void setWin(boolean win) {
        this.win = win;
    }
}
