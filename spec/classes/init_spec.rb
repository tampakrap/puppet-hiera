require 'spec_helper'

shared_examples_for 'everywhere' do
  it { should contain_class('hiera') }
  it { should compile.with_all_deps }
  it { should contain_class('hiera::package') }
  it { should contain_package('hiera') }
end

describe 'hiera' do
  let(:facts) { { :operatingsystem => 'openSUSE' } }

  context "when using defaults" do
    it_behaves_like 'everywhere'
    it { should_not contain_package('hiera-gpg') }
    it { should_not contain_package('hiera-eyaml') }
    it { should_not contain_package('hiera-eyaml-gpg') }
    it { should contain_file('/etc/puppet/hiera.yaml').with_content("---\n:backends:\n  - yaml\n:yaml:\n  :datadir: /etc/puppet/hieradata\n") }
    it { should contain_file('/etc/hiera.yaml').with(
      :ensure => 'link',
      :target => '/etc/puppet/hiera.yaml',
    )}
  end

  [true, false].each do |config_link|
    context "when specifying custom config_path" do
      context "when config_link => #{config_link}" do
        let(:params) do
          {
            :config_path => '/etc/somewhere/else/hiera.yaml',
            :config_link => config_link,
          }
        end
        it_behaves_like 'everywhere'
        it { should contain_file('/etc/somewhere/else/hiera.yaml') }
        it {
          is_expected.to contain_file('/etc/hiera.yaml').with_target('/etc/somewhere/else/hiera.yaml') if config_link == true
          is_expected.to_not contain_file('/etc/hiera.yaml') if config_link == false
        }
      end
    end
  end

  ['native', 'deep', 'deeper'].each do |merge_behavior|
    context "when specifying #{merge_behavior} merge_behavior" do
      let(:params) { {:merge_behavior => merge_behavior} }
      it_behaves_like 'everywhere'
      it { should contain_file('/etc/puppet/hiera.yaml').with_content("---\n:backends:\n  - yaml\n:yaml:\n  :datadir: /etc/puppet/hieradata\n:merge_behavior: #{merge_behavior}\n") }
      it {
        is_expected.to contain_package('deep_merge') if merge_behavior == 'deep'
        is_expected.to contain_package('deep_merge') if merge_behavior == 'deeper'
        is_expected.to_not contain_package('deep_merge') if merge_behavior == 'native'
      }
    end
  end

  context "when specifying hierarchy" do
    let(:params) { {:hierarchy => ['common']} }
    it_behaves_like 'everywhere'
    it { should contain_file('/etc/puppet/hiera.yaml').with_content("---\n:backends:\n  - yaml\n:yaml:\n  :datadir: /etc/puppet/hieradata\n:hierarchy:\n  - common\n") }

    context "when using the percent hack" do
      let(:params) { {:hierarchy => ['is_virtual/_percent_{::is_virtual}', 'common']} }
      it { should contain_file('/etc/puppet/hiera.yaml').with_content("---\n:backends:\n  - yaml\n:yaml:\n  :datadir: /etc/puppet/hieradata\n:hierarchy:\n  - \"is_virtual/%{::is_virtual}\"\n  - common\n") }
    end
  end

  [true, false].each do |restart_puppetmaster|
    context "when restart_puppetmaster => #{restart_puppetmaster}" do
      let(:params) { {:restart_puppetmaster => restart_puppetmaster} }
      it_behaves_like 'everywhere'
      it { should contain_class('puppet::server') } if restart_puppetmaster == true
      it { should contain_file('/etc/puppet/hiera.yaml').that_notifies(['Service[puppetmaster]']) } if restart_puppetmaster == true
      it { should_not contain_file('/etc/puppet/hiera.yaml').that_notifies(['Service[puppetmaster]']) } if restart_puppetmaster == false
    end
  end

  context "when specifying backend" do
    context "when using the percent hack" do
      let(:params) { {:backends => {'yaml' => {'datadir' => '/etc/puppet/environments/_percent_{::environment}/hieradata'} } } }
      it_behaves_like 'everywhere'
      it { should contain_file('/etc/puppet/hiera.yaml').with_content("---\n:backends:\n  - yaml\n:yaml:\n  :datadir: /etc/puppet/environments/%{::environment}/hieradata\n") }
    end

    context "when specifying additional data for one backend" do
      let(:params) { {:backends => {'yaml' => {
        'datadir' => '/etc/puppet/hieradata',
        'additional' => 'something'
      } } } }
      it_behaves_like 'everywhere'
      it { should contain_file('/etc/puppet/hiera.yaml').with_content("---\n:backends:\n  - yaml\n:yaml:\n  :datadir: /etc/puppet/hieradata\n  :additional: something\n") }
    end

    context "when specifying two backends" do
      let(:params) { {:backends => {
        'yaml' => {'datadir' => '/etc/puppet/hieradata'},
        'json' => {'datadir' => '/etc/puppet/jsonhieradata'}
      } } }
      it_behaves_like 'everywhere'
      it { should contain_file('/etc/puppet/hiera.yaml').with_content("---\n:backends:\n  - yaml\n  - json\n:yaml:\n  :datadir: /etc/puppet/hieradata\n:json:\n  :datadir: /etc/puppet/jsonhieradata\n") }
    end

    context "when specifying gpg backend" do
      let(:params) { {:backends => {'gpg' => {'data' => 'fake'} } } }
      it_behaves_like 'everywhere'
      it { should contain_package('hiera-gpg') }
    end

    context "when specifying eyaml backend" do
      context "without eyaml-gpg" do
        let(:params) { {:backends => {'eyaml' => {'data' => 'fake'} } } }
        it { should contain_package('hiera-eyaml') }
        it { should_not contain_package('hiera-eyaml-gpg') }
      end

      context "with eyaml-gpg" do
        let(:params) { {:backends => {'eyaml' => {
          'data'          => 'fake',
          'gpg_gnupghome' => '/home/user/.gnupg'
        } } } }
        it { should contain_package('hiera-eyaml') }
        it { should contain_package('hiera-eyaml-gpg') }
      end
    end
  end
end
