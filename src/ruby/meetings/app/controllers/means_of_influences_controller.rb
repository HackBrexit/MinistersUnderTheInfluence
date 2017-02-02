class MeansOfInfluencesController < ApplicationController
  before_action :set_type
  before_action :set_means_of_influence, only: [:show, :edit, :update, :destroy]

  # GET /means_of_influences
  # GET /means_of_influences.json
  def index
    @means_of_influences = type_class.all
  end

  # GET /means_of_influences/1
  # GET /means_of_influences/1.json
  def show
  end

  # GET /means_of_influences/new
  def new
    @means_of_influence = type_class.new
  end

  # GET /means_of_influences/1/edit
  def edit
  end

  # POST /means_of_influences
  # POST /means_of_influences.json
  def create
    @means_of_influence = type_class.new(means_of_influence_params)

    respond_to do |format|
      if @means_of_influence.save
        format.html { redirect_to @means_of_influence, notice: 'Means of influence was successfully created.' }
        format.json { render :show, status: :created, location: @means_of_influence }
      else
        format.html { render :new }
        format.json { render json: @means_of_influence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /means_of_influences/1
  # PATCH/PUT /means_of_influences/1.json
  def update
    respond_to do |format|
      if @means_of_influence.update(means_of_influence_params)
        format.html { redirect_to @means_of_influence, notice: 'Means of influence was successfully updated.' }
        format.json { render :show, status: :ok, location: @means_of_influence }
      else
        format.html { render :edit }
        format.json { render json: @means_of_influence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /means_of_influences/1
  # DELETE /means_of_influences/1.json
  def destroy
    @means_of_influence.destroy
    respond_to do |format|
      format.html { redirect_to means_of_influences_url, notice: 'Means of influence was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_type
    @type = type
  end

  def type
    params[:type] || "MeansOfInfluence"
  end

  def type_class
    @type_class = type.constantize
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_means_of_influence
    @means_of_influence = type_class.find(params[:id]).decorate
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def means_of_influence_params
    params.
      require(:means_of_influence).
      permit(:type, :day, :month, :year, :purpose, :type_of_hospitality,
             :gift, :value, :source_file_id, :source_file_line_number)
  end
end
