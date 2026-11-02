cask "tuck" do
  version "0.1.1"
  sha256 "2ce828f631a314d2ff2def0b30ecf508ec2826752011e6af824000c79b18faf5"

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
