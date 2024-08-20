if [ -f "/tmp/skip_periphery.txt" ]; then
    rm -f "/tmp/skip_periphery.txt"
    exit 0
fi
touch "/tmp/skip_periphery.txt"
"${PODS_ROOT}/Periphery/periphery" scan
