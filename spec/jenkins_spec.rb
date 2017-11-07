require 'spec_helper'

describe "jenkins_environment", :unit do

  before(:all) do

    ENV['AWS_PROFILE'] = 'pbrowndev'
    ENV['AWS_REGION'] = 'eu-west-2'

    command = Thread.new do
      `terraform init ./terraform/mgmt/services`
      `terraform apply ./terraform/mgmt/services`
    end
    command.join
  end

  it { should be_running }
  it { should have_tag('Name').value("Octo Jenkins") }
  its(:instance_type) { should eq 't2.medium' }
  #it { should have_security_groups(["#{RSpec.configuration.security_group}"]) }

  after(:all) do
    `terraform destroy -force ./terraform/mgmt/services`
  end

end