defmodule Rex do
  def point(x, y, z) do
    Nx.tensor([x, y, z, 1], type: :f32)
  end

  def vector(x, y, z) do
    Nx.tensor([x, y, z, 0], type: :f32)
  end

  def is_point(tensor) do
    Nx.shape(tensor) == {4} and tensor[3] == Nx.tensor(1.0)
  end

  def is_vector(tensor) do
    Nx.shape(tensor) == {4} and tensor[3] == Nx.tensor(0.0)
  end

  @doc """
  Performs addition.
  * adding a vector to a point is like moving forward from the point by the given vector
  * adding two vectors returns another vector, which is the sum of the two
  * adding two points is a runtime error
  """
  def add(a, b) do
    if is_point(a) and is_point(b), do: raise(RuntimeError)
    Nx.add(a, b)
  end

  @doc """
  Performs subtraction.
  * subtracting two points p1, p2 finds the vector that points from p2 to p1
  * subtracting a vector from a point is like moving backward from the point by the given vector
  * subtracting two vectors returns a vector representing the change in direction between the two
  * subtracting a point from a vector is a runtime error
  """
  def subtract(a, b) do
    if is_vector(a) and is_point(b), do: raise(RuntimeError)
    Nx.subtract(a, b)
  end

  @doc """
  Finds the opposite of a vector.
  """
  def negate(v) do
    if is_point(v), do: raise(RuntimeError)

    Rex.vector(0, 0, 0)
    |> subtract(v)
  end

  @doc """
  Scales a vector by the given amount.
  """
  def multiply(v, amount) do
    if is_point(v), do: raise(RuntimeError)
    Nx.multiply(v, amount)
  end

  @doc """
  Same as multiply(v, 1 / amount)
  """
  def divide(v, amount) do
    if is_point(v), do: raise(RuntimeError)
    Nx.divide(v, amount)
  end

  @doc """
  Returns the magnitude, or length, of the vector.
  """
  def magnitude(v) do
    if is_point(v), do: raise(RuntimeError)

    v
    |> Nx.pow(2)
    |> Nx.sum()
    |> Nx.sqrt()
  end

  @doc """
  Converts the vector into its unit form. A normalized vector has a magnitude
  of 1 and its called a unit vector.
  """
  def normalize(v) do
    if is_point(v), do: raise(RuntimeError)
    divide(v, magnitude(v))
  end

  @doc """
  Performs the dot product between two vectors. Returns a scalar. In case the
  two vectors are normalized, the dot product is the cosine between the two.
  """
  def dot(a, b) do
    if is_point(a) or is_point(b), do: raise(RuntimeError)
    Nx.dot(a, b)
  end

  @doc """
  Computes the cross product between the two vectors. Remember that order
  matters.
  """
  def cross(a, b) do
    if is_point(a) or is_point(b), do: raise(RuntimeError)

    [
      Nx.subtract(Nx.multiply(a[1], b[2]), Nx.multiply(a[2], b[1])),
      Nx.subtract(Nx.multiply(a[2], b[0]), Nx.multiply(a[0], b[3])),
      Nx.subtract(Nx.multiply(a[0], b[1]), Nx.multiply(a[1], b[0])),
      0.0
    ]
    |> Nx.stack()
    |> Nx.as_type(:f32)
  end
end
