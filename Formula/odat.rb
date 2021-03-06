class Odat < Formula
  homepage "https://github.com/quentinhardy/odat"
  url "https://github.com/quentinhardy/odat", :using => :git, :revision => "ca2e1d4"
  version "2.2.1"
  revision 2

  #depends_on :python
  # Combatability matrix: https://mikedietrichde.com/2017/02/17/client-certification-for-oracle-database-12-1-0-212-2-0-1/
  depends_on 'instantclient-basic'    # for cx_Oracle
  depends_on 'instantclient-sdk'      # for cx_Oracle
  depends_on 'instantclient-sqlplus'  # for cx_Oracle

  resource "cx_oracle" do
    #url "https://pypi.python.org/packages/95/7f/3b74fe3adeb5948187b760330cb7e9175e3484bd6defdfeb9b504d71b4b3/cx_Oracle-5.2.1.tar.gz"
    #sha256 "3dfedd9538f50dee41493020c1f589e5c61835a0c8fd14f5a6c47b5919258e81"
    url "https://pypi.python.org/packages/14/05/4d492fb049eeee24ff8b5fdf23c6240b81ef168d4039dfbf6629e022ba6b/cx_Oracle-5.3.tar.gz"
    sha256 "124db57fd9e5f99a8033ffaef673db204565f5c2b9c2c957802a7281370562a6"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "passlib" do
    url "https://pypi.python.org/packages/1e/59/d1a50836b29c87a1bde9442e1846aa11e1548491cbee719e51b45a623e75/passlib-1.6.5.tar.gz"
    sha256 "a83d34f53dc9b17aa42c9a35c3fbcc5120f3fcb07f7f8721ec45e6a27be347fc"
  end

  resource "scapy" do
    url "https://pypi.python.org/packages/6d/72/c055abd32bcd4ee6b36ef8e9ceccc2e242dea9b6c58fdcf2e8fd005f7650/scapy-2.3.2.tar.gz"
    sha256 "a9059ced6e1ded0565527c212f6ae4c735f4245d0f5f2d7313c4a6049b005cd8"
  end

  resource "colorlog" do
    url "https://pypi.python.org/packages/95/59/c70e535f1b3b8eab2279dc58dc5ce1a780eb83efccefa55ca745dc7f02ee/colorlog-2.7.0.tar.gz"
    sha256 "8e197dae35398049965293021dd69a9db068efe97133597f128e5ef69392f33e"
  end

  resource "termcolor" do
    url "https://pypi.python.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "argcomplete" do
    url "https://pypi.python.org/packages/68/3e/7696e1428c3f1684cf8b5dab59e3f2e6b5e07fb4e3bddff8329bc6f55b6b/argcomplete-1.4.1.tar.gz"
    sha256 "a7b5fa8d1acb69e49b3c6b3f6225bc709092e0c7f621311bac507a4f6efe609d"
  end

  resource "pyinstaller" do
    url "https://pypi.python.org/packages/33/f9/034a89276301ef5e88efd11e5ea592e3d3b2324706e65bdff7445d271077/PyInstaller-3.2.tar.gz"
    sha256 "7598d4c9f5712ba78beb46a857a493b1b93a584ca59944b8e7b6be00bb89cabc"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    if OS.mac?
      # Set -rpath option to tell gcc to look in ORACLE_HOME when linking
      ENV["ORACLE_HOME"] = "#{HOMEBREW_PREFIX}/lib"
      ENV["FORCE_RPATH"] = "TRUE"
    end

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec

    (bin/"odat.py").write <<-EOS.undent
      #!/usr/bin/env bash
      cd #{libexec} && PYTHONPATH=#{ENV["PYTHONPATH"]} python odat.py "$@"
    EOS
    libexec.install Dir['*']
  end
end
