class Traefikctl < Formula
  desc "A CLI for managing traefik with etcd (and more)"
  homepage "https://github.com/auser/traefikctl"
  version "0.1.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/auser/traefikctl/releases/download/v0.1.12/traefikctl-aarch64-apple-darwin.tar.xz"
      sha256 "f3dbc025f00593deb4a05e4d1a0e66ac82a1614e9d2fb0a26eebe509eea694f4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/auser/traefikctl/releases/download/v0.1.12/traefikctl-x86_64-apple-darwin.tar.xz"
      sha256 "b4d561457fa63e9ee5127ef5af4599c809d59420a3d1b66538931ba249970547"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/auser/traefikctl/releases/download/v0.1.12/traefikctl-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "99704f9fc70d5d75a171badfded3556ab155aa7dfd9748133e8ccd1e366bd58e"
  end
  license "Apache-2.0 or MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

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
    bin.install "traefikctl" if OS.mac? && Hardware::CPU.arm?
    bin.install "traefikctl" if OS.mac? && Hardware::CPU.intel?
    bin.install "traefikctl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
