FROM gitpod/workspace-full

# Surge.sh will be installed in /home/gitpod/.yarn/bin
RUN yarn global add surge @vue/cli

# This will export global BIN location from Yarn
# so we can run binaries from there
RUN export PATH="$(yarn global bin):$PATH"