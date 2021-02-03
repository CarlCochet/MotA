using Godot;
using System;
using System.Collections.Generic;

public class Team : Spatial
{

    private List<Character> characters;

    public override void _Ready()
    {
        characters = new List<Character>();
    }
}
