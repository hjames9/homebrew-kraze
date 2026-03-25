class Kraze < Formula
  desc "Kubernetes development environment manager with docker-compose-like experience"
  homepage "https://github.com/hjames9/kraze"
  version "0.7.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/hjames9/kraze/releases/download/v#{version}/kraze-v#{version}-darwin-arm64"
      sha256 "0b86b5079d4ff99ef1f5280629cf48854e10f823c31f994691c69cc12d98e38b"
    end

    on_intel do
      url "https://github.com/hjames9/kraze/releases/download/v#{version}/kraze-v#{version}-darwin-amd64"
      sha256 "adac8ad175c55833174051b034d9456d562fa485bce147dafa83e179230e0040"
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
