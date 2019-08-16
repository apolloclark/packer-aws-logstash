# spec/Dockerfile_spec.rb

require_relative "spec_helper"

describe "Dockerfile" do
  before(:all) do
    load_docker_image()
    set :os, family: :redhat
  end

  describe "Dockerfile#running" do
    it "runs the right version of RHEL" do
      expect(os_version).to include("Red Hat")
      expect(os_version).to include("release 7")
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
    it { should be_installed.with_version(package_version) }
  end

  describe command("/usr/share/logstash/bin/logstash --version") do
    package_version = ENV['PACKAGE_VERSION']
    its(:stdout) { should match("logstash #{package_version}") }
    its(:exit_status) { should eq 0 }
  end
end
