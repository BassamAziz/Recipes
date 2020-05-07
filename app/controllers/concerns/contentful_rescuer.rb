# frozen_string_literal: true

module ContentfulRescuer
  extend ActiveSupport::Concern

  included do
    rescue_from 'Contentful::Error' do |_exception|
      render file: 'public/422.html', status: 422, layout: false
    end
  end
end
