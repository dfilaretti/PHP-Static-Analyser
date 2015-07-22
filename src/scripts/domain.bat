@echo off
if -%1-==-- echo Provide name of domain directory & exit /b
if not -%2-==-- echo Provide only name of domain directory & exit /b
rm -rf domains/domain
cp -r domains/%1 domains/domain
echo Kompiling...
kompile php.k