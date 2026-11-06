class Bellwether < Formula
  desc "Report program status to your terminal with OSC 7501 (Program Status Protocol)"
  homepage "https://github.com/bscott/bellwether"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bscott/bellwether/releases/download/v0.1.0/bellwether-cli-aarch64-apple-darwin.tar.xz"
      sha256 "74b82e6a4399fc4a13547ac7a04b188fe3516ebffb3bedfd44a1918d8dee2f45"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bscott/bellwether/releases/download/v0.1.0/bellwether-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ffccdcc6275baf7e933dc1ba6600cb0c008218e0f6af98c43744a4f96796d7ac"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bscott/bellwether/releases/download/v0.1.0/bellwether-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2bb597f147ab6641c42eeec51cddc9c9d60d06eff5a2fced54e4491982b9b16d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bscott/bellwether/releases/download/v0.1.0/bellwether-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2c81c6ed9fa84d96ebc9d5ead8bc76d02b5171f9684f5b25527084221ba30f41"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
      bin.install "bellwether"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "bellwether"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "bellwether"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "bellwether"
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
