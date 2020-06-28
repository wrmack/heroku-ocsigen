#
# Base image
#

# Use the ocaml/opam2 staging image because don't need all architectures
# Use linux-amd64 - Heroku stacks are linux-amd64
FROM ocaml/opam2-staging:ubuntu-20.04-opam-linux-amd64

#
# Build the image layers
#

# Install required system packages (discovered by installing ocsigen interactively in running container)
RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y \
        apt-utils \
        gettext-base \
        libgdm-dev \
        libgmp-dev \
        libpcre3-dev \
        libssl-dev \
        m4 \
        perl \
        pkg-config \
        zlib1g-dev

# Initialise opam and install ocaml and ocsigen, answering all prompts with yes
# Disable sandboxing per https://github.com/ocaml/opam/issues/3498, https://github.com/ocaml/opam/issues/3424 
# Write "opam env" to bashrc (which is not read until container starts so need to add paths to ENV while building image)
# If need to reinitialise opam, use --reinit as in: RUN opam init --disable-sandboxing --reinit -y
USER opam
ENV PATH='/home/opam/.opam/default/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
ENV CAML_LD_LIBRARY_PATH='/home/opam/.opam/default/lib/stublibs:/home/opam/.opam/default/lib/ocaml/stublibs:/home/opam/.opam/default/lib/ocaml'

RUN opam init --disable-sandboxing -y \
    && echo "$(opam env)" >> /home/opam/.bashrc \
    && opam install opam-depext ocamlfind -y \
    && opam-depext -i ocsigenserver -y \
    && opam env \
    && opam clean

# Copy from current directory to image working directory
# Make script executable
# While building image layers, user is opam.  Heroku changes the user when container is started. 
WORKDIR /home/opam/ocsigen
COPY --chown=opam:opam . .
RUN chmod +x entrypoint.sh

#
# Container runtime
#

# Entrypoint script prepares ocsigen.conf using container environment variables
ENTRYPOINT ["/home/opam/ocsigen/entrypoint.sh"]

# Get ocsigenserver going
CMD ["ocsigenserver", "-c","/home/opam/ocsigen/ocsigen.conf"]
