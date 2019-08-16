# spec/Dockerfile_spec.rb

require_relative "spec_helper"

describe "Dockerfile" do
  before(:all) do
    load_docker_image()
    set :os, family: :debian
  end

  describe "Dockerfile#running" do
    it "runs the right version of Debian" do
      expect(os_version).to include("Debian")
      expect(os_version).to include("GNU/Linux 9")
    end
    it "runs as service user" do
      package_name = ENV['PACKAGE_NAME']
      expect(sys_user).to eql(package_name)
    end
  end

  describe command("java --version 2>&1") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/11(.*)/) }
  end

  describe package("logstash") do
    package_version = ENV['PACKAGE_VERSION']
    it { should be_installed.with_version("1:#{package_version}-1") }
  end

  describe command("/usr/share/logstash/bin/logstash --version") do
    package_version = ENV['PACKAGE_VERSION']
    its(:stdout) { should match("logstash #{package_version}") }
    its(:exit_status) { should eq 0 }
  end
end
