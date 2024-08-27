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

  context 'with profiles' do
    let(:params) do
      {
        profile: 'hpc',
        profiles: {
          hpc: {
            main: {
              include: 'latency-performance'
            },
            sysctl: {
              'net.ipv4.tcp_fastopen': 3,
            },
          },
          basic: {
            main: {
              include: 'balanced'
            },
          },
        }
      }
    end

    it { is_expected.to contain_class('tuned::install').that_comes_before('Class[tuned::config]') }
    it { is_expected.to contain_tuned__profile('hpc') }
    it { is_expected.to contain_tuned__profile('basic') }
    it { is_expected.to contain_exec('tuned-adm_profile').that_requires('Class[tuned::config]') }

    it { is_expected.to contain_file('/etc/tuned/hpc').with_ensure('directory') }
    it { is_expected.to contain_file('/etc/tuned/basic').with_ensure('directory') }

    it { is_expected.to contain_file('/etc/tuned/hpc/tuned.conf').with_content(%r{^\[main\]\ninclude = latency-performance$}) }
    it { is_expected.to contain_file('/etc/tuned/hpc/tuned.conf').with_content(%r{^\[sysctl\]\nnet.ipv4.tcp_fastopen = 3$}) }
    it { is_expected.to contain_file('/etc/tuned/basic/tuned.conf').with_content(%r{^\[main\]\ninclude = balanced$}) }
  end
end
