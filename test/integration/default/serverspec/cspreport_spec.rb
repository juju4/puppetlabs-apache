require 'serverspec'

# Required by serverspec
set :backend, :exec

describe command('curl -kv https://localhost/csp/report.php'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
  its(:stderr) { should match /HTTP\/1.1 204 No Content/ }
  its(:stderr) { should_not match /HTTP\/1.0 500 Internal Server Error/ }
  its(:stderr) { should match /SSL connection using TLS1.2/ }
  its(:stderr) { should match /Server: Apache/ }
  its(:stderr) { should match /Server: Apache\s*$/ }
end

describe command('curl -kv https://localhost/csp/report.php'), :if => os[:family] == 'ubuntu' && os[:release] == '14.04' do
  its(:stderr) { should match /HTTP\/1.1 204 No Content/ }
  its(:stderr) { should_not match /HTTP\/1.0 500 Internal Server Error/ }
  its(:stderr) { should match /SSL connection using ECDHE-RSA-AES256-GCM-SHA384/ }
  its(:stderr) { should match /Server: Apache/ }
  its(:stderr) { should match /Server: Apache\s*$/ }
  its(:stderr) { should_not match /-Powered-By: PHP\/5.5.9-1ubuntu4.22/ }
end
