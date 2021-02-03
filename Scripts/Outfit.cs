using Godot;
using System;

public class Outfit : Spatial
{
    private PackedScene hat;
    private PackedScene weapon;
    private PackedScene clothes; 

    public override void _Ready()
    {
        this.hat = null;
        this.weapon = null;
        this.clothes = null;
    }

    public void get_dressed(String character_class) 
    {
        if (character_class.Equals("druid"))
        {
            this.hat = GD.Load<PackedScene>("res://Scenes/Models/Druid_Hat.tscn");
            AddChild(this.hat.Instance());
        }
    }

}
