
export MODULE_NAME=TidyUp
export MAJOR=1
export MINOR=0
export PATCH=1
export GIT_NO=`git log --oneline | wc -l`
export BUILD_NO=$(($GIT_NO + 20))
export VERSION="$MAJOR.$MINOR.$PATCH"

echo "Module: $MODULE_NAME"
echo "Version is $VERSION ($BUILD_NO)"
