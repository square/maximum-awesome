def brew_install(*packages)
  uninstalled = packages.select do |package|
    `brew list #{package}`
    !$?.success?
  end

  if uninstalled.any?
    sh "brew install #{uninstalled.join(' ')}"
  end
end

def step(description)
  description = "-- #{description} "
  description = description.ljust(80, '-')
  puts
  puts "\e[32m#{description}\e[0m"
end

desc 'Install these config files.'
task :default do
  step 'iterm2'
  unless File.directory?('/Applications/iTerm.app')
    system "curl -O http://iterm2.googlecode.com/files/iTerm2_v1_0_0.zip"
    system 'unzip iTerm2_v1_0_0.zip'
    system 'mv iTerm.app /Applications'
    system 'rm iTerm2_v1_0_0.zip'
  end

  step 'brew'
  brew_install 'ctags', 'macvim', 'reattach-to-user-namespace', 'tmux'
  # TODO for macvim, --override-system-vim

  step 'git submodules'
  sh 'git submodule update --init'

  step 'command-t'
  Dir.chdir 'vim/bundle/command-t' do
    sh "rake make"
  end

  # TODO install gem ctags?
  # TODO run gem ctags?

  step 'git templates'
  sh "git config --global init.templatedir #{File.expand_path('git_template')}"

  step 'symlink'
  rm_rf File.expand_path('~/.vim')
  ln_sf File.expand_path('tmux.conf'), File.expand_path('~/.tmux.conf'), :verbose => true
  ln_sf File.expand_path('vim'),       File.expand_path('~/.vim'),       :verbose => true
  ln_sf File.expand_path('vimrc'),     File.expand_path('~/.vimrc'),     :verbose => true

  step 'iterm2 colorschemes'
  sh 'open', '-a', '/Applications/iTerm.app', File.expand_path('iterm2-colors-solarized/Solarized Dark.itermcolors')
  sh 'open', '-a', '/Applications/iTerm.app', File.expand_path('iterm2-colors-solarized/Solarized Light.itermcolors')

  step 'iterm2 profiles'
  puts
  puts "  Your turn!"
  puts
  puts "  Go and manually set up Solarized Light and Dark profiles in iTerm2."
  puts "  Be sure to set Terminal Type to 'xterm-256color' in the 'Terminal' tab."
  puts
  puts "  Enjoy!"
  puts
end
