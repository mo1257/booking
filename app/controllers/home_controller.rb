class HomeController < ApplicationController
  def index
    @q = Room.ransack(params[:q])
  end
end
