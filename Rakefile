def brew_install(*packages)
  uninstalled = packages.select do |package|
    `brew list #{package}`
    !$?.success?
  end

  if uninstalled.any?
    system "brew install #{uninstalled.join(' ')}"
  end
end

desc 'Install these config files.'
task :default do
  brew_install 'ctags', 'macvim', 'reattach-to-user-namespace', 'tmux'

  system 'git submodule update --init'

  Dir.chdir 'vim/bundle/command-t' do
    system "PATH=/bin:/usr/bin:$HOME/.rvm/bin rvm system do rake make"
  end

  # include solarized colorschemes for iTerm2, and configure them?
  # install gem ctags?
  # run gem ctags?

  system "git config --global init.templatedir #{File.expand_path('git_template')}"

  rm_rf File.expand_path('~/.vim')
  ln_sf File.expand_path('tmux.conf'), File.expand_path('~/.tmux.conf'), :verbose => true
  ln_sf File.expand_path('vim'),       File.expand_path('~/.vim'),       :verbose => true
  ln_sf File.expand_path('vimrc'),     File.expand_path('~/.vimrc'),     :verbose => true
end
