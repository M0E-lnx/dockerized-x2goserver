# --- BEGIN X2Go SSH forwarding workaround ---

# Based on https://wiki.x2go.org/doku.php/doc:howto:ssh-agent-workaround

# Part that runs in regular SSH session

# check we have an agent socket and
# check we have an ~/.x2go directory
if [ -n "$SSH_AUTH_SOCK" ] && \
   [ ! -n "$DISPLAY" ]; then
        # touch the output file and set permissions
        # (as tight as possible)
        mkdir ~/.x2go
        touch ~/.x2go/agentsocket
        chmod 600 ~/.x2go/agentsocket
        chown $USER ~/.x2go/agentsocket
        # write file name of agent socket into file
        echo $SSH_AUTH_SOCK >~/.x2go/agentsocket
fi

# Part that runs in X2Go session

# check we're on an X2GoServer (x2golistsessions is in path),
# check we have a DISPLAY set,
# check ~/.x2go/agent is a regular file
if which x2golistsessions >/dev/null && \
   [ -n "$DISPLAY" ] && \
   [ -f ~/.x2go/agentsocket ] ; then
        # all checks passed, read content of file
        # (might still contain stale agent socket or garbage
        MIGHTBEOURAGENT=$(cat ~/.x2go/agentsocket)
        # check if it corresponds to an existing socket
        if [ -S "$MIGHTBEOURAGENT" ]; then
                # export path to agent socket
                export SSH_AUTH_SOCK=$MIGHTBEOURAGENT
        fi
fi


# ---- END X2Go SSH forwarding workaround ----