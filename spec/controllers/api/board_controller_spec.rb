require 'rails_helper'

RSpec.describe Api::BoardController, type: :controller do
  describe "GET #index" do
    let!(:user) { create(:user) }
    let!(:board) { create(:board, mac: "1234", status: "online", user: user) }
    let!(:bad_board) { create(:board, mac: "5678", user: user, register_status: "unregistered") }

    it "only registered boards" do
      get :index, params: { format: :json, subtype: "RealBoard", user_id: user.id }

      expect(json_response.count).to eq 1
      expect(json_response.dig(0, "mac")).to eq board.mac
    end

    it "raises a 406 for bad format" do
      expect{
        get :index, params: { format: :html, user_id: user.id }
      }.to raise_error("ActionController::UnknownFormat")
    end
  end

  describe "GET #show" do
    let!(:user) { create(:user) }
    let!(:board_with_mac) { create(:board, mac: "12345", user: user) }
    let!(:board) { create(:board, mac: "5678", user: user) }

    it "finds by mac" do
      get :show, params: { id: board_with_mac.mac, user_id: user.id, format: :json }

      expect(response).to have_http_status :ok
      expect(json_response["mac"]).to eq "12345"
    end

    it "finds the board by id" do
      get :show, params: { id: board.id, user_id: user.id, format: :json }

      expect(json_response["id"]).to eq board.id
    end
  end
end
