# Pull latest version of the docker image
docker pull cdriehuys/docker-ubuntu1604-ansible:latest

# Create random file to store container ID
container_id=$(mktemp)

# Run container with role mounted inside
docker run --detach --volume="${PWD}":/etc/ansible/roles/role_under_test:ro \
--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
cdriehuys/docker-ubuntu1604-ansible:latest \
/lib/systemd/systemd > "${container_id}"

# Test role syntax
docker exec --tty "$(cat ${container_id})" env TERM=xterm \
ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml --syntax-check

# Run role first time
docker exec --tty "$(cat ${container_id})" env TERM=xterm \
ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml

# Create temp file for idempotency test results
idempotence=$(mktemp)

# Run role a second time
docker exec "$(cat ${container_id})" \
ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml \
| tee -a ${idempotence}

# Make sure second run didn't change anything
tail ${idempotence} \
| grep -q 'changed=0.*failed=0' \
&& (echo 'Idempotence test: pass' && exit 0) \
|| (echo 'Idempotence test: fail' && exit 1)

# Kill containers
docker kill "$(cat ${container_id})"
