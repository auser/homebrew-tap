class Sqlex < Formula
  desc "A tool to extract tables from a sql dump and run sql queries on them"
  homepage "https://github.com/auser/sqlex"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/auser/sqlex/releases/download/v0.1.6/sqlex-aarch64-apple-darwin.tar.gz"
      sha256 "a649e73edc0a22790f92babe2ab32e75b3034dc66bdc0ea72a2232895d7d8927"
    end
    if Hardware::CPU.intel?
      url "https://github.com/auser/sqlex/releases/download/v0.1.6/sqlex-x86_64-apple-darwin.tar.gz"
      sha256 "40178d2ba766ba019545391338d55a8f71d2a37d47905ceef6470bc338bc983b"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/auser/sqlex/releases/download/v0.1.6/sqlex-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "48f93e3bd46b78cc99b2de30979a02c7e82c025ff855bbb3fd3af75e39753f7c"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "sqlex"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "sqlex"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "sqlex"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
