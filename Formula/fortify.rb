class Fortify < Formula
  desc "Command-line tool designed to enhance file security through encryption"
  homepage "https://github.com/i3ash/fortify"
  version "1.0.15"
  license "MIT"

  option "with-universal", "Install the universal binary"

  depends_on "go" => :build

  resource "source" do
    url "https://github.com/i3ash/fortify/archive/refs/tags/v1.0.15.tar.gz"
    sha256 "8dac6e60bff640287f4eb04e6f427fd856dabcb76cfc8dc7b504793d8b30305e"
  end

  if build.with? "universal"
    url "https://github.com/i3ash/fortify/releases/download/v#{version}/fortify-darwin-universal"
    sha256 "21d3e48a844dbb476f6979cce5efe91d354215b3ee805390bdce5fdde7d8f7c8"
  else
    on_arm do
      url "https://github.com/i3ash/fortify/releases/download/v#{version}/fortify-darwin-arm64"
      sha256 "533ceaa60d994e1e1eb980a6f2da0c1fb666c05e587256427a1a0049541fb248"
    end
    on_intel do
      url "https://github.com/i3ash/fortify/releases/download/v#{version}/fortify-darwin-x86_64"
      sha256 "fd49fdfdd07765964f1acbc31de632613f746648a089bf8cf7ba3e54d466b5d3"
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
