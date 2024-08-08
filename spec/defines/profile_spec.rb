# frozen_string_literal: true

require 'spec_helper'

describe 'tuned::profile' do
  let(:title) { 'performance' }
  let(:pre_condition) { 'include tuned' }
  let(:params) do
    {}
  end

  _, os_facts = on_supported_os.first
  let(:facts) { os_facts }

  it { is_expected.to compile }
end
