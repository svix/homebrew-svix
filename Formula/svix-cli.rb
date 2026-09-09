class SvixCli < Formula
  desc "A CLI to interact with the Svix API."
  homepage "https://www.svix.com"
  version "2.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.4.0/svix-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f824935a193caf34f7308e5cf239fc33692e05e566be7514b479d29eaf19973e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.4.0/svix-cli-x86_64-apple-darwin.tar.xz"
      sha256 "948f2864a9c17f6a90da81fe68ed39cfe0fbf8e8abde4cbb2af27d976d8d254a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.4.0/svix-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7f01b698988722ca0f651edb71d20db069f2593ccef9b86e850df9e005f4bf6a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-webhooks/releases/download/v2.4.0/svix-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "600a8d64edd07c89017c48cccd14f91fbca6fb6426d633e66308aa20f351072c"
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
