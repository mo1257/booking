class RoomsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]

  def home
    @q = Room.ransack(params[:q])
    @results = @q.result
  end

  def index
    @rooms = current_user.rooms
  end

  def show
    @room = Room.find_by(id: params[:id])
    if @room.nil?
      redirect_to rooms_path, alert: '施設が見つかりません。'
    else
      @formatted_created_at = @room.created_at.to_s(:custom)
      @reservations = Reservation.new
      @reviews = @room.reviews
    end
  end

  def new
    @room = current_user.rooms.new
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
    @q = Room.ransack(params[:q])
    valid_areas = ["東京", "大阪", "京都", "札幌"]

    area = params.dig(:q, :address_cont)
    name = params.dig(:q, :info_cont)

    if area.present?
      if valid_areas.include?(area)
        @results = @q.result
      else
        @results = Room.none
        flash[:alert] = "指定されたエリア名は無効です。"
      end
    elsif name.present?
      @results = @q.result
    else
      @results = Room.all
    end
  end

  private

  def room_params
    params.require(:room).permit(:name, :description, :price, :location, :address, :info)
  end
end
