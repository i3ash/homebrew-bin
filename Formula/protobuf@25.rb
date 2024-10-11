class ProtobufAT25 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v25.5/protoc-25.5-osx-universal_binary.zip"
  sha256 "a8cd6ce419b9e150c560ca266eee8913b59052c328691a24ef047ee1da014f07"
  license "BSD-3-Clause"
  revision 3
  def install
    bin.install "bin/protoc"
    include.install Dir["include/*"]
  end
  test do
    system bin/"protoc", "--version"
  end
end
