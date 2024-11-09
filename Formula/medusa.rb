class Medusa < Formula
  desc "Command-line tool for importing and exporting Hashicorp Vault secrets"
  homepage "https://github.com/jonasvinther/medusa"
  url "https://github.com/jonasvinther/medusa/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "04643f04cea2021a6e29cd3bf6ec46b804cdbfb2318b1a06b6377b77f2d24c72"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"medusa", "version"
  end
end
