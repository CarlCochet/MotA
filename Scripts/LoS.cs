using Godot;
using System;
using System.Diagnostics;
using System.Collections.Generic;

public class LoS : Spatial
{
    private Vector2 start;
    private Tile[,] tiles;
    private int map_size;
    private List<Vector2> pos_in_sight;
    private List<Vector2> previous_pos_in_sight;
    private List<Vector2> all_los;
    private List<Vector2> previous_all_los;
    private Color los_color;

    public override void _Ready()
    {
        this.start = new Vector2();
        this.pos_in_sight = new List<Vector2>();
        this.previous_pos_in_sight = new List<Vector2>();
        this.all_los = new List<Vector2>();
        this.previous_all_los = new List<Vector2>();
        this.los_color = new Color(0, 0, 0.7f);
    }

    public void reset_state()
    {
        if (this.tiles != null && this.previous_all_los != null) {
            foreach (Vector2 pos in this.all_los) {
                tiles[(int)pos.x, (int)pos.y].reset_color();
            }
        }

        this.start = new Vector2();
        this.pos_in_sight = new List<Vector2>();
        this.previous_pos_in_sight = new List<Vector2>();
        this.all_los = new List<Vector2>();
        this.previous_all_los = new List<Vector2>();
    }

    public void set_start(Tile tile)
    {
        this.start = tile.pos;
    }

    public void set_tiles(Tile[,] new_tiles)
    {
        this.tiles = new_tiles;
        map_size = tiles.GetLength(0);
    }

    public void display_all_los()
    {
        if (this.tiles != null) {
            if (this.previous_all_los != null) {
                foreach (Vector2 pos in this.previous_all_los) {
                    tiles[(int)pos.x, (int)pos.y].reset_color();
                }
            }

            if (this.all_los != null) {
                foreach (Vector2 pos in this.all_los) {
                    tiles[(int)pos.x, (int)pos.y].change_color(this.los_color);
                }
            }
        }
    }

    public void display_los()
    {
        if (this.tiles != null) {
            if (this.previous_pos_in_sight != null) {
                foreach (Vector2 pos in this.previous_pos_in_sight) {
                    tiles[(int)pos.x, (int)pos.y].reset_color();
                }
            }

            if (this.pos_in_sight != null) {
                foreach (Vector2 pos in this.pos_in_sight) {
                    tiles[(int)pos.x, (int)pos.y].change_color(this.los_color);
                }
            }
        }
    }

    public void get_all_los(int max_range)
    {
        var pos = new Vector2();
        this.previous_all_los = this.all_los;
        this.all_los = new List<Vector2>();

        for (int x = -max_range; x < max_range; x++) {
            for (int y = -max_range; y < max_range; y++) {
                pos.x = this.start.x - x;
                pos.y = this.start.y - y;

                if (pos.x >= 0 && pos.y >= 0 && pos.x < map_size && pos.y < map_size) {
                    if (Math.Abs(x) + Math.Abs(y) <= max_range) {
                        var valid = compute_los(pos);

                        if (valid == true && this.pos_in_sight.Count > 0) {
                            this.all_los.Add(this.pos_in_sight[this.pos_in_sight.Count - 1]);
                        }
                    }
                }
            }
        }
    }

    public bool compute_los(Vector2 target)
    {
        this.pos_in_sight = new List<Vector2>();

        var d = new Vector2(Math.Abs(this.start.x - target.x), Math.Abs(this.start.y - target.y));
        var pos = this.start;
        var n = d.x + d.y;
        var vector = new Vector2(target.x>this.start.x?1:-1, target.y>this.start.y?1:-1);
        var error = d.x - d.y;
        d *= 2;

        while (n > 0)
        {
            if (error > 0) {
                pos.x += vector.x;
                error -= d.y;
            } else if (error == 0) {
                pos += vector;
                n -= 1;
                error += d.x - d.y;
            } else {
                pos.y += vector.y;
                error += d.x;
            }

            if (pos.x >= 0 && pos.x < map_size && pos.y >= 0 && pos.y < map_size) {
                if (tiles[(int)pos.x, (int)pos.y] != null) {
                    if (tiles[(int)pos.x, (int)pos.y].type == "Obstacle") {
                        break;
                    } else {
                        this.pos_in_sight.Add(pos);
                    }
                }
            }
            n -= 1;
        }

        return (pos.x == target.x && pos.y == target.y);
    }
}
