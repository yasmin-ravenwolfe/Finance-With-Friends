class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @group = Group.find params[:group_id]
    @category = @group.categories.new
  end

  # GET /categories/1/edit
  def edit
    @group = @category.group
  end

  # POST /categories
  # POST /categories.json
  def create
    @group = Group.find params[:group_id]
    @category = @group.categories.new
    @category.title = params[:category][:title]

    respond_to do |format|
      if @category.save
        format.html { redirect_to group_path(@group) }
        format.json { head :no_content }
        format.js { render layout: false }
      else
        format.html { render action: 'new' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    @group = @category.group
    respond_to do |format|
      if @category.update(title: params[:category][:title])
        format.html { redirect_to group_path(@group), notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @group = @category.group
    @category.destroy
    respond_to do |format|
      format.html { render nothing: true }
      format.json { head :no_content }
      format.js { render layout: false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(category: [ :title ])
    end
end
