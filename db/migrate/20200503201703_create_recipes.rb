# frozen_string_literal: true

class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes, &:timestamps
  end
end
