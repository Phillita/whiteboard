class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  # GET /tickets
  # GET /tickets.json
  def index
    if params[:board_id].present?
      @tickets = Ticket.where(board_id: params[:board_id])
    else
      @tickets = Ticket.all
    end

    respond_to do |format|
      format.html 
      format.json do
        render :json => @tickets.to_json(:include => { :column => { :only => :order }, :row => { :only => :order }})
      end
    end
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ticket }
      else
        format.html { render action: 'new' }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url }
      format.json { head :no_content }
    end
  end

  # POST /tickets/id/update_cols_and_rows
  def update_cols_and_rows
    ticket = Ticket.find(params["id"])
    ticket.row = ticket.board.rows.where(order: params["row"]).first
    ticket.column = ticket.board.columns.where(order: params["column"]).first
    respond_to do |format|
      if ticket.save
        format.json { render json: ticket, :msg=>"Ticket was successfully updated." }
      else
          format.json  { render json: ticket.errors, :status => :unprocessable_entity }
      end
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit(:story, :pithy_tag, :description, :requirements_points, :development_points, :board_id, :column_id, :row_id)
    end
end
