require 'rails_helper'

RSpec.describe Branch, type: :model do
  it { is_expected.to belong_to(:repository) }

  it_behaves_like 'sortable by id'
  it_behaves_like 'watchable'
end
