class Sqlex < Formula
  desc "A tool to extract tables from a sql dump and run sql queries on them"
  homepage "https://github.com/auser/sqlex"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/auser/sqlex/releases/download/v0.1.7/sqlex-aarch64-apple-darwin.tar.gz"
      sha256 "8eca3d4d6f41a3f55b64e6033504fd64a12c8532ad6f6d2483f766b7b4eaf809"
    end
    if Hardware::CPU.intel?
      url "https://github.com/auser/sqlex/releases/download/v0.1.7/sqlex-x86_64-apple-darwin.tar.gz"
      sha256 "68775d9897c14b294a3e71a68a63d11856baa5c2a42bfbdbd717efe2a2a0a075"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/auser/sqlex/releases/download/v0.1.7/sqlex-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f0ebfe097f4d1f11dcf66473e8542cf1ad81261e475872cbdec3029236faacd5"
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
