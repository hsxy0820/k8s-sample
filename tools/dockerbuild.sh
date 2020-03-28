#!/bin/bash
if [ $# -ne 1 ];then
   echo "please indicate branch or tag name,eg: develop, 1.0.1"
   exit 1
fi
build_tag=$1
git checkout ${build_tag} 
if [ $? -ne 0 ];then
   echo "git checkout branch or tag ${build_tag} failed"
   exit 1
fi
istag=$(git tag | grep ${build_tag} | grep -v grep | wc -l)
if [ "${istag}" -eq 0 ];then 
   git pull
   if [ $? -ne 0 ];then
      echo "git pull branch ${build_tag} failed"
      exit 1
   fi
else
   echo "${build_tag} is not branch,skipped git pull"
fi
ser_list="./service.list"
if [ ! -f "${ser_list}" ];then
   echo "could not find service.list  file in current directory"
   echo "please confirm file"
   exit 1
fi
for service in $(cat ./${ser_list} | grep -v ^# | grep -v grep) ;do
  cd ../../services/${service}
  echo "building ${service}:${build_tag} "
  bash dockerbuild.sh ${service}:${build_tag}
  if [ $? -ne 0 ];then
     echo "build ${service}:${build_tag} failed!"
     exit 1
  fi
  echo "build ${service}:${build_tag} successfully"
  cd -
done
echo "Congratuation!! all services build successfully."
