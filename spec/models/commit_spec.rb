require 'rails_helper'

RSpec.describe Commit, type: :model do
  it { is_expected.to belong_to(:repository) }
end
