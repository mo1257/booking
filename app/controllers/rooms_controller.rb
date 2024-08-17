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
    valid_areas = ["東京", "大阪", "京都", "札幌"]
    @q = Room.ransack(params[:q])

    # エリアを取得し、パラメータから取得する
    area = params[:location] || params.dig(:q, :address_cont)
    name_or_description = params.dig(:q, :name_or_description_cont)

    if area.present? && valid_areas.include?(area)
      # エリア検索：指定された有効なエリアに基づいて検索
      @results = @q.result(distinct: true).where("address LIKE ?", "%#{area}%")
    elsif area.present? && !valid_areas.include?(area)
      # エリアが無効な場合は空の結果を返す
      @results = Room.none
      flash[:alert] = "指定されたエリア名は無効です。"
    elsif name_or_description.present?
      # フリーワード検索：施設名または施設詳細に基づく検索
      @results = @q.result(distinct: true).where("name LIKE ? OR description LIKE ?", "%#{name_or_description}%", "%#{name_or_description}%")
    else
      # エリアもフリーワードも指定されていない場合、すべての施設を返す
      @results = Room.all
    end
  end
  
  private

  def room_params
    params.require(:room).permit(:name, :description, :price, :location, :address, :info, :image)
  end
end
