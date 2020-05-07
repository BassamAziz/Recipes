# frozen_string_literal: true

module RecipesHelper
  def markdown
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end
end
