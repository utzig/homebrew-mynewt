class MynewtNewtmgr < Formula
  desc "Tool to manage devices running Mynewt OS via the Newtmgr Protocol"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newtmgr/archive/mynewt_1_5_0_tag.tar.gz"
  version "1.5.0"
  sha256 "00bab2c0ea52dab5386b027c92b34936a18ae8ff6a18536db1296fe1e3469832"

  head "https://github.com/apache/mynewt-newtmgr.git"

  bottle do
     root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.5.0"
     cellar :any_skip_relocation
    sha256 "d86b55da7e337f1c9459dc175e6ca5a5f411d1b4fe0df3819b1180ea9704e571" => :sierra
  end

  depends_on "go" => :build
  depends_on :arch => :x86_64

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/mynewt.apache.org/newtmgr").install contents
    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

# We are not able to vendor these packages due to a "go get" bug in 
# vendoring packages with platform dependent code. So we have to get
# these packages for the buid.
  
    cd gopath/"src" do
       system "go", "get", "github.com/currantlabs/ble"
       system "go", "get", "github.com/raff/goble"
       system "go", "get", "github.com/mgutz/logxi/v1"
    end

    cd gopath/"src/mynewt.apache.org/newtmgr/newtmgr" do
      system "go", "install"
      bin.install gopath/"bin/newtmgr"
    end
  end

  test do
    # Check for Newtmgr in first word of output.
    assert_match "Newtmgr", shell_output("#{bin}/newtmgr").split.first
  end
end
