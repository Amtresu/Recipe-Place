class RecipeFoodsController < ApplicationController
  #  before_action :set_recipe_food, only: %i[show edit update destroy]

  # GET /recipe_foods or /recipe_foods.json
  def index
    @recipe = Recipe.find(params[:recipe_id])
    @food = Food.find(params[:food_id])
    @recipe_foods = unused_foods
  end

  # GET /recipe_foods/1 or /recipe_foods/1.json
  def show; end

  # GET /recipe_foods/new
  def new
    @recipe_food = RecipeFood.new
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_foods = unused_foods
  end

  # GET /recipe_foods/1/edit
  def edit
    @recipe = Recipe.find(params[:id])
    @recipe_food = RecipeFood.find(params[:id])
  end

  # POST /recipe_foods or /recipe_foods.json
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_food = RecipeFood.new(recipe_id: @recipe.id, food_id: recipe_food_params[:food_id],
                                  quantity: recipe_food_params[:quantity])
    if @recipe_food.save
      flash[:notice] = 'Food is successfully added!'
      redirect_to recipe_path(@recipe)
    else
      flash[:notice] = 'Invalid Entry'
      redirect_to current_path
    end
  end

  # DELETE /recipe_foods/1 or /recipe_foods/1.json
  def destroy
    @recipe_food = RecipeFood.find(params[:id])
    @recipe_food.destroy

    respond_to do |format|
      format.html { redirect_to recipes_path, notice: 'Recipe food was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  # Only allow a list of trusted parameters through.
  def recipe_food_params
    params.require(:recipe_food).permit(:quantity, :recipe_id, :food_id)
  end

  def unused_foods
    total_foods = current_user.foods
    total_recipe_foods = []
    current_user.recipes.includes(:recipe_foods).each do |recipe|
      recipe.recipe_foods.includes(:food).each do |recipe_food|
        total_recipe_foods << recipe_food.food
      end
    end
    total_foods - total_recipe_foods
  end
end
