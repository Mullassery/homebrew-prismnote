class Prismnote < Formula
  desc "Data science notebook with 15+ programming languages and SQL execution"
  homepage "https://github.com/Mullassery/prismnote"
  url "https://github.com/Mullassery/prismnote/releases/download/v1.11.0/prismnote-macos-arm64"
  sha256 "9223e8992824562024fb2beae7510907941f58dd94c3074390332af6828e67dd"
  license "Proprietary"
  version "1.11.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # Only a single raw Apple Silicon binary is published as of v1.11.0 — no
  # Intel (x86_64) build and no Linux build exist as release assets.
  depends_on macos: :ventura
  disable! date: nil, because: :unsupported unless Hardware::CPU.arm?

  def install
    bin.install "prismnote-macos-arm64" => "prismnote"
    chmod 0755, bin/"prismnote"
  end

  test do
    # The binary has no CLI flags at all — every argument (including
    # --version/--help) is ignored and it unconditionally starts a local
    # notebook server on port 8000. Smoke-test that it actually comes up.
    pid = fork { exec bin/"prismnote" }
    sleep 2
    begin
      output = shell_output("curl -sS -o /dev/null -w '%{http_code}' http://localhost:8000/")
      assert_equal "200", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
