defmodule RexTest do
  use ExUnit.Case

  @epsilon 0.000001

  test "a point has w == 1" do
    p = Rex.point(1, 2, 3)
    assert p[3] == Nx.tensor(1.0)
    assert Rex.is_point(p)
  end

  test "a vector has w == 0" do
    p = Rex.vector(1, 2, 3)
    assert p[3] == Nx.tensor(0.0)
    assert Rex.is_vector(p)
  end

  describe "add/2" do
    test "vector to a point" do
      a = Rex.point(3, -2, 5)
      b = Rex.vector(-2, 3, 1)
      assert Rex.add(a, b) == Rex.point(1, 1, 6)
    end

    test "fails with two points" do
      a = Rex.point(3, -2, 5)
      b = Rex.point(3, -2, 5)
      assert_raise RuntimeError, fn -> Rex.add(a, b) end
    end
  end

  describe "subtract/2" do
    test "subtracting two points" do
      a = Rex.point(3, 2, 1)
      b = Rex.point(5, 6, 7)
      assert Rex.subtract(a, b) == Rex.vector(-2, -4, -6)
    end

    test "subtracting a vector from a point" do
      a = Rex.point(3, 2, 1)
      b = Rex.vector(5, 6, 7)
      assert Rex.subtract(a, b) == Rex.point(-2, -4, -6)
    end

    test "subtracting two vectors" do
      a = Rex.vector(3, 2, 1)
      b = Rex.vector(5, 6, 7)
      assert Rex.subtract(a, b) == Rex.vector(-2, -4, -6)
    end

    test "fails when subtracting a point from a vector" do
      a = Rex.vector(3, 2, 1)
      b = Rex.point(5, 6, 7)
      assert_raise RuntimeError, fn -> Rex.subtract(a, b) end
    end
  end

  test "negates a vector" do
    a = Rex.vector(1, 2, -3)
    assert Rex.negate(a) == Rex.vector(-1, -2, 3)
  end

  test "scales a vector" do
    a = Rex.vector(1, -2, 3)
    assert Rex.multiply(a, 3.5) == Rex.vector(3.5, -7, 10.5)

    a = Rex.vector(1, -2, 3)
    assert Rex.multiply(a, 0.5) == Rex.vector(0.5, -1, 1.5)
  end

  describe "magnitude/1" do
    for {x, y, z, magnitude} <- [
          {1, 0, 0, 1},
          {0, 1, 0, 1},
          {0, 0, 1, 1},
          # sqrt(14)
          {1, 2, 3, 3.7416573867739413},
          # sqrt(14)
          {-1, -2, -3, 3.7416573867739413}
        ] do
      test "of vector #{inspect({x, y, z})}" do
        vector = Rex.vector(unquote(x), unquote(y), unquote(z))
        have = Rex.magnitude(vector) |> Nx.to_number()
        assert_in_delta have, unquote(magnitude), @epsilon
      end
    end
  end

  describe "normalize/1" do
    for {x, y, z} <- [
          {4, 0, 0},
          {1, 2, 3}
        ] do
      test "vector #{inspect({x, y, z})}" do
        vector = Rex.vector(unquote(x), unquote(y), unquote(z))
        magnitude = Rex.normalize(vector) |> Rex.magnitude() |> Nx.to_number()
        assert_in_delta magnitude, 1.0, @epsilon
      end
    end
  end

  test "dot/2" do
    a = Rex.vector(1, 2, 3)
    b = Rex.vector(2, 3, 4)
    assert Rex.dot(a, b) |> Nx.to_number() == 20.0
  end

  test "cross/2" do
    x = Rex.vector(1, 0, 0)
    y = Rex.vector(0, 1, 0)
    z = Rex.vector(0, 0, 1)
    assert Rex.cross(x, y) == z
    assert Rex.cross(y, z) == x
    assert Rex.cross(z, x) == y
  end
end
