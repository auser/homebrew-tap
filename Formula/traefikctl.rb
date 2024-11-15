class Traefikctl < Formula
  desc "A CLI for managing traefik with etcd (and more)"
  homepage "https://github.com/auser/traefikctl"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/auser/traefikctl/releases/download/v0.2.0/traefikctl-aarch64-apple-darwin.tar.xz"
      sha256 "02108a6c07ea242bd0a12b0a729ee0fbc06a7f8c13af5273935354a50bd60e47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/auser/traefikctl/releases/download/v0.2.0/traefikctl-x86_64-apple-darwin.tar.xz"
      sha256 "7ada54e8e08b45f22da419a76699d2ae4bc13f32895ef4dc412afa431c06267e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/auser/traefikctl/releases/download/v0.2.0/traefikctl-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "86ec4431806ed3cac2091dba2ccec79f757a3a240c75e2aecae879aaa1b80c31"
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
