FROM debian:9.7-slim

LABEL "com.github.actions.name"="GitHub Action for WP Engine Git Deployment"
LABEL "com.github.actions.description"="An action to deploy your repository to a WP Engine site via git. Optimized for FWS company flow, based on jovrtn/github-action-wpengine-git-deploy."
LABEL "com.github.actions.icon"="chevrons-right"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="http://github.com/fws-solutions/wpengine-deploy-action"
LABEL "maintainer"="Boris Djemrovski <boris@forwardslashny.com>"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
