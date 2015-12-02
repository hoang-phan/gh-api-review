require 'rails_helper'

RSpec.describe RepositoriesFetch do
  include RepositoryMacro

  describe '#perform' do
    let(:fake_client) { double(repositories: repositories) }
    let(:repositories) { JSON(File.read("#{Rails.root}/spec/fixtures/repos.json")) }

    before do
      $client = fake_client
      subject.perform
    end

    it 'fetch all repositories' do
      repositories.each do |repo|
        expect(match_local(repo)).to be_truthy
      end
    end
  end
end