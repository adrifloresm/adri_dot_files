# ~/.bash_logout: executed by bash(1) when a *login* shell exits.
# Non-login shells (e.g. `bash -i` started from a terminal emulator) do NOT
# run this file; only login shells (console logins, `ssh host`, `bash -l`).

# Clear the console on logout to reduce the chance that the next user at a
# physical TTY can scroll back and read privileged output (root sessions,
# sudo logs, etc). Only clear when $SHLVL == 1 — i.e. this is the outermost
# shell — so nested bash -l invocations don't wipe your terminal.
if [ "$SHLVL" = 1 ]; then
    # clear_console is a Debian/Ubuntu helper that does a "full" TTY wipe
    # (unlike `clear`, which only moves the cursor and leaves scrollback).
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
