class SvixCli < Formula
  desc "A CLI to interact with the Svix API."
  homepage "https://www.svix.com"
  version "1.64.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.64.0/svix-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8d5fab41b2b273320f0e8579b95b92513814faae8208e71b6e2c847d626857b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.64.0/svix-cli-x86_64-apple-darwin.tar.xz"
      sha256 "18e28c2f6b0efa79efa437323f658990a1b2239bbe83086bcf92776967105b57"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.64.0/svix-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1f61db38cca48c74d9b655cea49b9a7b0a2fb57d91922092b95c4bdf0407e13b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.64.0/svix-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d2e23dc33371031ec023e824094986aecf95ab11ec81a98f0168d725ea016de8"
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
