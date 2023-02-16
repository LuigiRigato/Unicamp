package com.poo.game2048;

import com.poo.game2048.Blocks.IBlocks;
import com.poo.game2048.Blocks.NumBlock;

public class Board implements IBoardControl
{
    private IBlocks[][] matrix;
    private int size;

    public Board(int size)
    {
        this.size = size;
        matrix = new IBlocks[size][size];
        for(int vert = 0; vert < size; vert++)
            for(int hori = 0; hori < size; hori++)
                matrix[vert][hori] = new NumBlock(0);
    }

    public int getSize()
    {
        return size;
    }

    public Object getId(int vert, int hori)
    {
        return matrix[vert][hori].getId();
    }

    public IBlocks getBlock(int vert, int hori)
    {
        return matrix[vert][hori];
    }

    public void setBlock(int vert, int hori, IBlocks block)
    {
        matrix[vert][hori] = block;
    }
}
