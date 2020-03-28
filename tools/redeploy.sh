#!/bin/bash
serlist="./service.list"
if [ $# -ne 2 ];then
   echo "parameter error, redeploy.sh [environment] [branch/tag name]"
   echo "environment: please indicate prod or dev"
   echo "branch/tag name: git branch or tag, eg. develop,hotfix,1.0,1"
   echo "eg: redeploy.sh dev 1.0, is to redeploy tag 1.0 to dev environment "
   exit 1
fi
FLG=$1
image_tag=$2
for service in `cat ${serlist} | grep -v ^# | grep -v grep`; do
    kubectl delete -f ../${FLG}/deployment/microsrv/Deployment_${service}.yaml
    if [ $? -ne 0 ];then
       echo "kubectl delete failed"
    fi
    bash ./service_deploy_gen.sh ${FLG} ${image_tag}
    if [ $? -ne 0 ];then
       echo "deployment yaml generated failed"
       exit 1
    fi
    kubectl apply -f ../${FLG}/deployment/microsrv/Deployment_${service}.yaml
    if [ $? -ne 0 ];then
       echo "kubectl apply failed"
       exit 1
    fi
done
