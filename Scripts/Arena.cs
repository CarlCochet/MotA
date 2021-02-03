using Godot;
using System;
using System.Collections.Generic;

public class Arena : Spatial
{
    private RandomNumberGenerator rng;
    private PackedScene tile;
    private Pathfinder pathfinder;
    private LoS los;
    private int display_mode;
    private int[,] map;
    private Tile[,] tile_instances;
    private Camera camera;
    private int map_size;
    private Tile target_tile;

    public override void _Ready()
    {
        this.rng = new RandomNumberGenerator();
        this.rng.Randomize();

        this.map_size = 35;
        this.map = new int[this.map_size, this.map_size];
        this.tile_instances = new Tile[this.map_size, this.map_size];
        this.display_mode = 0;

        this.tile = GD.Load<PackedScene>("res://Scenes/Map/Tile.tscn");

        this.pathfinder = GetNode<Pathfinder>("Pathfinder");
        this.los = GetNode<LoS>("LoS");
        this.camera = GetNode<Camera>("Camera");

        generate_map();
    }

    public void reset_tools_state()
    {
        this.pathfinder.reset_state();
        this.los.reset_state();
    }

    public void generate_map()
    {   
        for (int i = 0; i < this.tile_instances.GetLength(0); i++) {
            for (int k = 0; k < this.tile_instances.GetLength(1); k++) {
                if (this.tile_instances[i, k] != null) {
                    this.tile_instances[i, k].QueueFree();
                }
            }
        }

        this.tile_instances = new Tile[this.map_size, this.map_size];
        this.map = new int[this.map_size, this.map_size];
        this.pathfinder.astar.Clear();
        
        int id = 0;

        for (int i = 0; i < this.map_size; i++) {
            for (int k = 0; k < this.map_size; k++) {
                if (i < k + 15 && i > k - 15 && k + i < 55 && k + i > 15) {
                    Tile spawn = null;

                    if (i < 6 || i > 29) {
                        spawn = (Tile)tile.Instance();
                        spawn.create_tile("Tile", new Vector2(i, k));
                        spawn.id = id;
                        this.map[i, k] = 2;
                    } else {
                        if (i <= 17) {
                            var rand_num = this.rng.RandiRange(0, 10);

                            if (rand_num < 9) {
                                spawn = (Tile)tile.Instance();
                                spawn.create_tile("Tile", new Vector2(i, k));
                                spawn.id = id;
                                this.map[i, k] = 2;
                            } else if (rand_num == 9) {
                                spawn = (Tile)tile.Instance();
                                spawn.create_tile("Obstacle", new Vector2(i, k));
                                this.map[i, k] = 1;
                            } else {
                                this.map[i, k] = 0;
                            }
                        } else {
                            if (this.map[this.map_size - i, this.map_size - k] == 2) {
                                spawn = (Tile)tile.Instance();
                                spawn.create_tile("Tile", new Vector2(i, k));
                                spawn.id = id;
                                this.map[i, k] = 2;
                            } else if (this.map[this.map_size - i, this.map_size - k] == 1) {
                                spawn = (Tile)tile.Instance();
                                spawn.create_tile("Obstacle", new Vector2(i, k));
                                this.map[i, k] = 1;
                            } else {
                                this.map[i, k] = 0;
                            }
                        }
                    }

                    if (spawn != null) {
                        Transform transform = spawn.Transform;
                        transform.origin.x = k - 20;
                        transform.origin.z = i - 15;
                        spawn.Transform = transform;

                        this.tile_instances[i, k] = spawn;
                        AddChild(spawn);
                    } else {
                        this.tile_instances[i, k] = null;
                    }
                } else {
                    this.map[i, k] = 0;
                    this.tile_instances[i, k] = null;
                }

                if (this.map[i, k] == 2) {
                    this.pathfinder.astar.AddPoint(id, new Vector2(i, k));

                    if (i > 0) {
                        if (this.map[i - 1, k] == 2) {
                            this.pathfinder.astar.ConnectPoints(id, id - this.map_size);
                        }
                    }
                    if (k > 0) {
                        if (this.map[i, k - 1] == 2) {
                            this.pathfinder.astar.ConnectPoints(id, id - 1);
                        }
                    }
                }

                id += 1;
            }
        }

        for (int i = 0; i < this.tile_instances.GetLength(0); i++) {
            for (int k = 0; k < this.tile_instances.GetLength(1); k++) {
                if (this.tile_instances[i, k] != null) {
                    if (this.tile_instances[i, k].type.Equals("Tile")) {
                        this.tile_instances[i, k].Connect("tile_hovered", this, "mouse_in_tile");
                        this.tile_instances[i, k].Connect("tile_left", this, "mouse_out_tile");
                    }
                }
            }
        }

        this.pathfinder.set_tiles(tile_instances);
        this.los.set_tiles(tile_instances);
    }

    public void mouse_in_tile(Tile tile_instance) {
        this.target_tile = tile_instance;
        display_map();
    }

    public void mouse_out_tile(Tile tile_instance) {
        target_tile = tile_instance;
    }

    public void display_map() {
        if (this.display_mode == 0) {
            this.pathfinder.compute_path(target_tile.id);
            this.pathfinder.display_path();
        }

        if (this.display_mode == 1) {
            this.pathfinder.set_start(this.target_tile);
            this.pathfinder.get_all_paths(10);
            this.pathfinder.display_all_path();
        }

        if (this.display_mode == 2) {
            this.los.set_start(this.target_tile);
            this.los.get_all_los(40);
            this.los.display_all_los();
        }
    }

    public override void _Input(InputEvent inputEvent)
    {
        if (inputEvent is InputEventMouseButton) {
            if (this.target_tile != null) {
                this.pathfinder.set_start(this.target_tile);
                display_map();
            }
        }

        if (inputEvent is InputEventKey) {
            InputEventKey inputEventKey = (InputEventKey)inputEvent;
            if (inputEventKey.IsPressed() && inputEventKey.Scancode == (uint)KeyList.Escape) {
                GetTree().Quit();
            }

            if (inputEventKey.IsPressed() && inputEventKey.Scancode == (uint)KeyList.Key1) {
                this.display_mode = 0;
                reset_tools_state();
            }
            if (inputEventKey.IsPressed() && inputEventKey.Scancode == (uint)KeyList.Key2) {
                this.display_mode = 1;
                reset_tools_state();
            }
            if (inputEventKey.IsPressed() && inputEventKey.Scancode == (uint)KeyList.Key3) {
                this.display_mode = 2;
                reset_tools_state();
            }
            if (inputEventKey.IsPressed() && inputEventKey.Scancode == (uint)KeyList.Key4) {
                reset_tools_state();
                generate_map();
            }
        }
    }
}
