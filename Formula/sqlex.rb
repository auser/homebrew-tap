class Sqlex < Formula
  desc "A tool to extract tables from a sql dump and run sql queries on them"
  homepage "https://github.com/auser/sqlex"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/auser/sqlex/releases/download/v0.1.8/sqlex-aarch64-apple-darwin.tar.gz"
      sha256 "dbbe05d873a737a2b8f82c634c86ca6fb6cb1cd2d8556f49983c9a8ab587d721"
    end
    if Hardware::CPU.intel?
      url "https://github.com/auser/sqlex/releases/download/v0.1.8/sqlex-x86_64-apple-darwin.tar.gz"
      sha256 "eea51d51823fddf18f2a46a87337d4027f0fa80410bb54dd471341624a103ef5"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/auser/sqlex/releases/download/v0.1.8/sqlex-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f3656d4b8617c49c6af3c36505d6909bb93c49ecd9b05354383498aa4129910e"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}, "x86_64-unknown-linux-musl-dynamic": {}, "x86_64-unknown-linux-musl-static": {}}

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
