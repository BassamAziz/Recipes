# frozen_string_literal: true

class PaginationDecorator < Draper::CollectionDecorator
  def current_page
    ((object.skip.to_f / object.limit) + 1).to_i
  end

  def total_pages
    (object.total.to_f / object.limit).ceil.to_i
  end

  def limit_value
    object.limit
  end
end
