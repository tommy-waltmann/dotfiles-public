#!/bin/bash
ORIGINAL_DIR=${PWD}

if [ -d "${CODE_DIR}" ]; then

    for i in "$@"; do
        case ${i} in
            -u|--update)
                DO_UPDATE=1
                echo "Updating all repos."
                shift
            ;;
            *)
                echo "Option not recognized."
            ;;
        esac
    done

    function update_repo() {
        if [ -d "$1" ]; then
            cd "$1"
            if [ -d ".git" ]; then
                if [[ $(git remote) ]]; then
                    REPO="$(basename "$(git rev-parse --show-toplevel)")"
                    BRANCH="$(git rev-parse --abbrev-ref HEAD)"
                    git fetch --quiet
                    BRANCH_EXISTS="$(git ls-remote --heads origin ${BRANCH} | wc -l)"
                    if [ "${BRANCH_EXISTS}" = "1" ]; then
                        UPSTREAM="origin/${BRANCH}"
                    else
                        UPSTREAM="origin/master"
                    fi
                    TITLE="${REPO} (${BRANCH}, ${UPSTREAM})"
                    LOCAL="$(git rev-parse HEAD)"
                    REMOTE="$(git rev-parse "${UPSTREAM}")"
                    BASE="$(git merge-base HEAD "${UPSTREAM}")"
                    BASE_MASTER="$(git merge-base HEAD origin/master)"
                    if [[ $(git diff --stat) != '' ]]; then
                        DIRTY="1"
                    else
                        DIRTY="0"
                    fi
                    if [ "${LOCAL}" = "${REMOTE}" ]; then
                        echo -e "${TITLE}:\t\033[38;5;82mUp-to-date\033[0m"
                    elif [ "${LOCAL}" = "${BASE}" ]; then
                        if [ "${LOCAL}" = "${BASE_MASTER}" ]; then
                            if [ "${DIRTY}" = "1" ]; then
                                echo -e "${TITLE}:\t\033[38;5;226mNeed to pull master, but the working tree is dirty\033[0m"
                            else
                                echo -e "${TITLE}:\t\033[38;5;226mNeed to pull master\033[0m"
                                if [ "${DO_UPDATE}" = "1" ]; then
                                    echo "Pulling ${REPO} master..."
                                    git checkout master
                                    git pull
                                fi
                            fi
                        else
                            echo -e "${TITLE}:\t\033[38;5;226mNeed to pull\033[0m"
                            if [ "${DO_UPDATE}" = "1" ]; then
                                echo "Pulling ${REPO}..."
                                git pull
                            fi
                        fi
                    elif [ "${REMOTE}" = "${BASE}" ]; then
                        echo -e "${TITLE}:\t\033[38;5;196mNeed to push\033[0m"
                    else
                        echo -e "${TITLE}:\t\033[38;5;214mDiverged\033[0m"
                    fi
                else
                    echo -e "$1:\t\033[38;5;165mNo git remote found!\033[0m"
                fi
            else
                echo -e "$1:\t\033[38;5;165mNo .git found!\033[0m"
            fi
        else
            echo "Could not find repository path: $1"
        fi
    }

    for REPO in ${CODE_DIR}/*; do
        cd ${CODE_DIR}
        if [ -d ${REPO} ]; then
            update_repo ${REPO}
        fi
    done

    cd ${ORIGINAL_DIR}

    if [ -e "${CODE_DIR}/dotfiles/home/sync.sh" ]; then
        if [ "${DO_UPDATE}" = "1" ]; then
            echo "Running dotfiles sync script..."
            ${CODE_DIR}/dotfiles/home/sync.sh
        fi
    fi
else
    echo "Environment variable \${CODE_DIR} not set or does not exist."
fi
