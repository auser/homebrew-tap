class Traefikctl < Formula
  desc "A CLI for managing traefik with etcd (and more)"
  homepage "https://github.com/auser/traefikctl"
  version "0.2.33"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/auser/traefikctl/releases/download/v0.2.33/traefikctl-aarch64-apple-darwin.tar.xz"
      sha256 "5038d90b40976ad23ca68720833aed5bdfa031beccfa2f47ff5013df1d79d232"
    end
    if Hardware::CPU.intel?
      url "https://github.com/auser/traefikctl/releases/download/v0.2.33/traefikctl-x86_64-apple-darwin.tar.xz"
      sha256 "59b7e41f1bbb9cfcb12c746908bb3cbf7ce8f6d8bd1ea9a42dc3e251b8493328"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/auser/traefikctl/releases/download/v0.2.33/traefikctl-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "b4b7b386d6ffc6a342575fcb2d762437c407e0ee84f17e22a89677c209b0b116"
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
