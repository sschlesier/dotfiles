# Create new pane in current directory
bind -n M-n split-window -b -t :.{top-left} -c "#{pane_current_path}"

# Create new pane at end of stack
bind -n M-e split-window -t :.{bottom-right} -c "#{pane_current_path}"

# adjust layout when split or pane killed
set-hook -g after-split-window 'select-layout; run "tmux resize-pane -t :.1 -x \"$(echo \"#{window_width}*0.6/1\" | bc)\""'
set-hook -g pane-exited 'select-layout; run "tmux resize-pane -t :.1 -x \"$(echo \"#{window_width}*0.6/1\" | bc)\""'

#new window default to main-vertical layout
set-hook -g window-linked 'select-layout main-vertical'

# Next pane
bind -n M-j select-pane -t :.+

# Prev pane
bind -n M-k select-pane -t :.-

# Rotate counterclockwise
bind -n M-u rotate-window -U \; select-pane -t {left}

# Rotate clockwise
bind -n M-i rotate-window -D \; select-pane -t {left}

# Focus selected pane
bind -n M-f swap-pane -s :. -t :.1 \; select-pane -t :.1

# Refresh layout
bind -n M-r select-layout main-vertical \;\
        run "tmux resize-pane -t :.1 -x \"$(echo \"#{window_width}/2/1\" | bc)\""

# Zoom selected pane
bind -n M-z resize-pane -Z

