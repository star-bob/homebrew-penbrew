require "formula"

class Clusterd < Formula
  homepage "https://github.com/hatRiot/clusterd"
  url "https://github.com/hatRiot/clusterd", :using => :git, :revision => "d190b2c"
  version "0.5"
  revision 2

  depends_on :java => "1.7+"

  resource "requests" do
    url "https://pypi.python.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[requests].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    (bin/"clusterd").write <<-EOS.undent
      #!/usr/bin/env bash
      cd #{libexec} && PYTHONPATH=#{ENV["PYTHONPATH"]} python clusterd.py "$@"
    EOS
    libexec.install Dir['*']
  end
end
