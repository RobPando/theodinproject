class FlightsController < ApplicationController
  before_action :set_flight, only: [:show, :edit, :update, :destroy]

  # GET /flights
  # GET /flights.json
  def index
    @airports = Airport.all.map { |a| [a.name, a.id] }
    @passengers = (1..4).to_a    

    if params[:search]
      @number_of_passengers = params[:search][:passengers]
      date = "#{params[:search][:date]['date(3i)']}/"\
             "#{params[:search][:date]['date(2i)']}/"\
             "#{params[:search][:date]['date(1i)']}"
      @flights = Flight.get_flights(params[:search][:from],
                 params[:search][:to], DateTime.parse(date))
      @active_form = true
    else
      if params[:sort] || session[:sort] 
        session[:sort] = params[:sort] if params[:sort]
        @flights = Flight.all.order(session[:sort], :date)
      else
        @flights = Flight.all.order(:date)
        session[:sort] = nil
      end
      @active_form = false
    end 
  end

  # GET /flights/1
  # GET /flights/1.json
  def show
  end

  # GET /flights/new
  def new
    @flight = Flight.new
  end

  # GET /flights/1/edit
  def edit
  end

  # POST /flights
  # POST /flights.json
  def create
    @flight = Flight.new(flight_params)

    respond_to do |format|
      if @flight.save
        format.html { redirect_to @flight, notice: 'Flight was successfully created.' }
        format.json { render action: 'show', status: :created, location: @flight }
      else
        format.html { render action: 'new' }
        format.json { render json: @flight.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flights/1
  # PATCH/PUT /flights/1.json
  def update
    respond_to do |format|
      if @flight.update(flight_params)
        format.html { redirect_to @flight, notice: 'Flight was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @flight.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flights/1
  # DELETE /flights/1.json
  def destroy
    @flight.destroy
    respond_to do |format|
      format.html { redirect_to flights_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flight
      @flight = Flight.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def flight_params
      params.require(:flight).permit(:departure_airport, :arrival_airport, :date, :duration)
    end
end
