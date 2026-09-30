class SvixCli < Formula
  desc "A CLI to interact with the Svix API."
  homepage "https://www.svix.com"
  version "2.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.6.1/svix-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c23633cea16d73f9871c8cf073f9381c9e67545db3e2558d5bdf5eca1174cd65"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.6.1/svix-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f6161c41e2ed8d20fa4545d5e7069362664cbf3716808ba3a46222eebce14daa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.6.1/svix-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f425c4b1e93d79cb6d5afd4498c7c6096cca4e2a7a89a7d933ee4fd711cb3109"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.6.1/svix-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "cae98a7a2831481e8d139a0461652c7d5b1fe6e632234b0aa6693d36bede469c"
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
