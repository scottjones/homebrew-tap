cask "omarchy" do
  version "2.3.15"
  sha256 "a6ee0cc214fff9f9d194772a5b4492c055c8f74d8572c1183874449d445f3d11"

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

  # Open the installer right away so the next step is on screen. This also runs
  # on `brew upgrade`, which reinstalls the app.
  postflight do
    system_command "/usr/bin/open", args: ["-a", "#{appdir}/Omarchy Installer.app"]
  end

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
