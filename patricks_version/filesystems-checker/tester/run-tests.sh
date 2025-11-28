#!/bin/bash

NUM_TESTS=25

# Directory to store results
# RESULTS_DIR="tests_results"
# mkdir -p "$RESULTS_DIR"

echo "Starting tests..."
CURRENT_DIR=$(pwd)

RESULTS_FILE="tester/results.txt"
# Clear the previous results if the file exists
> "$RESULTS_FILE"
echo "Previous test cleared from results.txt"

# Loop through each test file
for i in $(seq 1 $NUM_TESTS); do
    
    TEST_FILE="tests/${i}.run"
    DESC_FILE="tests/${i}.desc"
    OUT_FILE="tests/${i}.out"
    ERR_FILE="tests/${i}.err"
    RC_FILE="tests/${i}.rc"

    echo "Running test: $TEST_FILE"

    # Check if the test file exists
    if [[ -f "$TEST_FILE" ]]; then
        # Execute the test file and redirect stdout and stderr
        bash "$TEST_FILE" > "$OUT_FILE" 2> "$ERR_FILE"
        
        # Capture the return code
        echo $? > "$RC_FILE"

        # Optional: Display description if available
        if [[ -f "$DESC_FILE" ]]; then
            echo "Description: $(cat "$DESC_FILE")"
        fi

        echo "Output saved to: $OUT_FILE"
        echo "Errors saved to: $ERR_FILE"
        echo "Return code saved to: $RC_FILE"

        {
            echo "========== Test ${i} =========="
            echo "--- Standard Output ---"
            cat "${OUT_FILE}"
            echo ""
            echo "--- Standard Error ---"
            cat "${ERR_FILE}"
            echo ""
            echo "Return code: $?"
            echo "==========        =========="
            echo ""
        } >> $RESULTS_FILE
    else
        echo "Skipping: $TEST_FILE not found."
        {
            echo "========== Test ${i} =========="
            echo ""
            echo "Error: Test File not Found "
            echo ""
            echo "Return code: $?"
            echo "==========        =========="
            echo ""
        } >> $RESULTS_FILE
    fi
    echo "-----------------------------------"
done

echo "Tests complete."