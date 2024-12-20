class Traefikctl < Formula
  desc "A CLI for managing traefik with etcd (and more)"
  homepage "https://github.com/auser/traefikctl"
  version "0.2.36"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/auser/traefikctl/releases/download/v0.2.36/traefikctl-aarch64-apple-darwin.tar.xz"
      sha256 "01003d483e53a75bd7670581ae8b2b0564320412268582682ec44c73a0c9390f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/auser/traefikctl/releases/download/v0.2.36/traefikctl-x86_64-apple-darwin.tar.xz"
      sha256 "72a23db57e5d40b8843f393149c9301cb3a347444a5deab9b00079bbddf0bc7b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/auser/traefikctl/releases/download/v0.2.36/traefikctl-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ca22eba97e8194b2e25e9212ad7b0a91ff2915f7313379bfca59569da0d9fa8a"
  end
  license any_of: ["MIT", "Apache-2.0"]

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
