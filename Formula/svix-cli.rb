class SvixCli < Formula
  desc "A CLI to interact with the Svix API."
  homepage "https://www.svix.com"
  version "1.77.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.77.0/svix-cli-aarch64-apple-darwin.tar.xz"
      sha256 "97fec23cbd39d4316419f9be1e39f50ccec197f670081b5834f2c7c91fb8fc9a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.77.0/svix-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f56e7d6b7657e1a5fd5f6dc2740e42ce7d39a108dab8911fdc55f685207e7c06"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.77.0/svix-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ce666e81147bddfe61fd8e8521785e543e6e377b0ac02fd01b7c7984ca582c48"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.77.0/svix-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "10af180ef7de7981e07372284c458ccb5845be96924a2f6b01fd45bf561df121"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "svix" if OS.mac? && Hardware::CPU.arm?
    bin.install "svix" if OS.mac? && Hardware::CPU.intel?
    bin.install "svix" if OS.linux? && Hardware::CPU.arm?
    bin.install "svix" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
