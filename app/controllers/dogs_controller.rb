class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy]
  before_action :set_current_page, :set_page_sort_by, only: [:index]
  before_action :authenticateUpdate, only: [:update]
  before_action :authenticateOwner, only: [:destroy]

  # GET /dogs
  # GET /dogs.json
  def index
    @dogs_per_page = 5
    @dogs = Dog.limit(@dogs_per_page).offset((@page - 1) * @dogs_per_page)
    @dogs_total = Dog.count

    @page_sort_by
    dogs = Dog.where('updated_at > ?', 24.hours.ago)

  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show

  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    return redirect_to root_path if current_user.nil?

    @dog = Dog.new(dog_params)
    @dog.owner = current_user

    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|

      if @dog.update(dog_params)
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dog
    @dog = Dog.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dog_params
    params.require(:dog).permit(:name, :description, :images, :likes)
  end

  def set_current_page
    @page = (params[:page] || 1).to_i
  end

  def set_page_sort_by
    @page_sort_by = (params[:sort] || 'default')
  end

  def authenticateOwner
    if @dog.owner != current_user
      redirect_to dog_path(@dog), alert: "Only owner are allow to edit"
    end
  end

  def authenticateUpdate
    if (dog_params[:likes].present? && @dog.owner == current_user)
      redirect_to dog_path(@dog), alert: "Owner can not 'like' their own dog"
    end
  end
end
