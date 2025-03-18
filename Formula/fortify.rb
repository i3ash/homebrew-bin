class Fortify < Formula
  desc "Command-line tool designed to enhance file security through encryption"
  homepage "https://github.com/i3ash/fortify"
  version "1.2.3"
  license "MIT"

  option "with-universal", "Install the universal binary"

  depends_on "go" => :build

  resource "source" do
    url "https://github.com/i3ash/fortify/archive/refs/tags/v1.2.3.tar.gz"
    sha256 "c642cf7f0321c281b9f5a96ee013cd13ec1b4faca56f84cc257410f32782cc78"
  end

  if build.with? "universal"
    url "https://github.com/i3ash/fortify/releases/download/v#{version}/fortify-darwin-universal"
    sha256 "4760718119ea746bf52403a0e3d602d4c696f2321db19736faefe1fccb88cf45"
  else
    on_arm do
      url "https://github.com/i3ash/fortify/releases/download/v#{version}/fortify-darwin-arm64"
      sha256 "4a07783fe7fd1b4dc8aeab36acae02f111e6a8f998150fcb5bb4502187d50a93"
    end
    on_intel do
      url "https://github.com/i3ash/fortify/releases/download/v#{version}/fortify-darwin-x86_64"
      sha256 "811761ccada16fb2225a74ffd8b70706fe00f79cbfac95a68436c262c0d5adc5"
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
