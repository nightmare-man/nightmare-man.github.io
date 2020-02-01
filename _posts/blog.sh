fline=$(head -n 1 "$1")
time1=$(date "+%Y-%m-%d")
if [[ fline != "---" ]]
then
sed -i "1i ---" $1
sed -i "1a layout: post" $1
sed -i "2a title: ${1%.*}" $1
sed -i "3a subtitle: ${1%.*}" $1
sed -i "4a date: $time1" $1
sed -i "5a author: nightmare-man" $1
sed -i "6a tags: $2" $1
sed -i "7a ---" $1
mv $1 "$time1-$1"
git add --all
git commit -a -m "新增一篇博客"
git push origin master
else
echo "已经处理过了！"
fi
