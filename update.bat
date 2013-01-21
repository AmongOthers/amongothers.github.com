git add *
git add -u *
@set commit_msg=daily
@if not [%1]==[] set commit_msg=%1
git commit -m %commit_msg%
git push origin source
git gen_deploy
