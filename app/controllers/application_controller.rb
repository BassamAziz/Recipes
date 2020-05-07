# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def contentful
    Contentful::Client.new(
      access_token: ENV['CONTENTFUL_ACCESS_TOKEN'],
      space: ENV['CONTENTFUL_SPACE_ID'],
      dynamic_entries: :auto,
      raise_errors: true,
      raise_for_empty_fields: false
    )
  end
end
