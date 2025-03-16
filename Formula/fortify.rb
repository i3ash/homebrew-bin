class Fortify < Formula
  desc "Command-line tool designed to enhance file security through encryption"
  homepage "https://github.com/i3ash/fortify"
  version "1.1.6"
  license "MIT"

  option "with-universal", "Install the universal binary"

  depends_on "go" => :build

  resource "source" do
    url "https://github.com/i3ash/fortify/archive/refs/tags/v1.1.6.tar.gz"
    sha256 "bca0d701d7381c2dbe63a788ed20ad5efed97325379803b36e3d2509496c67a0"
  end

  if build.with? "universal"
    url "https://github.com/i3ash/fortify/releases/download/v#{version}/fortify-darwin-universal"
    sha256 "9b2d7efd05e9465ab5b75bf21edebce9b13caf86f6bd2bc12dc383d629b2728b"
  else
    on_arm do
      url "https://github.com/i3ash/fortify/releases/download/v#{version}/fortify-darwin-arm64"
      sha256 "ac91d0b6a33c18ddc4a417bd8f76f42b16de24c34633457011acf01861927023"
    end
    on_intel do
      url "https://github.com/i3ash/fortify/releases/download/v#{version}/fortify-darwin-x86_64"
      sha256 "96beaac1baa9ec08ce26e7397120aa9d11dc3d0bf19b4fbf46eed30f1a7245c3"
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
