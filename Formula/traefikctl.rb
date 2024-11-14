class Traefikctl < Formula
  desc "A CLI for managing traefik with etcd (and more)"
  homepage "https://github.com/auser/traefikctl"
  version "0.1.27"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/auser/traefikctl/releases/download/v0.1.27/traefikctl-aarch64-apple-darwin.tar.xz"
      sha256 "e736dac8f213b476bcbf99ec0116f22e57e46fa6a4628b8cf1b9a6dcafdd393e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/auser/traefikctl/releases/download/v0.1.27/traefikctl-x86_64-apple-darwin.tar.xz"
      sha256 "231a9853d57952169b778fa7b9f810eab93f6fc7ceb86ef185f90516045fc633"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/auser/traefikctl/releases/download/v0.1.27/traefikctl-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "54b84449057b65a053c14d6e099e046a7bf9cb8c5b0af2986df25a4c65194b00"
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
