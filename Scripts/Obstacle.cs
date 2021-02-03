using Godot;
using System;

public class Obstacle : Spatial
{
    public Vector2 pos { get; set; }
    public int id { get; set; }
    private String type;
    private CSGBox top;
    private Color color;
    private SpatialMaterial material;
    
    public override void _Ready()
    {
        this.top = GetNode<CSGBox>("Top");
        this.material = (SpatialMaterial)this.top.Material;
        this.color = material.AlbedoColor;
        this.type = "Obstacle";
    }

    public void change_color(Color new_color)
    {
        this.material.AlbedoColor = new_color;
        this.top.Material = this.material;
    }
}
