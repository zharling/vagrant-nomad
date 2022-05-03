# Simple Vagrant build for a 3 node consul/nomad cluster
This is mainly for my own use, a way to learn and quickly reset and try different options.

I initially used Ubuntu but had issues with the exec and java drivers, centos sort of just worked out of the box.  Something for another time...

Requirements:
- Vagrant
- VirtualBox
- VirtualBox Guest Additions `vagrant plugin install vagrant-vbguest`

Should just need to run `vagrant up` and it will build out the 3 nodes.  Once complete, or at least within a few minutes, the consul and nomad clusters should have elected a leader and be ready to roll.


```
vagrant plugin install vagrant-vbguest
vagrant up

vagrant status

vagrant ssh nomad-1
```
Check Consul
```
[vagrant@nomad-1 ~]$ consul members
Node     Address              Status  Type    Build   Protocol  DC   Partition  Segment
nomad-1  192.168.56.101:8301  alive   server  1.12.0  2         dc1  default    <all>
nomad-2  192.168.56.102:8301  alive   server  1.12.0  2         dc1  default    <all>
nomad-3  192.168.56.103:8301  alive   server  1.12.0  2         dc1  default    <all>
```
Check Nomad
```
[vagrant@nomad-1 ~]$ nomad server members
Name            Address         Port  Status  Leader  Protocol  Build  Datacenter  Region
nomad-1.global  192.168.56.101  4648  alive   false   2         1.2.6  dc1         global
nomad-2.global  192.168.56.102  4648  alive   false   2         1.2.6  dc1         global
nomad-3.global  192.168.56.103  4648  alive   true    2         1.2.6  dc1         global

[vagrant@nomad-1 ~]$ nomad node status
ID        DC   Name     Class   Drain  Eligibility  Status
b6933058  dc1  nomad-2  <none>  false  eligible     ready
2bc3e9f2  dc1  nomad-1  <none>  false  eligible     ready
2256db7a  dc1  nomad-3  <none>  false  eligible     ready

```

Check Nomad agent's `Driver Status`
```
[vagrant@nomad-1 ~]$ nomad node status b6933058
ID              = b6933058-78d0-d690-064e-c9599813c332
Name            = nomad-2
Class           = <none>
DC              = dc1
Drain           = false
Eligibility     = eligible
Status          = ready
CSI Controllers = <none>
CSI Drivers     = <none>
Uptime          = 8m31s
Host Volumes    = <none>
Host Networks   = <none>
CSI Volumes     = <none>
Driver Status   = docker,exec,java

Node Events
Time                  Subsystem  Message
2022-05-03T14:01:05Z  Cluster    Node registered

Allocated Resources
CPU         Memory       Disk
0/4606 MHz  0 B/1.3 GiB  0 B/58 GiB

Allocation Resource Utilization
CPU         Memory
0/4606 MHz  0 B/1.3 GiB

Host Resource Utilization
CPU          Memory           Disk
68/4606 MHz  305 MiB/1.3 GiB  3.7 GiB/62 GiB

Allocations
No allocations placed
```


* Note: If you need to change the Vagrant IP's, make sure to update teh nomad/consul config files for the retry_clients.

## Helpful commands
```
# Check node status
nomad node status

# check server members
nomad server members

```

## Jobs
Run test job

```
nomad job run /vagrant/jobs/zack-currenttime.nomad
```
Get job Allocation
```
[vagrant@nomad-1 ~]$ nomad job status
ID           Type     Priority  Status   Submit Date
currenttime  service  50        running  2022-05-03T14:07:30Z
[vagrant@nomad-1 ~]$ nomad job status currenttime
ID            = currenttime
Name          = currenttime
Submit Date   = 2022-05-03T14:07:30Z
Type          = service
Priority      = 50
Datacenters   = dc1
Namespace     = default
Status        = running
Periodic      = false
Parameterized = false

Summary
Task Group   Queued  Starting  Running  Failed  Complete  Lost
currenttime  0       0         1        0       0         0

Latest Deployment
ID          = 79683d1a
Status      = successful
Description = Deployment completed successfully

Deployed
Task Group   Desired  Placed  Healthy  Unhealthy  Progress Deadline
currenttime  1        1       1        0          2022-05-03T14:18:00Z

Allocations
ID        Node ID   Task Group   Version  Desired  Status   Created    Modified
55b2533d  2bc3e9f2  currenttime  0        run      running  2m45s ago  2m16s ago
```
Get job allocation logs
```
[vagrant@nomad-1 ~]$ nomad alloc logs 55b2533d
Running on http://0.0.0.0:8080
```
Stop and purge job
```
nomad job stop -purge currenttime
```


## Web interfaces
- Consul: http://192.168.56.101:8500/ui/
- Nomad: http://192.168.56.101:4646/ui/jobs


## Links
https://www.hashicorp.com/blog/the-kubernetes-to-nomad-cheat-sheet
