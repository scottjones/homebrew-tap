cask "omarchy" do
  version "2.3.14"
  sha256 "ef95e2703aa5881ab4c6c01891038f80bedf2e199376460a30b68670195c3a67"

  url "https://github.com/omacom/omarchy-mac-installer/releases/download/v#{version}/Omarchy-Mac-Installer-#{version}.dmg",
      verified: "github.com/omacom/omarchy-mac-installer/"
  name "Omarchy Installer"
  desc "Installs Omarchy alongside macOS on Apple Silicon Macs"
  homepage "https://github.com/omacom/omarchy-mac-installer"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: ">= :sequoia"

  app "Omarchy Installer.app"

  # The app installs a privileged helper with SMJobBless when it first asks
  # for an administrator password. Remove it with the app.
  uninstall launchctl: "org.omarchy.installer.helper",
            delete:    [
              "/Library/LaunchDaemons/org.omarchy.installer.helper.plist",
              "/Library/PrivilegedHelperTools/org.omarchy.installer.helper",
            ]

  zap trash: [
    "~/Library/Application Support/org.omarchy.installer",
    "~/Library/Caches/org.omarchy.installer",
    "~/Library/Preferences/org.omarchy.installer.plist",
    "~/Library/Saved Application State/org.omarchy.installer.savedState",
  ]

  caveats <<~EOS
    Omarchy Installer sets up Omarchy next to macOS. It does not remove macOS.
    To remove Omarchy from this Mac later, open the app and choose Remove Omarchy
    before running `brew uninstall omarchy`.
  EOS
end
