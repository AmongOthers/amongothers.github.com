git add *
git add -u *
set commit_msg=hello
if not %1 == "" set commit_msg=%1
echo %commit_msg%
git commit -m %commit_msg%
