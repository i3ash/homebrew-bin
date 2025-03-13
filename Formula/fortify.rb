class Fortify < Formula
  desc "Command-line tool designed to enhance file security through encryption"
  homepage "https://github.com/i3ash/fortify"
  version "1.1.5"
  license "MIT"

  option "with-universal", "Install the universal binary"

  depends_on "go" => :build

  resource "source" do
    url "https://github.com/i3ash/fortify/archive/refs/tags/v1.1.5.tar.gz"
    sha256 "1cc53f245213249060bff36c5eaeb28ec76fa7a708f8c12faeeb24566ee459b4"
  end

  if build.with? "universal"
    url "https://github.com/i3ash/fortify/releases/download/v#{version}/fortify-darwin-universal"
    sha256 "0ea9f17b5877caeb540fa715b82285b15df371ec555dd34de895c500556cf775"
  else
    on_arm do
      url "https://github.com/i3ash/fortify/releases/download/v#{version}/fortify-darwin-arm64"
      sha256 "9c25429b7ad62bf112b994bf490afdb8f090f486d2b39cbed95c8ec8b9ad958f"
    end
    on_intel do
      url "https://github.com/i3ash/fortify/releases/download/v#{version}/fortify-darwin-x86_64"
      sha256 "65666811d737d0a8bfeb007498452a6fb47355c7a7e609e998e707229e4f11cc"
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
