require 'rails_helper'

RSpec.describe Branch, type: :model do
  it { is_expected.to belong_to(:repository) }
end
