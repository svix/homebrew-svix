class SvixCli < Formula
  desc "A CLI to interact with the Svix API."
  homepage "https://www.svix.com"
  version "1.61.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.61.1/svix-cli-aarch64-apple-darwin.tar.xz"
      sha256 "082cb5f4b9e497de038d181bb5c469fd63b9f0d986dbfe65b10f0efda9b08f46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.61.1/svix-cli-x86_64-apple-darwin.tar.xz"
      sha256 "41ff40bb2e4f2de0cc6b62d34245c5f0aff9093a76148d793e8cab290c87b34e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.61.1/svix-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d58a3cbe276145ce8e93ab4ff1a8619ad96dd746e0732bedd06225b4e497c800"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.61.1/svix-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "b47f44aff611b09bd9d192dcfe2c38afa02431729e006011fe00b84854ee8e2f"
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
