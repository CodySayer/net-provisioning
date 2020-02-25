
echo [fixing line endings...]
echo
find . -type f -exec dos2unix {} \;
echo
echo [line endings fixed]