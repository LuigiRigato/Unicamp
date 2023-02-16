package com.poo.game2048;

import com.poo.game2048.Blocks.IBlocks;

public interface IBoardControl
{
    public int getSize();
    public Object getId(int vert, int hori);
    public IBlocks getBlock(int vert, int hori);
    public void setBlock(int vert, int hori, IBlocks block);
}