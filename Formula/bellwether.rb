class Bellwether < Formula
  desc "Report program status to your terminal with OSC 7501 (Program Status Protocol)"
  homepage "https://github.com/bscott/bellwether"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bscott/bellwether/releases/download/v0.1.1/bellwether-cli-aarch64-apple-darwin.tar.gz"
      sha256 "db2fa887fd7cc24d08c383c5dc299ea3ff74923de984bf7cfe97c76245ed032c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bscott/bellwether/releases/download/v0.1.1/bellwether-cli-x86_64-apple-darwin.tar.gz"
      sha256 "515c33d2ff1e7840c0f928c4dcb491d60f96728ba3644be2f69ad8fe11ce2212"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bscott/bellwether/releases/download/v0.1.1/bellwether-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c6e7e79a7c006e1b5a0877711e5594ee43de86bf1758c82a32b8645406395399"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bscott/bellwether/releases/download/v0.1.1/bellwether-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "79784f97ff5eca190fd50ffdbaac0a06254c84840fe4f24af0be953f2223e73b"
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
