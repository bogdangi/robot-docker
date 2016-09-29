#!/bin/bash
# Entry script to start Xvfb and set display

# Set the defaults
DEFAULT_LOG_LEVEL="INFO" # Available levels: TRACE, DEBUG, INFO (default), WARN, NONE (no logging)
DEFAULT_RES="1280x1024x24"
DEFAULT_DISPLAY=":99"
DEFAULT_ROBOT_TESTS="false"
DEFAULT_OUTPUT_DIR="/tmp/"

# Use default if none specified as env var
LOG_LEVEL=${LOG_LEVEL:-$DEFAULT_LOG_LEVEL}
OUTPUT_DIR=${OUTPUT_DIR:-$DEFAULT_OUTPUT_DIR}
RES=${RES:-$DEFAULT_RES}
DISPLAY=${DISPLAY:-$DEFAULT_DISPLAY}
ROBOT_TESTS=${ROBOT_TESTS:-$ROBOT_TESTS}
echo $HOSTS >> /etc/hosts

if [[ "${ROBOT_TESTS}" == "false" ]]; then
  echo "Error: Please specify the robot test or directory as env var ROBOT_TESTS"
  exit 1
fi

# Start Xvfb
echo -e "Starting Xvfb on display ${DISPLAY} with res ${RES}"
Xvfb ${DISPLAY} -ac -screen 0 ${RES} +extension RANDR &
export DISPLAY=${DISPLAY}

# Execute tests
echo -e "Executing robot tests at log level ${LOG_LEVEL}"

if [ -z "$runner" ]
then
        runner=pybot
fi

echo
echo "#######################################"
echo "# Running tests a first time          #"
echo "#######################################"
echo

$runner --loglevel ${LOG_LEVEL}  --outputdir ${OUTPUT_DIR} ${ROBOT_TESTS}

# we stop the script here if all the tests were OK
if [ $? -eq 0 ]; then
        echo "we don't run the tests again as everything was OK on first try"
        exit 0
fi
# otherwise we go for another round with the failing tests

# we keep a copy of the first log file
cp output/log.html  output/first_run_log.html

old_output=output/output.xml

cp -r output/* .

for i in second third
do
        # we launch the tests that failed
        echo
        echo "#######################################"
        echo "# Running the tests that failed $i time"
        echo "#######################################"
        echo
        $runner --loglevel ${LOG_LEVEL}  --rerunfailed "$old_output" --output rerun_"$i".xml --outputdir ${OUTPUT_DIR} ${ROBOT_TESTS}
        result="$?"
        old_output=output/rerun_"$i".xml
        # Robot Framework generates file rerun.xml

        # we keep a copy of the second log file
        cp output/log.html  output/"$i"_run_log.html

        # Merging output files
        echo
        echo "########################"
        echo "# Merging output files #"
        echo "########################"
        echo
        rebot --outputdir ${OUTPUT_DIR} --output output.xml --merge output/output.xml  output/rerun_"$i".xml
        if [ $result -eq 0 ]; then
                echo "we don't run the tests again as everything was OK on $i try"
                cp -r output/* .
                exit 0
        fi
done

# Stop Xvfb
kill -9 $(pgrep Xvfb)
