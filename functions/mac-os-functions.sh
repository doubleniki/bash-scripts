show_hidden_files() {
  defaults write com.apple.Finder AppleShowAllFiles true
  killall Finder
}

hide_hidden_files() {
  defaults write com.apple.Finder AppleShowAllFiles false
  killall Finder
}
