class Kraze < Formula
  desc "Kubernetes development environment manager with docker-compose-like experience"
  homepage "https://github.com/hjames9/kraze"
  version "0.5.4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/hjames9/kraze/releases/download/v0.5.4/kraze-v0.5.4-darwin-arm64"
      sha256 "ef821c34bafbe9fa2561a23821b34d6af3bf9043c132999fb7126b490de3f463"
    end

    on_intel do
      url "https://github.com/hjames9/kraze/releases/download/v0.5.4/kraze-v0.5.4-darwin-amd64"
      sha256 "107f35d579604a07e5b8c93d6c0b842bb310caa5c0f39d944885c4174e052926"
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
