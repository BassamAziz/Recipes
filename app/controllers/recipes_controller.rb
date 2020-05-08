# frozen_string_literal: true

class RecipesController < ApplicationController
  include ContentfulRescuer

  CONTENT_TYPE = 'recipe'
  PER_PAGE = 2

  def index
    @recipes = RecipeDecorator.decorate_collection(recipes)
  end

  def show
    if recipe.present?
      @recipe = RecipeDecorator.decorate(recipe)
    else
      render file: 'public/404.html', status: :not_found, layout: false
    end
  end

  private

  def recipe
    if params[:id].present?
      contentful.entry(params[:id], content_type: CONTENT_TYPE)
    end
  end

  def recipes
    contentful.entries(content_type: CONTENT_TYPE, limit: PER_PAGE, skip: skipped)
  end

  def skipped
    PER_PAGE * current_page
  end

  def current_page
    if params[:page].present?
      params[:page].to_i - 1
    else
      0
    end
  end
end
