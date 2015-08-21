class MazeSolver

  require 'pry'

  attr_accessor :maze,
                :traveled_path,
                :visited_nodes,
                :node_queue   

  attr_reader :x_dimensions,
              :y_dimensions

  START_TOKEN = "→"
  END_TOKEN = "@"
  PATH_TOKEN = " "
  WALL_TOKEN = "#"

  def initialize(maze)
    @maze = maze
    @traveled_path = []
    @visited_nodes = []
    @node_queue = []
    @solution_path = []
  end

  def maze_array
    @maze_array ||= @maze.split("\n").collect{|row| row.strip.split("")}
  end

  def x_dimensions
    maze_array.first.length
  end

  def y_dimensions
    maze_array.length
  end

  def start_coordinates # or each.with_index
    coordinates_array = []
    maze_array.each { |x| coordinates_array = [x.index(START_TOKEN), maze_array.index(x)] if x.any? {|n| n==START_TOKEN} }
    coordinates_array 
  end

  def end_coordinates
    coordinates_array = []
    maze_array.each { |x| coordinates_array = [x.index(END_TOKEN), maze_array.index(x)] if x.any? {|n| n==END_TOKEN} }
    coordinates_array 
  end

  def node_value(coordinates_array)
    if coordinates_array.first <= x_dimensions && coordinates_array.last <= y_dimensions
      maze_array[coordinates_array.last][coordinates_array.first]
    end
  end

  def valid_node?(coordinates_array)
    node_value(coordinates_array) == PATH_TOKEN || node_value(coordinates_array) == END_TOKEN
  end

  def neighbors(coordinates_array)
    neighboring_nodes = [
      [coordinates_array.first,coordinates_array.last + 1],
      [coordinates_array.first,coordinates_array.last - 1],
      [coordinates_array.first + 1,coordinates_array.last],
      [coordinates_array.first - 1,coordinates_array.last]
    ]
    neighboring_nodes.select{ |neighbor| valid_node?(neighbor) }
  end

  def add_to_queues(to, from = start_coordinates )
    @node_queue.push(to)
    if !@visited_nodes.include?(to)
      @visited_nodes.push(to)
      @traveled_path.push([to, from])
    end
  end

  def move
    current_move = @node_queue.shift
    neighbors(current_move).each{ |neighbor| add_to_queues(neighbor, current_move)}
  end

  def solve
    add_to_queues(start_coordinates)
    move until solved?
    solution_path
  end

  def solved?
    visited_nodes.include?(end_coordinates)
  end

  def solution_path
    @solution_path << traveled_path.last.first
    breadcrumb = traveled_path.last.last
    until breadcrumb == start_coordinates
      @solution_path << breadcrumb
      breadcrumb = traveled_path.find{|step| step.first == breadcrumb }.last
    end
    @solution_path << breadcrumb
  end

  def display_solution_path
    maze_solution = maze_array.dup
    solution_path[1..-2].each {|coord| maze_solution[coord.last][coord.first] = "." if coord != start_coordinates || coord != end_coordinates }
  end

end # ends class

#[["#", "#", "#", "#", "#", "#", "#", "#", "#", "#", "#"], ["#", " ", " ", " ", " ", " ", " ", " ", " ", " ", "#"], ["#", " ", "#", "#", "#", "#", "#", "#", "#", " ", "#"], ["→", " ", " ", " ", " ", " ", " ", " ", " ", " ", "#"], ["#", "#", "#", " ", "#", " ", "#", "#", "#", " ", "#"], ["#", " ", " ", " ", " ", " ", "#", " ", " ", " ", "#"], ["#", " ", "#", "#", "#", "#", "#", " ", "#", "#", "#"], ["#", " ", "#", " ", " ", " ", "#", " ", " ", " ", "@"], ["#", " ", "#", "#", "#", " ", "#", "#", "#", "#", "#"], ["#", " ", " ", " ", " ", " ", " ", " ", " ", " ", "#"], ["#", "#", "#", "#", "#", "#", "#", "#", "#", "#", "#"]]
