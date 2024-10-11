class Fortify < Formula
  desc "Command-line tool designed to enhance file security through encryption"
  homepage "https://github.com/i3ash/fortify"
  url "https://github.com/i3ash/fortify/archive/refs/tags/v1.0.12.tar.gz"
  sha256 "d323e84712d691eafdc5683364a567632c61c2b106a656c9120d71b39939ea4f"
  license "MIT"
  depends_on "go" => :build
  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/i3ash/fortify").install buildpath.children
    cd "src/github.com/i3ash/fortify" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "."
    end
  end
  test do
    system bin/"fortify", "version"
  end
end
