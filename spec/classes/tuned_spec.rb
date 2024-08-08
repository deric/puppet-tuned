# frozen_string_literal: true

require 'spec_helper'

describe 'tuned' do
  _, os_facts = on_supported_os.first
  let(:facts) { os_facts }

  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('tuned') }
  it { is_expected.to contain_package('tuned').with_ensure(%r{present|installed}) }
  it { is_expected.to contain_service('tuned').with_ensure(%r{running}) }

  context 'when installing multiple packages' do
    let(:params) do
      {
        main: {
          update_interval: 20,
          sleep_interval: 2,
        }
      }
    end

    it { is_expected.to contain_class('tuned::config') }
    it {
      is_expected.to contain_ini_setting('tuned-update_interval')
        .with({
                setting: 'update_interval',
                value: 20,
                path: '/etc/tuned/tuned-main.conf',
              })
    }

    it {
      is_expected.to contain_ini_setting('tuned-sleep_interval')
        .with({
                setting: 'sleep_interval',
                value: 2,
                path: '/etc/tuned/tuned-main.conf',
              })
    }
  end
end
