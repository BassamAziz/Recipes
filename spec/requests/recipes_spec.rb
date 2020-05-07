# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  let(:base_url) { 'https://cdn.contentful.com' }

  before do
    ENV['CONTENTFUL_ACCESS_TOKEN'] = 'TEST_ACCESS_TOKEN'
    ENV['CONTENTFUL_SPACE_ID'] = 'TEST_SPACE_ID'

    stub_request(:get, "#{base_url}/spaces/TEST_SPACE_ID/environments/master/content_types?limit=1000")
      .with(
        headers: {
          'Authorization' => 'Bearer TEST_ACCESS_TOKEN'
        }
      ).to_return(status: 200, body: '{
          "sys": {
            "type": "Array"
          },
          "items": []
        }')
  end

  describe 'GET /recipes' do
    context 'when requested with any params' do
      let!(:recipes_stub_request) do
        stub_request(:get, 'https://cdn.contentful.com/spaces/TEST_SPACE_ID/environments/master/entries?content_type=recipe&limit=2&skip=0')
          .with(
            headers: {
              'Authorization' => 'Bearer TEST_ACCESS_TOKEN'
            }
          )
          .to_return(status: 200, body: File.read(File.expand_path('../support/stubbed_responses/recipes_page_1.json', __dir__)))
      end

      before do
        get '/recipes'
      end

      it 'retrieves the recipes from the contentful delivery API' do
        expect(recipes_stub_request).to have_been_requested
      end

      it 'returns first page of recipes by default' do
        expect(assigns(:recipes).count).to eq(2)
        expect(assigns(:recipes).current_page).to eq(1)
      end
    end

    context 'when requested with a specific page param' do
      let!(:recipes_stub_request) do
        stub_request(:get, 'https://cdn.contentful.com/spaces/TEST_SPACE_ID/environments/master/entries?content_type=recipe&limit=2&skip=2')
          .with(
            headers: {
              'Authorization' => 'Bearer TEST_ACCESS_TOKEN'
            }
          )
          .to_return(status: 200, body: File.read(File.expand_path('../support/stubbed_responses/recipes_page_2.json', __dir__)))
      end

      it 'paginates recipes' do
        get '/recipes?page=2'
        expect(recipes_stub_request).to have_been_requested

        expect(assigns(:recipes).object.skip).to eq(2)
      end
    end

    context 'when contentful delivery Api returns an error' do
      let!(:error_stub_request) do
        stub_request(:get, 'https://cdn.contentful.com/spaces/TEST_SPACE_ID/environments/master/entries?content_type=recipe&limit=2&skip=0')
          .with(
            headers: {
              'Authorization' => 'Bearer TEST_ACCESS_TOKEN'
            }
          )
          .to_return(status: 400, body: File.read(File.expand_path('../support/stubbed_responses/error.json', __dir__)))
      end
      it 'renders a 422 http error' do
        get '/recipes'

        expect(error_stub_request).to have_been_requested
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /recipes/:id' do
    let(:recipe_id) { '437eO3ORCME46i02SeCW46' }

    let!(:recipe_stub_request) do
      stub_request(:get, "https://cdn.contentful.com/spaces/TEST_SPACE_ID/environments/master/entries?content_type=recipe&sys.id=#{recipe_id}")
        .with(
          headers: {
            'Authorization' => 'Bearer TEST_ACCESS_TOKEN'
          }
        )
        .to_return(status: 200, body: File.read(File.expand_path('../support/stubbed_responses/recipe.json', __dir__)))
    end

    let(:recipe_response) { JSON.parse File.read(File.expand_path('../support/stubbed_responses/recipe.json', __dir__)) }
    let(:expected_recipe) { recipe_response['items'][0]['fields'] }

    it 'fetches a single recipe from the contentful delivery Api' do
      get "/recipes/#{recipe_id}"

      recipe = assigns(:recipe)

      expect(recipe.title).to eq expected_recipe['title']
      expect(recipe.description).to eq expected_recipe['description']
      expect(recipe.photo_url).to eq recipe_response['includes']['Asset'][0]['fields']['file']['url']
      expect(recipe.chef_name).to eq recipe_response['includes']['Entry'][1]['fields']['name']
    end
  end
end
