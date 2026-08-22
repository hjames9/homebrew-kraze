class Kraze < Formula
  desc "Kubernetes development environment manager with docker-compose-like experience"
  homepage "https://github.com/hjames9/kraze"
  version "0.8.8"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/hjames9/kraze/releases/download/v#{version}/kraze-v#{version}-darwin-arm64"
      sha256 "658235315596725a0272b1bc9374da75620f121021eea738c1f458c775b625df"
    end

    on_intel do
      url "https://github.com/hjames9/kraze/releases/download/v#{version}/kraze-v#{version}-darwin-amd64"
      sha256 "143fc82ac19ea5847f6dff845fe9d59765c368ce600132bc0ecd936d6fa4058e"
    end
  end

  def install
    binary_name = "kraze-v#{version}-darwin-#{Hardware::CPU.arch.to_s.sub("x86_64", "amd64")}"
    chmod 0755, binary_name
    bin.install binary_name => "kraze"
    generate_completions_from_executable(bin/"kraze", "completion", shells: [:bash, :zsh, :fish])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kraze version")
  end

  def caveats
    <<~EOS
      kraze requires a Docker-compatible runtime to create kind clusters.

      Supported options include:
        - Docker Desktop (https://www.docker.com/products/docker-desktop)
        - Colima (brew install colima)
        - Podman
        - Rancher Desktop
    EOS
  end
end
