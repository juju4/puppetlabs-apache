require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/var/www/html/default-security.txt') do
  it { should be_file }
  it { should be_mode 444 }
  its(:content) { should match /Contact: security@example.com/ }
  its(:content) { should match /Encryption: https:\/\/example.com\/pgp-key.txt/ }
end

describe command('curl -v http://localhost/default-security.txt') do
  its(:stderr) { should match /HTTP\/1.1 200/ }
  its(:stderr) { should_not match /HTTP\/1.0 500 Internal Server Error/ }
  its(:stderr) { should match /Server: Apache/ }
  its(:stderr) { should match /Server: Apache\s*$/ }
  its(:stdout) { should match /Contact: security@example.com/ }
  its(:stdout) { should match /Encryption: https:\/\/example.com\/pgp-key.txt/ }
end
