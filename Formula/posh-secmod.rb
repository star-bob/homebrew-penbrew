require "formula"

class PoshSecmod < Formula
  homepage "https://github.com/darkoperator/Posh-SecMod"
  head "https://github.com/darkoperator/Posh-SecMod", :using => :git, :branch => "master"
  url "https://github.com/darkoperator/Posh-SecMod", :using => :git, :revision => "250e9b0"
  version "0.20150812"

  def install
    pkgshare.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    The Posh-SecMod scripts can be found in #{HOMEBREW_PREFIX}/share/posh-secmod
    EOS
  end
end
