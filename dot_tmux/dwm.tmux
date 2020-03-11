# original from https://github.com/saysjonathan/dwm.tmux/blob/master/dwm.tmux

# Create nnw pane in current directory
bind -n M-n split-window -t :.1 -c "#{pane_current_path}" \;\
        swap-pane -s :.1 -t :.2 \;\
        select-layout main-vertical \;\
        run "tmux resize-pane -t :.1 -x \"$(echo \"#{window_width}/2/1\" | bc)\""

# Kill pane
bind -n M-x kill-pane -t :. \;\
        select-layout main-vertical \;\
        run "tmux resize-pane -t :.1 -x \"$(echo \"#{window_width}/2/1\" | bc)\"" \;\
        select-pane -t :.1


# Next pane
bind -n M-j select-pane -t :.+

# Prev pane
bind -n M-k select-pane -t :.-

# Rotate counterclockwise
bind -n M-, rotate-window -U \; select-pane -t 0

# Rotate clockwise
bind -n M-. rotate-window -D \; select-pane -t 0

# Focus selected pane
bind -n M-f swap-pane -s :. -t :.1 \; select-pane -t :.1

# Refresh layout
bind -n M-r select-layout main-vertical \;\
        run "tmux resize-pane -t :.1 -x \"$(echo \"#{window_width}/2/1\" | bc)\""

# Zoom selected pane
unbind M-m
bind -n M-m resize-pane -Z
