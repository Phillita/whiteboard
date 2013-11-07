class RowsController < ApplicationController
  # before_action :set_row, only: [:show, :edit, :update, :destroy]

  # GET /rows
  # GET /rows.json
  def index
    if params[:board_id].present?
      @rows = Row.where(board_id: params[:board_id])
    else
      @rows = Row.all
    end

    respond_to do |format|
      format.html 
      format.json do
        render :json => @rows.to_json()
      end
    end
  end

  # # GET /rows/1
  # # GET /rows/1.json
  # def show
  # end

  # # GET /rows/new
  # def new
  #   @row = Row.new
  # end

  # # GET /rows/1/edit
  # def edit
  # end

  # # POST /rows
  # # POST /rows.json
  # def create
  #   @row = Row.new(row_params)

  #   respond_to do |format|
  #     if @row.save
  #       format.html { redirect_to @row, notice: 'Row was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @row }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @row.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PATCH/PUT /rows/1
  # # PATCH/PUT /rows/1.json
  # def update
  #   respond_to do |format|
  #     if @row.update(row_params)
  #       format.html { redirect_to @row, notice: 'Row was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @row.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /rows/1
  # # DELETE /rows/1.json
  # def destroy
  #   @row.destroy
  #   respond_to do |format|
  #     format.html { redirect_to rows_url }
  #     format.json { head :no_content }
  #   end
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_row
  #     @row = Row.find(params[:id])
  #   end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  #   def row_params
  #     params.require(:row).permit(:board_id, :order, :label)
  #   end
end
