class ReservationsController < ApplicationController

  # 予約済み一覧
  def list
  def index
    @user = current_user
    @reservations = current_user.reservations
  end

  def new
    @reservations = Reservation.new
  end

  def create
    @rooms = Room.find(params[:reservation][:room_id])
    @users = current_user.id
    @reservations = current_user.reservations.new(reservation_params)
    if @reservations.save
      redirect_to :reservations
    else
      render 'rooms/show'
    end
  end

  # 予約内容確認
  def confirmation
    @reservations = current_user.reservations.new(reservation_params)
    @rooms = Room.find(params[:reservation][:room_id])
    if @reservations.check_in == nil
      flash[:alert] = "チェックイン日を入れてください"
      render 'rooms/show' and return
    end
    if @reservations.check_out == nil
      flash[:alert] = "チェックアウト日を入れてください"
      render 'rooms/show' and return
    end
    if @reservations.check_out < @reservations.check_in
      flash[:alert] = "終了日は開始日以降の日付にしてください"
      render 'rooms/show' and return
    end
    if @reservations.people == nil
      flash[:alert] = "人数は必須項目です"
      render 'rooms/show' and return
    end
    @reservations.count_day = @reservations.check_out - @reservations.check_in
    @reservations.sum_price = ( @reservations.count_day * @rooms.room_price ) * @reservations.people
  end

  def reservation_params
    params.require(:reservation).permit(:check_in, :check_out, :people, :count_day, :sum_price, :user_id, :room_id)
  end

end
