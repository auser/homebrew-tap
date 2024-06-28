class Sqlex < Formula
  desc "A tool to extract tables from a sql dump and run sql queries on them"
  homepage "https://github.com/auser/sqlex"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/auser/sqlex/releases/download/v0.1.5/sqlex-aarch64-apple-darwin.tar.gz"
      sha256 "2e7bafa65a8910e680a796e7797b3b4e8786744d5c587af5861ae3885e1bb457"
    end
    if Hardware::CPU.intel?
      url "https://github.com/auser/sqlex/releases/download/v0.1.5/sqlex-x86_64-apple-darwin.tar.gz"
      sha256 "54e92e7de9ea884373e2ae3b85925d5a5bb60695c51bd752d22be4a0ab5a9b25"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/auser/sqlex/releases/download/v0.1.5/sqlex-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5598eef63331d1e12289eeae4c74d093c8439ad0e210dc286e83f28e441cc533"
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
