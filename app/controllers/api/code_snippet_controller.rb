module Api
  class CodeSnippetController < BaseController
    def index
      respond_to do |format|
        format.json { render json: code_snippets }
      end
    end

    private

    def code_snippets
      params.require(:link_types).to_a.map do |link|
        {
          code: Led.instance_method(link.to_sym).source.strip
        }
      end
    end
  end
end
