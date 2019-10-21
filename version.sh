
export MODULE_NAME=TidyUp
export MAJOR=1
export MINOR=0
export PATCH=0
export GIT_NO=`git log --oneline | wc -l`
export BUILD_NO=$(($GIT_NO + 20))

echo "Module: $MODULE_NAME"
echo "Version is $MAJOR.$MINOR.$PATCH ($BUILD_NO)"
