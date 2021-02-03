using Godot;
using System;

public class Character : Spatial
{
    private int movement_points;
    private int action_points;
    private int range_bonus;
    private Outfit outfit;

    public override void _Ready()
    {
        this.movement_points = 2;
        this.action_points = 4;
        this.range_bonus = 0;

        var body = GD.Load<PackedScene>("res://Scenes/Models/Character.tscn");
        AddChild(body.Instance());

        this.outfit = GetNode<Outfit>("Outfit");
        this.outfit.get_dressed("druid");
    }
}
