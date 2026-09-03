class SvixCli < Formula
  desc "A CLI to interact with the Svix API."
  homepage "https://www.svix.com"
  version "2.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.3.0/svix-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f1bd06bdf7152f4a02909061df9e31b321cf40255a3bf6afdcacd7a0f87fd9c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.3.0/svix-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1a04b12fb8a1ebe120f60dc3f5b6a44431bcb6f133b7cf0c259c318230155b94"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.3.0/svix-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "11642f946012866338730d2f4abf48a7e7dd45fc290a2e4c31625bfd6cea7618"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.3.0/svix-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "86cb7fdb306346a5ee04cec136a1653c13a2eaa7d1ddba94d97c7bfc34b394fb"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "svix"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "svix"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "svix"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "svix"
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
