class SvixCli < Formula
  desc "A CLI to interact with the Svix API."
  homepage "https://www.svix.com"
  version "1.85.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.85.0/svix-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3f492273f5bbeb9527a0f79167133a24e321817acff563b833fb96d2d23537a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.85.0/svix-cli-x86_64-apple-darwin.tar.xz"
      sha256 "945e7daf1b7d4fd44e362d1abba02b46eb7c2b8742b8c045121fb24735718bca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.85.0/svix-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ae5fd1624b50e13187646430563e4c3e8c49c72af4877cc7793f62314826ae77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v1.85.0/svix-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "cdace381486b95f8e10ef2d89f0896d07395e5d059d6b0d67077396aaef1bd32"
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

  def caveats
    <<~EOS
      Thanks for installing the Svix CLI!

      To get started, set your auth token:
        export SVIX_AUTH_TOKEN=<YOUR-AUTH-TOKEN>

      Or run:
        svix login

      For help:
        svix --help
    EOS
  end
end
