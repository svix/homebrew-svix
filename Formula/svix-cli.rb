class SvixCli < Formula
  desc "A CLI to interact with the Svix API."
  homepage "https://www.svix.com"
  version "2.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.8.0/svix-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4bb2e258ce585bfc7b298ad7cde20b2ed29a64fcfaba8ee983dd6a6bde2e3118"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.8.0/svix-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e1eb758f0d51c01600486537e852c1ae8e9a7cf2372774b10d54bda16586c1f1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.8.0/svix-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5bf12218393768299cc18698c703c8fa56e67ef0ae32bc7839da954b2334644e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.8.0/svix-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "9ddad86c3bc2e92a4d355ff6bcdacdcc328dca5f6af1cac7a8d4ad1e343155b8"
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
