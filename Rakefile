
require 'aws-sdk'
require 'date'

desc 'Deploy EMR infrastructure using Terraform'
task :create_emr do
  sh 'cd terraform/stage/services/elastic-map-reduce && \
    terraform apply'
  end

desc 'Destroy EMR infrastructure using Terraform'
task :destroy_emr do
  sh 'cd terraform/stage/services/elastic-map-reduce && \
    terraform destroy'
  end

desc 'Deploy infrastructure using Terraform'
task :create_jenkins do 
  sh 'cd terraform/mgmt/services && \
      terraform apply'
  end

desc 'Destroy Jenkins infrastructure'
task :destroy_jenkins do
  sh 'cd terraform/mgmt/services && \
      terraform destroy'
  end