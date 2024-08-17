class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:show, :edit, :update, :confirmation, :confirm, :destroy]

  # 予約済み一覧
  def index
    @reservations = current_user.reservations.includes(:room)
  end

  def new
    @reservation = Reservation.new
  end

  def create
    @room = Room.find(params[:reservation][:room_id])
    @reservation = current_user.reservations.new(reservation_params)
    @reservation.room = @room

    if @reservation.save
      redirect_to confirmation_reservation_path(@reservation)
    else
      render 'rooms/show'
    end
  end

  def edit
    # @reservation は before_action で設定されます
  end

  def update
    if @reservation.update(reservation_params)
      redirect_to @reservation, notice: '予約が更新されました。'
    else
      render :edit
    end
  end

  # 予約内容確認
  def confirmation

    @room = @reservation.room

    if @reservation.check_in.nil?
      flash[:alert] = "チェックイン日を入力してください。"
      redirect_to edit_reservation_path(@reservation) and return
    end
      
    if @reservation.check_in > Time.zone.today
      flash[:alert] = "チェックイン日は本日以降の日付にしてください。"
      redirect_to edit_reservation_path(@reservation) and return
    end

    if @reservation.check_out.nil?
      flash[:alert] = "チェックアウト日を入力してください。"
      redirect_to edit_reservation_path(@reservation) and return
    end

    # チェックアウト日がチェックイン日より前または同じ場合の処理を分ける
  if @reservation.check_out < @reservation.check_in
    flash[:alert] = "チェックアウト日はチェックイン日以降の日付にしてください。"
    redirect_to edit_reservation_path(@reservation) and return
  elsif @reservation.check_out == @reservation.check_in
    flash[:alert] = "チェックアウト日はチェックイン日と異なる日付にしてください。"
    render 'rooms/show' and return
  end

    if @reservation.people.nil?
      flash[:alert] = "人数を入力してください。"
      redirect_to edit_reservation_path(@reservation) and return
    end

    @reservation.count_day = @reservation.calculate_count_day
  @reservation.sum_price = @reservation.calculate_sum_price
    
  end

  def confirm
    if @reservation.update(confirmed: true, confirmation_date: Time.current)
      redirect_to reservations_path, notice: '予約が確定されました。'
    else
      flash[:alert] = "予約の確定に失敗しました。"
      render :confirmation
    end
  end

  def destroy
    if @reservation.destroy
      redirect_to reservations_path, notice: '予約をキャンセルしました。'
    else
      redirect_to reservations_path, alert: '予約のキャンセルに失敗しました。'
    end
  end
  


  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:check_in, :check_out, :people, :room_id)
  end
end
