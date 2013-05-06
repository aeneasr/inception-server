require File.expand_path("../../spec_helper", __FILE__)
require File.expand_path("../../support/aws/aws_helpers", __FILE__)

require "fog"
require "active_support/core_ext/hash/keys"

describe "AWS deployment" do
  include FileUtils
  include StdoutCapture
  include SettingsHelper
  include AwsHelpers

  before do
    setup_home_dir
    Fog.mock!
    Fog::Mock.reset
    @cmd = Bosh::Inception::Cli.new
  end

  describe "with simple manifest" do
    before do
      credentials = {aws_access_key_id: "ACCESS", aws_secret_access_key: "SECRET"}
      @fog_credentials = credentials.merge(provider: "AWS")
      create_manifest(credentials: credentials)

      capture_stdout { cmd.deploy }
      # cmd.deploy
    end

    it "populates settings with git.name & git.email from ~/.gitconfig" do
      settings.git.name.should == "Dr Nic Williams"
      settings.git.email.should == "drnicwilliams@gmail.com"
    end

    it "creates an elastic IP automatically and assigns to settings.inception.ip_address" do
      settings.inception.ip_address.should_not be_nil
    end

    it "creates AWS key pair and assigns to inception.key_pair.name / private_key" do
      settings.inception.key_pair.name.should == "inception"
      settings.inception.key_pair.private_key.should_not be_nil
    end

  end
end