# frozen_string_literal: true

require 'spec_helper_acceptance'
require 'pry'

describe 'tuned' do
  context 'basic setup' do
    it 'install tuned' do
      pp = <<~EOS
        class { 'tuned': }
      EOS

      # first run seems to exit with code 6 (systemd reload)
      apply_manifest(pp, catch_failures: false)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/etc/tuned') do
      it { is_expected.to be_directory }
      it { is_expected.to be_readable.by('owner') }
    end

    describe file('/etc/tuned/tuned-main.conf') do
      it { is_expected.to be_file }
      it { is_expected.to be_readable.by('owner') }
      it { is_expected.to be_readable.by('group') }
    end

    describe service('tuned') do
      it { is_expected.to be_running }
    end
  end
end
