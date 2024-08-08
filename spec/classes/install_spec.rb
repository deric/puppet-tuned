# frozen_string_literal: true

require 'spec_helper'

describe 'tuned::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include tuned' }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('tuned').with_ensure(%r{present|installed}) }
    end
  end
end
