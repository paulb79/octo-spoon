
require 'spec_helper'

describe "emr_environment", :unit do

  before(:all) do

    ENV['AWS_PROFILE'] = 'pbrowndev'
    ENV['AWS_REGION'] = 'eu-west-2'

    command = Thread.new do
      `terraform init ./terraform/stage/services/elastic-map-reduce`
      `terraform apply ./terraform/stage/services/elastic-map-reduce`
    end
    command.join
  end

  it { should be_running }
  it { should have_tag('Name').value("Octo EMR") }
  its(:instance_type) { should eq 'm4.xlarge' }

  #it { should have_security_groups(["#{RSpec.configuration.security_group}"]) }

  after(:all) do
    `terraform destroy -force ./terraform/stage/services/elastic-map-reduce`
  end

end

