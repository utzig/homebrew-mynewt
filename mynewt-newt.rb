class MynewtNewt < Formula
  desc "Package, build and installation system for Mynewt OS applications"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_4_1_tag.tar.gz"
  version "1.4.1"
  sha256 "496a5d9fb6e8fb25354cbc7f2aa3507e28e34c980e790ef6c0c4f1cf6d993ec9"

  head "https://github.com/apache/mynewt-newt.git"

  bottle do
    root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.4.1"
    cellar :any_skip_relocation
    sha256 "c395bb45be369c667a5fbfbd3c0e7355323e8e39123ca34dae963d3b877726bf" => :sierra
  end

  depends_on "go" => :build
  depends_on :arch => :x86_64

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/mynewt.apache.org/newt").install contents
    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    cd gopath/"src/mynewt.apache.org/newt/newt" do
      system "go", "install"
      bin.install gopath/"bin/newt"
    end
  end

  test do
    # Compare newt version string
    assert_equal "1.4.1", shell_output("#{bin}/newt version").split.last
  end
end
