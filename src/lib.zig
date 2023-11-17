const std = @import("std");
const expect = std.testing.expect;

const tolerance = 0.00001;

const Tuple = struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,

    pub fn init(x: f32, y: f32, z: f32, w: f32) Tuple {
        return Tuple{ .x = x, .y = y, .z = z, .w = w };
    }

    pub fn equals(self: Tuple, other: Tuple) bool {
        return @abs(self.x - other.x) < tolerance and
            @abs(self.y - other.y) < tolerance and
            @abs(self.z - other.z) < tolerance and
            @abs(self.w - other.w) < tolerance;
    }

    pub fn point(x: f32, y: f32, z: f32) Tuple {
        return init(x, y, z, 1.0);
    }

    pub fn vec(x: f32, y: f32, z: f32) Tuple {
        return init(x, y, z, 0.0);
    }

    /// Assumes that both self and other are not points.
    pub fn add(self: Tuple, other: Tuple) Tuple {
        return .{ .x = self.x + other.x, .y = self.y + other.y, .z = self.z + other.z, .w = self.w + other.w };
    }

    pub fn sub(self: Tuple, other: Tuple) Tuple {
        return .{ .x = self.x - other.x, .y = self.y - other.y, .z = self.z - other.z, .w = self.w - other.w };
    }

    pub fn negate(self: Tuple) Tuple {
        return .{ .x = -self.x, .y = -self.y, .z = -self.z, .w = -self.w };
    }
};

test "adding two tuples" {
    const a = Tuple.init(3, -2, 5, 1);
    const b = Tuple.init(-2, 3, 1, 0);
    try expect(a.add(b).equals(Tuple.init(1, 1, 6, 1)));
}

test "subtracting two points" {
    const p1 = Tuple.point(3, 2, 1);
    const p2 = Tuple.point(5, 6, 7);
    try expect(p1.sub(p2).equals(Tuple.vec(-2, -4, -6)));
}

test "subtracting a vector from a point" {
    const v1 = Tuple.point(3, 2, 1);
    const p2 = Tuple.vec(5, 6, 7);
    try expect(v1.sub(p2).equals(Tuple.point(-2, -4, -6)));
}

test "subtracting two vectors" {
    const v1 = Tuple.vec(3, 2, 1);
    const v2 = Tuple.vec(5, 6, 7);
    try expect(v1.sub(v2).equals(Tuple.vec(-2, -4, -6)));
}

test "subtracting a vector from the zero vector" {
    const v1 = Tuple.vec(0, 0, 0);
    const v2 = Tuple.vec(1, -2, 3);
    try expect(v1.sub(v2).equals(Tuple.vec(-1, 2, -3)));
}

test "negating a tuple" {
    const v = Tuple.init(1, -2, 3, -4);
    try expect(v.negate().equals(Tuple.init(-1, 2, -3, 4)));
}
