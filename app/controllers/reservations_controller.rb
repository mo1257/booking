class ReservationsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create, :update, :index, :edit]
  
    def index
      @reservations = Reservation.all
    end
  
    def new
      @reservation = Reservation.new
    end
  
    def create
      @reservation = current_user.reservations.build(reservation_params)
      if @reservation.save
        redirect_to @reservation, notice: 'Reservation was successfully created.'
      else
        render :new
      end
    end
  
    def show
      @reservation = Reservation.find(params[:id])
    end
  
    def edit
      @reservation = Reservation.find(params[:id])
    end
  
    def update
      @reservation = Reservation.find(params[:id])
      if @reservation.update(reservation_params)
        redirect_to @reservation, notice: 'Reservation was successfully updated.'
      else
        render :edit
      end
    end
  
    protected
  
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :current_password])
    end
  
    def after_update_path_for(resource)
      user_path(resource)
    end
  
    private
  
    def reservation_params
      params.require(:reservation).permit(:room_id, :start_date, :end_date)
    end
  end

