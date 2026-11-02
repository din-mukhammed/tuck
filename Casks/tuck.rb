cask "tuck" do
  version "0.1.0"
  sha256 "3454af13fa9c4c0e01089651bfd26bf229ecd0a02fb5a5c62af8928c6b95cacf"

  url "https://github.com/din-mukhammed/tuck/releases/download/v#{version}/Tuck-#{version}.zip"
  name "Tuck"
  desc "Hide menu bar items behind a toggle"
  homepage "https://github.com/din-mukhammed/tuck"

  depends_on macos: :ventura

  app "Tuck.app"

  zap trash: "~/Library/Preferences/dev.tuck.Tuck.plist"

  caveats <<~EOS
    Tuck is not notarized yet. On first launch, open System Settings → Privacy & Security
    and click "Open Anyway" next to the Tuck message.
  EOS
end
