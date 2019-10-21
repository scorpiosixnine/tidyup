
MAJOR=1
MINOR=0
PATCH=3
GIT_NO=`git log --oneline | wc -l`
BUILD_NO=$(($GIT_NO + 20))

echo "Version is $MAJOR.$MINOR.$PATCH ($BUILD_NO)"
