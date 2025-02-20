class SvixCli < Formula
  desc "A CLI to interact with the Svix API."
  homepage "https://www.svix.com"
  version "1.59.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.59.0/svix-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e84335890c4fa6facd609823ca9767aef4e3ae20327770a199bfd1266cc6f784"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.59.0/svix-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6a19c19a0dc3fae78db4af8505e32620cd401b963bb6ff3a0a655c54d279f61b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.59.0/svix-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6fc10bd6be0a2b2007a0d7101e03d94688ec4dcde3334c69adcc432f5d50c038"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.59.0/svix-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "40d7fe8fb17f0920ca5f79ed83b11cb7f62fc46ed0c99d6921f10a7f71235fdb"
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
