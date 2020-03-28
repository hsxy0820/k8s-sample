#!/bin/bash
serlist="./service.list"
if [ $# -ne 2 ];then
   echo "parameter error, service_deploy_gen.sh [environment] [branch/tag name]"
   echo "environment: please indicate prod or dev"
   echo "branch/tag name: git branch or tag, eg. develop,hotfix,1.0,1"
   echo "eg: service_deploy_gen.sh dev 1.0, is to redeploy tag 1.0 to dev environment "
   exit 1
fi
FLG=$1
image_tag=$2
tempfile="./Deployment_${FLG}_tmp.yaml"
if [ ! -f "${serlist}" ];then
   echo "service list is not exist"
   exit 1
fi
if [ ! -f "${tempfile}" ];then
   echo "temp file is not exist"
   exit 1
fi
deploy_dir="../${FLG}/deployment/microsrv/"
if [ ! -d ${deploy_dir} ];then
   mkdir -p ${deploy_dir}
fi
for service in $(cat ${serlist} | grep -v ^# | grep -v grep );do
   cat ${tempfile} | sed "s/service_template/${service}/g" | sed "s/build_tag/${image_tag}/g" > ${deploy_dir}/Deployment_${service}.yaml
   if [ $? -ne 0 ];then
      echo "generate service file failed"
      exit 1
   fi
   echo "generate Deployment_${service}.yaml successfully!!"
done
