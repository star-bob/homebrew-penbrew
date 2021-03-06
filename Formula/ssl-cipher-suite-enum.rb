require 'formula'

class SslCipherSuiteEnum < Formula
  homepage "https://labs.portcullis.co.uk/tools/ssl-cipher-suite-enum/"
  url "https://labs.portcullis.co.uk/download/ssl-cipher-suite-enum-v1.0.2.tar.gz"
  sha256 "1d5b475e02eb11fe7569bff892c22620e3c6ab2217fbc44978dbf7f848120ef9"
  version "1.0.2"
  revision 2

  depends_on "perl"

  resource "IO::Socket::INET" do
    url "http://search.cpan.org/CPAN/authors/id/G/GB/GBARR/IO-1.25.tar.gz"
    sha256 "89790db8b9281235dc995c1a85d532042ff68a90e1504abd39d463f05623e7b5"
  end

  resource "Getopt-Long" do
    url "http://search.cpan.org/CPAN/authors/id/J/JV/JV/Getopt-Long-2.48.tar.gz"
    sha256 "d5852a2f526535d14af7c5428098d74bae26c71f7b0aa72e5736db174b9d755b"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    libexec.install "ssl-cipher-suite-enum.pl"
    (bin/"ssl-cipher-suite-enum.pl").write <<-EOS.undent
      #!/bin/sh
      /usr/bin/env perl -I "#{ENV["PERL5LIB"]}" #{libexec}/ssl-cipher-suite-enum.pl "$@"
    EOS
  end
end
