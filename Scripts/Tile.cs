using Godot;
using System;

public class Tile : Spatial
{
    public Vector2 pos { get; set; }
    public int id { get; set; }
    public String type { get; private set; }
    private Color color;
    private SpatialMaterial material;
    private CSGBox top;
    private StaticBody collision_object;
    private CollisionShape collision_shape;

    [Signal]
    public delegate void tile_hovered(Tile tile);

    [Signal]
    public delegate void tile_left(Tile tile);


    public override void _Ready()
    {

    }

    public void create_tile(String type, Vector2 pos)
    {
        this.type = type;
        this.pos = pos;

        this.top = new CSGBox();
        this.top.Width = 1;
        this.top.Height = 0.001f;
        this.top.Depth = 1;

        var box_base = new CSGBox();
        box_base.Width = 1;
        box_base.Depth = 1;

        this.material = new SpatialMaterial();
        var base_material = new SpatialMaterial();

        Transform top_transform = top.Transform;
        Transform base_transform = box_base.Transform;

        if (this.type.Equals("Tile")) {
            box_base.Height = 0.499f;                
            top_transform.origin.y = 0.25f;
            base_transform.origin.y = -0.001f;

            this.material.AlbedoTexture = GD.Load<StreamTexture>("res://Textures/tile.png");
            this.color = new Color(0.678f, 0.592f, 0.482f);

            this.collision_object = new StaticBody();
            this.collision_shape = new CollisionShape();
            var shape = new BoxShape();

            Transform transform = collision_shape.Transform;
            transform.origin.y = 0.25f;
            this.collision_shape.Transform = transform;
            shape.Extents = new Vector3(0.5f, 0.001f, 0.5f);
            this.collision_shape.Shape = shape;
            this.collision_object.AddChild(collision_shape);
            this.AddChild(collision_object);

            collision_object.Connect("mouse_entered", this, "_tile_hovered");
            collision_object.Connect("mouse_exited", this, "_tile_left");
        } else {
            box_base.Height = 0.999f;
            top_transform.origin.y = 0.75f;
            base_transform.origin.y = 0.249f;
            this.color = new Color(0.5f, 0.466f, 0.408f);
        }

        this.top.Transform = top_transform;
        box_base.Transform = base_transform;
        
        
        this.material.AlbedoColor = this.color;
        base_material.AlbedoColor = this.color;

        this.top.Material = this.material;
        box_base.Material = base_material;

        AddChild(this.top);
        AddChild(box_base);
    }

    public void change_color(Color new_color)
    {
        this.material.AlbedoColor = new_color;
        this.top.Material = this.material;
    }

    public void reset_color()
    {
        this.material.AlbedoColor = this.color;
        this.top.Material = this.material;
    }

    public void _tile_hovered() { EmitSignal("tile_hovered", this); }
    public void _tile_left() { EmitSignal("tile_left", this); }
}
