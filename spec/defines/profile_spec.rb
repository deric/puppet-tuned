# frozen_string_literal: true

require 'spec_helper'

describe 'tuned::profile' do
  let(:title) { 'performance' }
  let(:pre_condition) { 'include tuned' }
  let(:params) do
    {}
  end

  it { is_expected.to compile }
  it { is_expected.to contain_tuned__profile('performance') }

  it { is_expected.to contain_file('/etc/tuned/performance').with_ensure('directory') }

  it { is_expected.to contain_file('/etc/tuned/performance/tuned.conf') }
end
