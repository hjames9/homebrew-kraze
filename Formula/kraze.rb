class Kraze < Formula
  desc "Kubernetes development environment manager with docker-compose-like experience"
  homepage "https://github.com/hjames9/kraze"
  version "0.8.9"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/hjames9/kraze/releases/download/v#{version}/kraze-v#{version}-darwin-arm64"
      sha256 "3ea3fe778b3f41926515d6ca686cbcc0f8b13378d488e9089877bbd53f7d96ad"
    end

    on_intel do
      url "https://github.com/hjames9/kraze/releases/download/v#{version}/kraze-v#{version}-darwin-amd64"
      sha256 "129a04655423f2cff3058c66768b6e85447a90e1bb4ca848a1dd3a54852378c5"
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
