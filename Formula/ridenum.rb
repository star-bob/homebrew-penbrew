require "formula"

class Ridenum < Formula
  homepage "https://github.com/trustedsec/ridenum"
  url "https://github.com/trustedsec/ridenum.git", :using => :git, :revision => "4da0974"
  version "1.6"

  resource "pexpect" do
    url "https://pypi.python.org/packages/52/97/13924c85a4b7544a4174781360e0530a7fff23e62d76da0e211369dd61f5/pexpect-3.3.tar.gz"
    sha256 'dfea618d43e83cfff21504f18f98019ba520f330e4142e5185ef7c73527de5ba'
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[pexpect].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec

    bin.install "ridenum.py"
    libexec.install Dir["*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end
end
