# app/controllers/rooms_controller.rb
class RoomsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]

  def index
    @rooms = current_user.rooms
  end

  def show
    @room = Room.find(params[:id])
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      redirect_to @room, notice: '施設が登録されました。'
    else
      render :new
    end
  end
   
  def edit
    @room = current_user.rooms.find_by(id: params[:id])
    if @room.nil?
      redirect_to rooms_path, alert: '施設が見つかりません。'
    end
  end
  
  def update
    @room = current_user.rooms.find(params[:id])
    if @room.update(room_params)
      redirect_to @room, notice: '施設が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @room = current_user.rooms.find_by(id: params[:id])
    
    if @room
      @room.destroy
      flash[:notice] = '施設が削除されました。'
    else
      flash[:alert] = '指定された施設が見つかりません。'
    end
  
    redirect_to rooms_path
  end

  def search
    valid_areas = ["東京", "大阪", "京都", "札幌"]

    if params[:area].present?
      if valid_areas.include?(params[:area])
        @rooms = Room.where(["address LIKE ?", "%#{params[:area]}%"])
      else
        @rooms = Room.none
        flash[:alert] = "指定されたエリア名は無効です。"
      end
    elsif params[:keyword].present?
      @rooms = Room.where(["title LIKE ? OR description LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%"])
    else
      @rooms = Room.all
    end
  end
  

  private

 

  def room_params
    params.require(:room).permit(:name, :description, :price, :address, :image)
  end
end
