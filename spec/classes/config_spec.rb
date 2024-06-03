# frozen_string_literal: true

require 'spec_helper'

describe 'tuned::config' do
  _, os_facts = on_supported_os.first
  let(:facts) { os_facts }

  it { is_expected.to compile.with_all_deps }
end
