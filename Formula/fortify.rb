class Fortify < Formula
  desc "Command-line tool designed to enhance file security through encryption"
  homepage "https://github.com/i3ash/fortify"
  version "1.0.19"
  license "MIT"

  option "with-universal", "Install the universal binary"

  depends_on "go" => :build

  resource "source" do
    url "https://github.com/i3ash/fortify/archive/refs/tags/v1.0.19.tar.gz"
    sha256 "3eddbda824dbae8e857310177294de2c1766aa954cf549d8b6af952b64778439"
  end

  if build.with? "universal"
    url "https://github.com/i3ash/fortify/releases/download/v#{version}/fortify-darwin-universal"
    sha256 "65a13b2365f236ee3fa45e1c0ba4eb05864f7e7e825173afe6bfbb24fcb9bdc9"
  else
    on_arm do
      url "https://github.com/i3ash/fortify/releases/download/v#{version}/fortify-darwin-arm64"
      sha256 "a10748fabeb41cea462d801a239c99e3b156118053768ca07bf3bf0e91ee5317"
    end
    on_intel do
      url "https://github.com/i3ash/fortify/releases/download/v#{version}/fortify-darwin-x86_64"
      sha256 "82b66c82c0e5231825b8c57638abe7095b15a3b46441bfbf1d997cd752dae780"
    end
  end

  def install
    binary_name = case
    when build.with?("universal")
      "fortify-darwin-universal"
    when Hardware::CPU.arm?
      "fortify-darwin-arm64"
    when Hardware::CPU.intel?
      "fortify-darwin-x86_64"
    else
      opoo "Unsupported architecture, building from source..."
      return build_from_source
    end
    if File.exist?(binary_name)
      chmod "+x", binary_name
      bin.install binary_name => "fortify"
    else
      opoo "Binary file not found, building from source..."
      build_from_source
    end
  end

  def build_from_source
    resource("source").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "."
    end
  end

  test do
    system bin/"fortify"
    assert_match "v#{version}", shell_output("#{bin}/fortify version")
  end
end
