class SvixCli < Formula
  desc "A CLI to interact with the Svix API."
  homepage "https://www.svix.com"
  version "2.11.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.11.1/svix-cli-aarch64-apple-darwin.tar.xz"
      sha256 "da9cc923dfeeae50871a50819e6fbfe454828af83ed52dc45bb015ebbda01b7b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.11.1/svix-cli-x86_64-apple-darwin.tar.xz"
      sha256 "61d95ec531f59c3998ed9d00d9c74183453dae3dd033414504bbe79bf10082f1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.11.1/svix-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ae1b02cfb464df2991ea600d265ace148ccf74c4a0d4e15ae811bcea0d441599"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.11.1/svix-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "98ef6519ab32e59c3967eab0a7bac8c4d42d3de09c8ca91cebdd7d43139c231d"
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
