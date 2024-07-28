#!/bin/bash

# Configuration
DUMMY_FILE="dummy_files/test.txt"
START_DATE=$(date -d "365 days ago" +"%Y-%m-%dT%H:%M:%S")
COMMITS_PER_DAY=5

# Create the dummy file if it doesn't exist
if [ ! -f "$DUMMY_FILE" ]; then
    mkdir -p $(dirname "$DUMMY_FILE")
    touch "$DUMMY_FILE"
fi

# Function to make a commit
make_commit() {
    local DATE=$1
    echo "Dummy content for $DATE" >> $DUMMY_FILE
    git add $DUMMY_FILE
    GIT_COMMITTER_DATE="$DATE" git commit --date="$DATE" -m "Update on $DATE"
}

# Generate dummy commits for every Friday and Saturday
CURRENT_DATE=$START_DATE
while [ "$(date -d "$CURRENT_DATE" +%s)" -lt "$(date +%s)" ]; do
    DAY_OF_WEEK=$(date -d "$CURRENT_DATE" +%u)
    if [ "$DAY_OF_WEEK" -eq 5 ] || [ "$DAY_OF_WEEK" -eq 6 ]; then  # Friday or Saturday
        for i in $(seq 1 $COMMITS_PER_DAY); do
            COMMIT_TIME=$(date -d "$CURRENT_DATE +$((i * 2)) hours" +"%Y-%m-%dT%H:%M:%S")
            make_commit "$COMMIT_TIME"
        done
    fi
    CURRENT_DATE=$(date -d "$CURRENT_DATE + 1 day" +"%Y-%m-%dT%H:%M:%S")
done

echo "Dummy commits created successfully."
