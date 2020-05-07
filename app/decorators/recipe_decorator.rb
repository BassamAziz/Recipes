# frozen_string_literal: true

class RecipeDecorator < Draper::Decorator
  delegate_all

  def photo_url
    photo&.url
  end

  def parsed_description
    helpers.markdown.render(description).html_safe
  end

  def chef_name
    chef&.name
  end

  private

  def self.collection_decorator_class
    PaginationDecorator
  end
end
