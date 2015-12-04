require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#bootstrap_class_for' do
    subject { helper.bootstrap_class_for(flash_type) }
    let(:flash_type) { 'other' }

    context 'flash_type is error' do
      let(:flash_type) { described_class::TYPE_ERROR }
      it { is_expected.to eq 'alert-error' }
    end

    context 'flash_type is notice' do
      let(:flash_type) { described_class::TYPE_NOTICE }
      it { is_expected.to eq 'alert-info' }
    end

    context 'otherwise' do
      it { is_expected.to eq flash_type.to_s }
    end
  end
end
