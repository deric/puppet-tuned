# frozen_string_literal: true

require 'spec_helper'

describe 'tuned' do
  _, os_facts = on_supported_os.first
  let(:facts) { os_facts }

  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('tuned') }
  it { is_expected.to contain_package('tuned').with_ensure(%r{present|installed}) }
  it { is_expected.to contain_service('tuned').with_ensure(%r{running}) }
end
