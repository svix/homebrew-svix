# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class Svix < Formula
  desc "Svix CLI utility"
  homepage "https://www.svix.com"
  version "0.11.0"
  bottle :unneeded

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-cli/releases/download/v0.11.0/svix_0.11.0_Darwin_x86_64.tar.gz"
      sha256 "80dd921bca13348688a2d579850c780189fea3791d72534eebefed5780807672"
    end
    if Hardware::CPU.arm?
      url "https://github.com/svix/svix-cli/releases/download/v0.11.0/svix_0.11.0_Darwin_arm64.tar.gz"
      sha256 "013298aff5150151ea4790ebbb8438dcacc6d97a7d87e8f49436e10b4c82cef5"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/svix/svix-cli/releases/download/v0.11.0/svix_0.11.0_Linux_x86_64.tar.gz"
      sha256 "61382afd73a22cfdd7cf9b4535845cd3871ccbc9eb7e93c5c0dbe49baa2422a0"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/svix/svix-cli/releases/download/v0.11.0/svix_0.11.0_Linux_arm64.tar.gz"
      sha256 "aa88c3cbdba459d40902b87b4a4e05fa2e0589d415cd512c9b532f18dbea5fd0"
    end
  end

  def install
    bin.install "svix"
  end

  def caveats; <<~EOS
    Thanks for installing the Svix CLI! If this is your first time using the CLI, checkout our docs at https://docs.svix.com.
  EOS
  end
end
