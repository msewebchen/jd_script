#!/usr/bin/env bash

##############################################################################
#                                                                            #
#                          自动拉取各个作者库内指定脚本
#                   把此diy.sh放入config即可,会自动同步最新脚本
#                    如有好用的脚本或者脚本更新不及时请@ljhnchina
#                              2021年3月12日 16:53:47
#                                                                            #
##############################################################################

############################## 作者名称 ##############################
author_list="
ljhnchina
Tartarus2014
i-chenzhe
whyour
moposmall
qq34347476
ZCY01
Hydrahail
shuye72
cui521

"
######################################################################

############################## 维护:ljhnchina ##############################
# 维护:ljhnchina 库地址:https://github.com/ljhnchina/jd_script/
scripts_base_url_1=https://ghproxy.com/https://raw.githubusercontent.com/ljhnchina/jd_script/master/
my_scripts_list_1="
jd_crazy_joy_compose.js
jd_firecrackers.js
jd_submit_code.js
jx_cfd.js
jd_daydlt.js
jx_cfdtx.js
 
"
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

############################## 维护:Tartarus2014 ##############################
# 库地址:https://github.com/Tartarus2014/Script
scripts_base_url_2=https://ghproxy.com/https://raw.githubusercontent.com/Tartarus2014/Script/master/
my_scripts_list_2="

"
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

############################## 维护:i-chenzhe ##############################
# 库地址:https://github.com/i-chenzhe/qx
scripts_base_url_3=https://ghproxy.com/https://raw.githubusercontent.com/i-chenzhe/qx/main/
my_scripts_list_3="
jd_fanslove.js
jd_shake.js
jd_shakeBean.js
z_marketLottery.js
z_superDay.js
z_unionPoster.js

"
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

############################## 维护:whyour ##############################
# 库地址:https://github.com/whyour/hundun/tree/master/quanx
scripts_base_url_4=https://ghproxy.com/https://raw.githubusercontent.com/whyour/hundun/master/quanx/
my_scripts_list_4="

"
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

############################## 维护:moposmall ##############################
# 库地址:https://github.com/moposmall/Script/tree/main/Me
scripts_base_url_5=https://ghproxy.com/https://raw.githubusercontent.com/moposmall/Script/main/Me/
my_scripts_list_5="
jx_cfd_exchange.js

"
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

############################## 维护:qq34347476 ##############################
# 库地址:https://github.com/qq34347476/js_script
scripts_base_url_6=https://ghproxy.com/https://raw.githubusercontent.com/qq34347476/js_script/master/scripts/
my_scripts_list_6="
getShareCode_format.js

"
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

############################## 维护:ZCY01 ##############################
# 库地址:https://github.com/ZCY01/daily_scripts/tree/main/jd
scripts_base_url_7=https://ghproxy.com/https://raw.githubusercontent.com/ZCY01/daily_scripts/main/jd/
my_scripts_list_7="
jd_priceProtect.js

"
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

############################## 维护:Hydrahail ##############################
# 库地址:https://github.com/Hydrahail-Johnson/diy_scripts
scripts_base_url_8=https://ghproxy.com/https://raw.githubusercontent.com/Hydrahail-Johnson/diy_scripts/main/
my_scripts_list_8="

"
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

############################## 维护:shuye72 ##############################
# 库地址:https://gitee.com/shuye72/MyActions/tree/main ps:尽量不要使用此人脚本,
scripts_base_url_9=https://gitee.com/shuye72/MyActions/raw/main/
my_scripts_list_9="

"
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

############################## 维护:cui521 ##############################
# 库地址:https://github.com/cui521/jdqd
scripts_base_url_10=https://ghproxy.com/https://raw.githubusercontent.com/cui521/jdqd/main/
my_scripts_list_10="
DIY_shopsign.js

"
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

############################ 是否强制替换脚本的定时 ############################
# 设为"ture"时强制替换脚本的定时，设为"false"则不替换脚本的定时...
Enablerenew="false"

############################## 随机函数 ##############################
rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /proc/sys/kernel/random/uuid | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))
}

############################## 下载脚本 ##############################
cd $ScriptsDir

############################## 手动删除失效脚本 ##############################
rm -rf i-chenzhe_jd_entertainment

index=1
for author in $author_list
do
  echo -e "######################### 开始下载 $author 的脚本 #########################"
  # 下载my_scripts_list中的每个js文件，重命名增加前缀"作者昵称_"，增加后缀".new"
  eval scripts_list=\$my_scripts_list_${index}
  eval url_list=\$scripts_base_url_${index}
  for js in $scripts_list
  do
    eval url=$url_list$js
    eval name=$author"_"$js
    echo $name
    wget -q --no-check-certificate $url -O $name.new

    # 如果上一步下载没问题，才去掉后缀".new"，如果上一步下载有问题，就保留之前正常下载的版本
    if [ $? -eq 0 ]; then
      mv -f $name.new $name
      echo -e "$name 更新成功!!!"
	  croname=`echo "$name"|awk -F\. '{print $1}'`
	  script_date=`cat  $name|grep "http"|awk '{if($1~/^[0-59]/) print $1,$2,$3,$4,$5}'|sort |uniq|head -n 1`
	  [ -z "${script_date}" ] && script_date=`cat  $name|grep -Eo "([0-9]+|\*) ([0-9]+|\*) ([0-9]+|\*) ([0-9]+|\*) ([0-9]+|\*)"|sort |uniq|head -n 1`
	  if [ -z "${script_date}" ]; then
	    cron_min=$(rand 1 59)
	    cron_hour=$(rand 7 9)
      [ $(grep -c "$croname" ${ConfigDir}/crontab.list) -eq 0 ] && sed -i "/hangup/a${cron_min} ${cron_hour} * * * bash jd $croname"  ${ConfigDir}/crontab.list
	  else
	    check_existing_cron=`grep -c "$croname" /jd/config/crontab.list`
	    echo $name "开始添加定时..."
	    if [ "${check_existing_cron}" -eq 0 ]; then
	      sed -i "/hangup/a${script_date} bash jd $croname"  /jd/config/crontab.list
	      echo -e "$name 成功添加定时!!!\n"
	    else
	      if [ "${Enablerenew}" = "true" ]; then
	      	echo -e "检测到"$name"定时已存在开始替换...\n"
	        grep -v "$croname" /jd/config/crontab.list > output.txt
		      mv -f output.txt /jd/config/crontab.list
		      sed -i "/hangup/a${script_date} bash jd $croname"  /jd/config/crontab.list
	        echo -e "替换"$name"定时成功!!!"
	      else
	        echo -e "$name 存在定时,已选择不替换...\n"
	      fi
	    fi
	  fi
    else
      [ -f $name.new ] && rm -f $name.new
      echo -e "$name 脚本失效,已删除脚本...\n"
      croname=`echo "$name"|awk -F\. '{print $1}'`
      check_existing_cron=`grep -c "$croname" /jd/config/crontab.list`
      if [ "${check_existing_cron}" -ne 0 ]; then
        grep -v "$croname" /jd/config/crontab.list > output.txt
        mv -f output.txt /jd/config/crontab.list
        echo -e \b"检测到"$name"残留文件..."
        rm -f ${name:-default}
        echo -e "开始清理"$name"残留文件..."
        cd $LogDir
        rm -rf ${croname:-default}
        echo -e "清理"$name"残留文件完成!!!\n"
        cd $ScriptsDir
      fi
    fi
  done
  index=$[$index+1]
done

############################## 更新群助力脚本 ##############################
bash ${ConfigDir}/sharecode.sh

############################## 更新diy.sh ##############################
cd $ConfigDir
echo -e "开始更新 diy.sh "
wget -q --no-check-certificate https://ghproxy.com/https://raw.githubusercontent.com/ljhnchina/jd_script/master/diy.sh -O diy.sh.new
if [ $? -eq 0 ]; then
  mv -f diy.sh.new diy.sh
  echo -e "更新 diy.sh 成功!!!"
else
  rm -rf diy.sh.new
  echo -e "更新 diy.sh 失败...\n"
fi
