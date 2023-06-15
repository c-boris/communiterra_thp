class PlantSittingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plant_sitting, only: %i[show edit update destroy]

  def index
    @plant_sittings = PlantSitting.all
    @kept_plants = KeptPlant.where("end_date >= ?", Date.today).group_by(&:user_id)
  end

  def index_current_user
    @plant_sittings = current_user.plant_sittings
  end

  def show
    @plant_sittings = current_user.plant_sittings
  end

  def new
    @plant_sitting = PlantSitting.new
  end

  def edit
  end

  def create
    @kept_plants = KeptPlant.where("end_date >= ?", Date.today).group_by(&:user_id)
    @plantsittings = []
  
    @kept_plants.each do |kept_plant|
      if params[:plantsitting] && params[:plantsitting][:kept_plant_ids].include?(kept_plant.id.to_s)
        plantsitting_params_with_attributes = plantsitting_params.merge(
          kept_plant_id: kept_plant.id
        )
        @plantsittings << PlantSitting.new(plantsitting_params_with_attributes)
      end
    end
  
    respond_to do |format|
      if @plantsittings.all?(&:save)
        format.html { redirect_to plant_sittings_url, notice: "Les gardes de plantes ont été créées avec succès." }
        format.json { render :index, status: :created, location: plant_sittings_url }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @plantsittings.map(&:errors), status: :unprocessable_entity }
      end
    end
  end
  
  
  
  
  


  def update
    respond_to do |format|
      if @plant_sitting.update(plant_sitting_params)
        format.html { redirect_to plant_sitting_url(@plant_sitting), notice: "Plant sitting was successfully updated." }
        format.json { render :show, status: :ok, location: @plant_sitting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @plant_sitting.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @plant_sitting.destroy

    respond_to do |format|
      format.html { redirect_to plant_sittings_url, notice: "Plant sitting was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_plant_sitting
    @plant_sitting = PlantSitting.find(params[:id])
  end

  def plant_sitting_params
    params.require(:plant_sitting).permit(:user_id, kept_plant_ids: [])
  end
end
