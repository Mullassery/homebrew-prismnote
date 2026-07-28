class Prismnote < Formula
  desc "Data science notebook with 15+ programming languages and SQL execution"
  homepage "https://github.com/Mullassery/prismnote"
  license "Proprietary"

  on_macos do
    on_arm64 do
      url "https://github.com/Mullassery/prismnote/releases/download/v1.7.0/prismnote-macos-aarch64.tar.gz"
      sha256 "PLACEHOLDER_ARM64_SHA256"
    end
    on_intel do
      url "https://github.com/Mullassery/prismnote/releases/download/v1.7.0/prismnote-macos-x86_64.tar.gz"
      sha256 "PLACEHOLDER_X86_64_SHA256"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Mullassery/prismnote/releases/download/v1.7.0/prismnote-linux-x86_64.tar.gz"
      sha256 "PLACEHOLDER_LINUX_SHA256"
    end
  end

  def install
    bin.install "prismnote"
  end

  def post_install
    system "#{bin}/prismnote", "--version"
  end

  test do
    system bin/"prismnote", "--version"
  end
end
