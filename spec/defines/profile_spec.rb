# frozen_string_literal: true

require 'spec_helper'

describe 'tuned::profile' do
  let(:title) { 'performance' }
  let(:pre_condition) { 'include tuned' }
  let(:params) do
    {}
  end

  it { is_expected.to compile }
end
