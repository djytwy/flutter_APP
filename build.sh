# 构建APP的脚本，先使用Python修改版本号，再运行flutter build apk
# date: 2019-11-18
# author: twy

python3 changeVersion.py
echo '开始构建Android apk.......'
flutter build apk
now_time=$(date "+%Y年%m月%d日")
mv ./build/app/outputs/apk/release/app-release.apk "/Users/djytwy/Desktop/工单系统${now_time}.apk"
echo 'Android构建完成！'