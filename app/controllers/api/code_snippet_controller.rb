module Api
  class CodeSnippetController < BaseController
    def index
      respond_to do |format|
        format.json { render json: code_snippets }
      end
    end

    def sketch
      respond_to do |format|
        format.json { render json: sketch_code }
      end
    end

    private

    def code_snippets
      klass = params.require(:board_type).constantize
      params.require(:link_types).to_a.map do |link|
        {
          name: link,
          code: klass.instance_method(link.to_sym).source.strip
        }
      end
    end

    def sketch_code
      {
        name: "Sketch Code",
        code: Sketch::CodeGenerator.new(params.require(:sketch_id)).generate
      }
    end
  end
end
