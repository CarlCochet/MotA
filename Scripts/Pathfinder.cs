using Godot;
using System;
using System.Diagnostics;
using System.Collections.Generic;

public class Pathfinder : Spatial
{
    public AStar2D astar { get; set; }
    private Tile start;
    private Vector2[] previous_path;
    private Vector2[] path;
    private Tile[,] tiles;
    private int map_size;
    private List<Vector2> all_possible_moves;
    private List<Vector2> all_previous_possible_moves;
    private Color path_color;

    public override void _Ready()
    {
        this.astar = new AStar2D();
        this.previous_path = null;
        this.path = null;
        this.all_possible_moves = new List<Vector2>();
        this.all_previous_possible_moves = new List<Vector2>();
        this.path_color = new Color(0, 0.7f, 0);
    }

    public void reset_state()
    {
        if (this.tiles != null) {
            if (this.all_possible_moves != null) {
                foreach (Vector2 pos in this.all_possible_moves) {
                    this.tiles[(int)pos.x, (int)pos.y].reset_color();
                }
            }

            if (this.path != null) {
                foreach (Vector2 pos in this.path) {
                    this.tiles[(int)pos.x, (int)pos.y].reset_color();
                }
            }
        }

        this.previous_path = null;
        this.path = null;
        this.all_possible_moves = new List<Vector2>();
        this.all_previous_possible_moves = new List<Vector2>();
    }

    public int get_id_from_pos(Vector2 pos) 
    {
        return (int)(pos.x * this.map_size + pos.y);
    }

    public void set_start(Tile tile)
    {
        this.start = tile;
    }

    public void set_tiles(Tile[,] new_tiles)
    {
        this.tiles = new_tiles;
        this.map_size = this.tiles.GetLength(0);
    }

    public void display_all_path() 
    {
        if (this.tiles != null) {
            if (this.all_previous_possible_moves != null) {
                foreach (Vector2 pos in this.all_previous_possible_moves) {
                    this.tiles[(int)pos.x, (int)pos.y].reset_color();
                }
            }

            if (this.all_possible_moves != null) {
                foreach (Vector2 pos in this.all_possible_moves) {
                    this.tiles[(int)pos.x, (int)pos.y].change_color(this.path_color);
                }
            }
        }
    }

    public void display_path() 
    {
        if (this.tiles != null) {
            if (this.previous_path != null) {
                foreach (Vector2 pos in this.previous_path) {
                    this.tiles[(int)pos.x, (int)pos.y].reset_color();
                }
            }

            if (this.path != null) {
                foreach (Vector2 pos in this.path) {
                    this.tiles[(int)pos.x, (int)pos.y].change_color(this.path_color);
                }
            }
        }
    }

    public void get_all_paths(int max_move)
    {
        Vector2 pos = new Vector2();
        int id;
        Vector2[] temp_path;

        this.all_previous_possible_moves = this.all_possible_moves;
        this.all_possible_moves = new List<Vector2>();

        for (int x = -max_move; x < max_move; x++) {
            for (int y = -max_move; y < max_move; y++) {
                pos.x = this.start.pos.x + x;
                pos.y = this.start.pos.y + y;

                if (pos.x >= 0 && pos.y >= 0 && pos.x < this.map_size && pos.y < this.map_size) {
                    if (Math.Abs(x) + Math.Abs(y) <= max_move) {
                        id = get_id_from_pos(pos);

                        if (this.astar.HasPoint(id)) {
                            temp_path = this.astar.GetPointPath(this.start.id, id);

                            if (temp_path.Length <= max_move) {
                                foreach (Vector2 point in temp_path) {
                                    if (!this.all_possible_moves.Contains(point)) {
                                        this.all_possible_moves.Add(point);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    public void compute_path(int id)
    {
        if (this.start != null) {
            this.previous_path = this.path;
            this.path = this.astar.GetPointPath(this.start.id, id);
        }
    }
}
