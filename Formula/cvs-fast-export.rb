class CvsFastExport < Formula
  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-1.56.tar.gz"
  sha256 "4c1fe6ee477dd7e3f202419d1420a079bf69421d2469cab442e4d96bc7fd0b15"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cvs-fast-export[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "74b0b5e12bc9a958ff35fd2d57801a2836fb4f6f1678dc8f7cc0f17ba9285565"
    sha256 cellar: :any_skip_relocation, catalina: "2258571d35114e999d5328116ef53ab16fd2d2a4ccc9954fafd544703aeb0ae5"
    sha256 cellar: :any_skip_relocation, mojave:   "ebec60a0595f07b7e363bafff0cd726030a1d4c073dd6f699293fc20defa078c"
  end

  head do
    url "https://gitlab.com/esr/cvs-fast-export.git"
    depends_on "bison" => :build
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "cvs" => :test

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    cvsroot = testpath/"cvsroot"
    cvsroot.mkpath
    system "cvs", "-d", cvsroot, "init"

    test_content = "John Barleycorn"

    mkdir "cvsexample" do
      (testpath/"cvsexample/testfile").write(test_content)
      ENV["CVSROOT"] = cvsroot
      system "cvs", "import", "-m", "example import", "cvsexample", "homebrew", "start"
    end

    assert_match test_content, shell_output("find #{testpath}/cvsroot | #{bin}/cvs-fast-export")
  end
end
