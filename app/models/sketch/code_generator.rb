class Sketch
  class CodeGenerator
    attr_reader :sketch, :code, :boards

    def initialize sketch_id
      @sketch = Sketch.find sketch_id
      @boards = Board.where mac: sketch.boards.map{ |b| b["mac"] }
      @code = ""
    end

    def generate
      generate_public_code
      append_private_methods
      code
    end

    private

    def append_private_methods
      code << "private\n"
      sketch.links.each do |link|
        to_board = find_board link["to"]
        code << to_board.class.instance_method(link["logic"].to_sym).source.strip
      end
    end

    def generate_public_code
      code << "def run\n"
      sketch.links.each do |link|
        from_board = find_board link["from"]
        name = from_board.name.presence || from_board.type rescue binding.pry
        code << <<~RUBY
if #{name.underscore}.received
  #{link["logic"]}()
end
        RUBY
      end
      code << "end\n"
    end

    private

    def find_board mac
      Board.find_by mac: mac
    end
  end
end
