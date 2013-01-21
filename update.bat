git add *
git add -u *
set commit_msg="daily"
if exist %1 ( set commit_msg=%1)
git commit -m %commit_msg%
