class SvixCli < Formula
  desc "A CLI to interact with the Svix API."
  homepage "https://www.svix.com"
  version "1.63.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.63.2/svix-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a58969a937e807ea0214dd61b9d6dfec1c3e61ee7fd59c665b9aa50c25fb0c6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.63.2/svix-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5ebba04e127350e9938c5d8acfe1e9aca43fc8d3cb1294853c1b7e041060e660"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.63.2/svix-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6d300d5dcb11bbfd43cd128d38a44510ff16d6fb7b925caa1363f79383de1f73"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.63.2/svix-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "fe0fbb65af05125a7ea298460792fb94af1b917e1aa18d72c6820bea0285a6f2"
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
