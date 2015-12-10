require 'rails_helper'

RSpec.describe Repository, type: :model do
  it { is_expected.to have_many(:branches) }
  it { is_expected.to have_many(:commits) }

  it_behaves_like 'sortable by id'
  it_behaves_like 'watchable'
end
