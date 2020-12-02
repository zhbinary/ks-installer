curl -O -k https://kubernetes.pek3b.qingstor.com/tools/kubekey/kk
chmod +x kk
yum install -y vim openssl socat conntrack ipset
echo -e 'yes\n' | /root/kk create cluster --with-kubesphere


kubectl -n kubesphere-system patch cc ks-installer --type merge --patch '{"spec":{"devops":{"enabled":"true"}}}'
kubectl -n kubesphere-system patch cc ks-installer --type merge --patch '{"spec":{"logging":{"enabled":"true"}}}'
kubectl -n kubesphere-system patch cc ks-installer --type merge --patch '{"spec":{"metrics_server":{"enabled":"true"}}}'

for ((n=0;n<6;n++))
do  
    OK=`kubectl get pod -A| grep -E 'Running|Completed' | wc | awk '{print $1}'`
    Status=`kubectl get pod -A | wc | awk '{print $1}'`
    if [[ $OK == $Status ]]
    then
        n=$((n+1))
    else
        n=0
    fi
    sleep 5
done

kubectl get all -A