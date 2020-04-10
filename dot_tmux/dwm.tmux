# original from https://github.com/saysjonathan/dwm.tmux/blob/master/dwm.tmux

# Create new pane in current directory
bind -n M-n split-window -b -t :.{top-left} -c "#{pane_current_path}" \;\
        select-layout main-vertical \;\
        run "tmux resize-pane -t :.1 -x \"$(echo \"#{window_width}*0.6/1\" | bc)\""

# Create new pane at end of stack
bind -n M-e split-window -t :.{bottom-right} -c "#{pane_current_path}" \;\
        select-layout main-vertical \;\
        run "tmux resize-pane -t :.1 -x \"$(echo \"#{window_width}*0.6/1\" | bc)\""

# Kill pane
bind -n C-d kill-pane \;\
        select-layout main-vertical \;\
        run "tmux resize-pane -t :.1 -x \"$(echo \"#{window_width}*0.6/1\" | bc)\"" \;\


# Next pane
bind -n M-j select-pane -t :.+

# Prev pane
bind -n M-k select-pane -t :.-

# Rotate counterclockwise
bind -n M-i rotate-window -U \; select-pane -t 0

# Rotate clockwise
bind -n M-u rotate-window -D \; select-pane -t 0

# Focus selected pane
bind -n M-f swap-pane -s :. -t :.1 \; select-pane -t :.1

# Refresh layout
bind -n M-r select-layout main-vertical \;\
        run "tmux resize-pane -t :.1 -x \"$(echo \"#{window_width}/2/1\" | bc)\""

# Zoom selected pane
bind -n M-s resize-pane -Z

