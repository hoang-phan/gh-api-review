require 'rails_helper'

RSpec.describe SnippetsController, type: :controller do

  describe "GET index" do
    let(:json) { JSON.parse(response.body) }

    it "returns all snippets" do
      get :index
      expect(response).to be_success
      expect(json['snippets']).to eq ALL_SNIPPETS
    end
  end
end
