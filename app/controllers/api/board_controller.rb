module Api
  class BoardController < BaseController
    before_action :find_board, only: [:show, :update, :deregister]

    def index
      if params[:subtype]=="RealBoard"
        @boards = board_scope.where(params.permit(:subtype)).registered.order(:id).limit 10
      else
        @boards = Board.virtualBoards.map { |class_name|
          b = class_name.constantize.new
          b.accepted_links = b.get_methods
          b.subtype = "VirtualBoard"
          b
        }
      end
      respond_to do |format|
        format.json { render json: @boards, each_serializer: BoardSerializer }
      end
    end

    def create
      @board = Board.create(board_params)
    end

    def show
      respond_to do |format|
        format.json { render json: @board }
      end
    end

    def update
      @board.update update_board_params
      render json: {}, status: :ok
    end

    def register
      @boards = find_board_partial
      @boards.each do |board|
        board.update register_status: 'pending', user_id: params[:user_id]
        Log.register(board, 'unregistered')
        ActionCable.server.broadcast 'register_channel', board: board, type: 'board_details'
      end
      respond_to do |format|
        format.json { render json: @boards }
      end
    end

    def deregister
      @board.update register_status: 'unregistered'
      Log.register(@board, 'registered')
      ActionCable.server.broadcast 'register_channel', board: @board, type: 'deregister_board'
      respond_to do |format|
        format.json { render json: @board }
      end
    end

    private

    def board_params
      params.require(:mac)
    end

    def update_board_params
      params.permit(:name, :type, metadata: [:status, "13"])
    end

    def find_board
      @board = board_scope.find_by(mac: params[:id]).presence || board_scope.find(params[:id])
    end

    def board_scope
      Board.for_user(params.require(:user_id))
    end

    def find_board_partial
      suffix = "%#{params[:partial_mac].downcase.insert(2, ':')}"
      Board.where(register_status: 'unregistered', status: 'online').where('lower(mac) LIKE :suffix', suffix: suffix)
    end
  end
end
