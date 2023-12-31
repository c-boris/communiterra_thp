class LogBooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_owned_plant
  before_action :set_log_book, only: [:edit, :update, :destroy]
  before_action :check_security, only: [:new, :create, :edit, :update, :destroy]

  def index
    @owned_plant = OwnedPlant.find(params[:owned_plant_id])
    @log_books = @owned_plant.log_books
  end

  def show
    @log_book = LogBook.find(params[:id])
  end
  

  def new
    @log_book = @owned_plant.log_books.build
  end

  def create
    @log_book = @owned_plant.log_books.build(log_book_params)
    if @log_book.save
      redirect_to owned_plant_log_books_path(@owned_plant), notice: "L'entrée du journal de bord a été créée avec succès."
    else
      render :new
    end
  end

  def edit
    @log_book = LogBook.find(params[:id])
  end

  def update
    if @log_book.update(log_book_params)
      redirect_to owned_plant_log_books_path(@owned_plant), notice: "L'entrée du journal de bord a été mise à jour avec succès."
    else
      render :edit
    end
  end

  def destroy
    @log_book = LogBook.find(params[:id])
    @log_book.destroy
    redirect_to owned_plant_log_books_path(@owned_plant), notice: "L'entrée du journal de bord a été supprimée avec succès."
  end
  

  private

  def set_owned_plant
    @owned_plant = OwnedPlant.find(params[:owned_plant_id])
  end

  def set_log_book
    @log_book = @owned_plant.log_books.find(params[:id])
  end

  def log_book_params
    params.require(:log_book).permit(:entry_date, :title, :content, :watered, :mood)
  end

  def check_security
    if !current_user.plant_sittings.exists?(sitter_id: current_user.id) &&
       !(@owned_plant.allotment_id.present? && Allotment.find_by(id: @owned_plant.allotment_id)&.admin_id == current_user.id) &&
       !@owned_plant.allotment_id.present? &&
       @owned_plant.user != current_user
      redirect_to root_path, alert: "Vous n'avez pas les autorisations nécessaires pour effectuer cette action."
    end
  end  
end
