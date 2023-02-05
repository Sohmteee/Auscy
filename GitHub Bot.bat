@echo off

:start
if exist .git goto update
if not exist .git goto create

:update
echo.
echo Checking git status...
git status

git add .

echo.
echo Adding commits...
git commit --date "19 days ago" -m "commit"
echo Added commits successfully

echo.
echo Pushing git...
git push

goto end

:create
echo It looks like you haven't added this project to your GitHub yet
echo Let's quickly set it up!

echo.
git init

git add .

echo.
echo Adding commit...
git commit -m "commit"
echo Added commit successfully

git branch -M main

echo.
echo Copy and Paste the link to your GitHub repository
echo It should look something like "https://github.com/<your username>/<name of repository>.git"
set /p rep= Paste the link here: 
git remote add origin %rep%

echo.
echo Pushing git...
git push -u origin main

goto end

:end
timeout 5
cls
goto start
