require "formula"

class SqlmapExtra < Formula
  desc "Penetration testing for SQL injection and database servers (additional DB support included)"
  homepage "http://sqlmap.org"
  head "https://github.com/sqlmapproject/sqlmap"
  url "https://github.com/sqlmapproject/sqlmap", :using => :git, :revision => "f1c102a"
  version "1.1.10"
  revision 1

  #depends_on :python
  depends_on "openssl"     # pyopenssl
  depends_on "libffi"      # cffi -> pyopenssl
  depends_on "mysql"       # pymsql
  depends_on "postgresql@9.6"  # psycopg2
  depends_on "freetds@0.91" # mymssql

  resource "pymssql" do
    url "https://pypi.python.org/packages/4c/c8/5ad36d8d3c304ab4f310c89d0593ab7b6229568dd8e9cde927311b2f0c00/pymssql-2.1.3.tar.gz"
    sha256 "afcef0fc9636fb059d8e2070978d8b66852f4046531638b12610adc634152427"
  end

  resource "pymysql" do
    url "https://pypi.python.org/packages/97/17/a8cbe4281fe212a8bbf9027323cfcd8e0a7f2eed4675ebcdf87adbd15a7c/PyMySQL-0.7.2.tar.gz"
    sha256 "bd7acb4990dbf097fae3417641f93e25c690e01ed25c3ed32ea638d6c3ac04ba"
  end

  resource "impacket" do
    url "https://pypi.python.org/packages/be/6c/c0804242bc184d916658ec18130a017b4ec01ecbf2ec7ca3898f1de5c63c/impacket-0.9.14.tar.gz"
    sha256 "78a28021014c880da7336b529ed813f42c4a79fdc86d8ad38a579744abfcb71b"
  end

  # required by impacket
  resource "pyasn1" do
    url "https://pypi.python.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  # required by impacket
  resource "pycrypto" do
    url "https://pypi.python.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  # required by impacket
  resource "pyopenssl" do
    url "https://pypi.python.org/packages/77/f2/bccec75ca4280a9fa762a90a1b8b152a22eac5d9c726d7da1fcbfe0a20e6/pyOpenSSL-16.0.0.tar.gz"
    sha256 "363d10ee43d062285facf4e465f4f5163f9f702f9134f0a5896f134cbb92d17d"
  end

  # required by pyopenssl
  resource "cryptography" do
    url "https://pypi.python.org/packages/92/ea/e7d512719dcc672ce7ed5d70f188e45e329c4bcf7c94528fbc7efa138d8a/cryptography-1.3.1.tar.gz"
    sha256 "b4b36175e0f95ddc88435c26dbe3397edce48e2ff5fe41d504cdb3beddcd53e2"
  end

  # required by cryptography -> pyopenssl
  resource "idna" do
    url "https://pypi.python.org/packages/fb/84/8c27516fbaa8147acd2e431086b473c453c428e24e8fb99a1d89ce381851/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  # required by cryptography -> pyopenssl
  resource "enum34" do
    url "https://pypi.python.org/packages/eb/c2/ea4077a72a167fb75f38bac63801910dfa2d5083e23ddaa0c4062848f78c/enum34-1.1.4.tar.gz"
    sha256 "0efc3e3ee0cb7cc12ea9e4813cdf1154f69ab47e518f4924fbd9e238df41d628"
  end

  # required by cryptography -> pyopenssl
  resource "ipaddress" do
    url "https://pypi.python.org/packages/cd/c5/bd44885274379121507870d4abfe7ba908326cf7bfd50a48d9d6ae091c0d/ipaddress-1.0.16.tar.gz"
    sha256 "5a3182b322a706525c46282ca6f064d27a02cffbd449f9f47416f1dc96aa71b0"
  end

  # required by cryptography -> pyopenssl
  resource "cffi" do
    url "https://pypi.python.org/packages/b6/98/11feff87072e2e640fb8320712b781eccdef05d588618915236b32289d5a/cffi-1.6.0.tar.gz"
    sha256 "a7f75c4ef2362c0a0e54657add0a6c509fecbfa3b3807bc0925f5cb1c9f927db"
  end

  # required by cryptography -> pyopenssl
  resource "six" do
    url "https://pypi.python.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  # required by cffi -> cryptography -> pyopenssl
  resource "pycparser" do
    url "https://pypi.python.org/packages/6d/31/666614af3db0acf377876d48688c5d334b6e493b96d21aa7d332169bee50/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "python-ntlm" do
    url "https://pypi.python.org/packages/10/0e/e7d7e1653852fe440f0f66fa65d14dd21011d894690deafe4091258ea855/python-ntlm-1.1.0.tar.gz"
    sha256 "35ffa68216a3622860f34b7dd49df77dde22136ae37ffcd57e3f8dd26b218c61"
  end

  resource "websocket-client" do
    url "https://pypi.python.org/packages/a3/1e/b717151e29a70e8f212edae9aebb7812a8cae8477b52d9fe990dcaec9bbd/websocket_client-0.37.0.tar.gz"
    sha256 "678b246d816b94018af5297e72915160e2feb042e0cde1a9397f502ac3a52f41"
  end

  resource "psycopg2" do
    url "https://pypi.python.org/packages/86/fd/cc8315be63a41fe000cce20482a917e874cdc1151e62cb0141f5e55f711e/psycopg2-2.6.1.tar.gz"
    sha256 "6acf9abbbe757ef75dc2ecd9d91ba749547941abaffbe69ff2086a9e37d4904c"
  end

  resource "ibm-db" do
    url "https://pypi.python.org/packages/54/8a/54857a841cbd485d68f9852dfc16d27b069987a65ade38bb9288471ae98b/ibm_db-2.0.7.tar.gz"
    sha256 "3db1dab4f5ea2efa37b3e8cdda0f19e60a37c716f56a12455dd40e8dad56e64f"
  end

  #resource "pyodbc" do
  #  url "https://pypi.python.org/packages/9c/6f/27ffd47f56226e572bb8cf06a8355d8ed875b49b8317e73a95c20fb599d1/pyodbc-3.0.10.tar.gz"
  #  sha256 "a66d4f347f036df49a00addf38ca6769ad52f61acdb931c95bc3a9245d8f2b58"
  #end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    (bin/"sqlmap.py").write <<-EOS.undent
      #!/usr/bin/env bash
      cd #{libexec} && PYTHONPATH=#{ENV["PYTHONPATH"]} python sqlmap.py "$@"
    EOS
    (bin/"sqlmapapi.py").write <<-EOS.undent
      #!/usr/bin/env bash
      cd #{libexec} && PYTHONPATH=#{ENV["PYTHONPATH"]} python sqlmapapi.py "$@"
    EOS
    libexec.install Dir['*']
  end
end
